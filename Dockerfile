FROM alpine:3.11

ARG USER
ARG DOTFILES_GIT_URL
ARG GIT_USER
ARG GIT_EMAIL

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
  && git remote add origin $DOTFILES_GIT_URL \
  && git pull origin master \
  && source ~/.zshrc &> /dev/null \
  && git config --global user.name $GIT_USER \
  && git config --global user.email $GIT_EMAIL \
  && mkdir -p ~/projects
RUN vim +PlugInstall +qall &> /dev/null

ENTRYPOINT ["zsh"]
