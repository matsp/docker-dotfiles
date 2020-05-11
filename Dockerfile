FROM alpine:3.11

ARG USER
ARG DOTFILES_GIT_URL
ARG GIT_USER
ARG GIT_EMAIL
ARG USER_ID
ARG GROUP_ID
ARG DOCKER_GROUP_ID

# dependencies
RUN apk add --no-cache git vim zsh zsh-vcs curl docker-cli

# user setup
RUN addgroup -g $GROUP_ID $USER \
  && addgroup -g $DOCKER_GROUP_ID docker \
  && adduser -D -s /usr/bin/zsh --uid $USER_ID -G $USER $USER \
  && addgroup $USER docker \
  && echo "$USER:$USER" | chpasswd

USER $USER
WORKDIR /home/$USER

# setup
RUN git init \
  && git remote add origin $DOTFILES_GIT_URL \
  && git pull origin master \
  && source ~/.zshrc &> /dev/null \
  && git config --global user.name "$GIT_USER" \
  && git config --global user.email "$GIT_EMAIL"
RUN vim +PlugInstall +qall &> /dev/null

ENTRYPOINT ["zsh"]
