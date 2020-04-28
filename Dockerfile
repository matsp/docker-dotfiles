FROM archlinux:latest

ENV TERM xterm-256color
ENV USER mats
ENV GIT_USER="Mats\ Pfeiffer"
ENV GIT_EMAIL="mats.pfeiffer@googlemail.com"

RUN echo 'Server = https://mirror.pkgbuild.com/$repo/os/$arch' > /etc/pacman.d/mirrorlist

# dependencies
RUN pacman -Sy --needed --noconfirm sudo git vim zsh zsh-completions powerline powerline-fonts 

# arch setup
RUN sed -i "s/PKGEXT='.pkg.tar.xz'/PKGEXT='.pkg.tar'/g" /etc/makepkg.conf

# user setup
RUN groupadd $USER \
	&& useradd -m -g $USER -s /usr/bin/zsh $USER \
 	&& echo "$USER:$USER" | chpasswd \
	&& echo "%$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER $USER
WORKDIR /home/$USER

# yay
RUN git clone https://aur.archlinux.org/yay.git \
	&& cd yay \
	&& sudo pacman -Sy --needed --noconfirm base-devel libffi \
	&& makepkg -si --noconfirm ~/yay \
	&& cd .. \
	&& yay -Rnu --noconfirm go base-devel libffi \
	&& yes "y" | yay -Scc \
       	&& rm -rf yay	

# dotfiles
RUN cd ~ \
	&& git init \
	&& git remote add origin https://github.com/matsp/dotfiles.git \
	&& git pull origin master \
	&& source ~/.zshrc &> /dev/null

# git setup
RUN git config --global user.name $GIT_USER \
	&& git config --global user.email $GIT_EMAIL

# vim
RUN vim +PlugInstall +qall &> /dev/null

ENTRYPOINT ["zsh"]
