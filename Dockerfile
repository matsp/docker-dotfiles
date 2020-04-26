FROM archlinux:latest

ENV TERM xterm-256color
ENV USER mats
ENV GIT_USER="Mats\ Pfeiffer"
ENV GIT_EMAIL="mats.pfeiffer@googlemail.com"

RUN echo 'Server = https://mirror.pkgbuild.com/$repo/os/$arch' > /etc/pacman.d/mirrorlist

# dependencies
RUN pacman -Suy --needed --noconfirm base-devel sudo libffi unzip git vim zsh powerline powerline-fonts docker docker-compose

# user setup
RUN groupadd $USER \
  && useradd -m -g $USER -s /usr/bin/zsh $USER
RUN echo "%$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER $USER
WORKDIR /home/$USER
RUN mkdir -p git

# yay
RUN cd ~/git \
	&& git clone https://aur.archlinux.org/yay.git \
	&& cd yay \
	&& makepkg -si --noconfirm

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

# cleanup
RUN yay -Rsn --noconfirm base-devel \
	&& yes "y" | yay -Scc

ENTRYPOINT ["zsh"]
