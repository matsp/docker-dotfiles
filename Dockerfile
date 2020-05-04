FROM alpine:3.11

ENV USER="mats"
ENV GIT_USER="Mats\ Pfeiffer"
ENV GIT_EMAIL="mats.pfeiffer@googlemail.com"

# dependencies
RUN apk add --no-cache git vim zsh zsh-vcs curl

# user setup
RUN addgroup $USER \
  && adduser -D -s /usr/bin/zsh -G $USER $USER \
  && echo "$USER:$USER" | chpasswd

USER $USER
WORKDIR /home/$USER

# setup
RUN git init \
  && git remote add origin https://github.com/matsp/dotfiles.git \
  && git pull origin master \
  && source ~/.zshrc &> /dev/null \
  && git config --global user.name $GIT_USER \
  && git config --global user.email $GIT_EMAIL \
  && vim +PlugInstall +qall &> /dev/null

ENTRYPOINT ["zsh"]
