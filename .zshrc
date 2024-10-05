#!/bin/zsh

set -o emacs

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:git*' formats " (%b)"
precmd() {
    vcs_info
}

setopt prompt_subst
# prompt='%F{green}%3~${vcs_info_msg_0_} %#%f '
prompt='%F{green}%3~${vcs_info_msg_0_}
ॐ %f '

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zmodload zsh/complist

setopt autocd
setopt GLOB_DOTS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt APPEND_HISTORY

export WORDCHARS='*?_~&;!#$%^'
export HISTSIZE=10000000
export SAVEHIST=10000000
export MANWIDTH=80
 
alias mv="mv -iv"
alias cp="cp -iv"
alias ls="ls --color"
alias diff="diff --color"
alias grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}"

alias ga="git add"
alias gb="git branch"
alias gcm="git commit"
alias gg="git commit"
alias gch="git checkout"
alias gd="git diff"
alias gull="git pull"
alias gush="git push"
alias gst="git status"
alias groot="cd \$(git rev-parse --show-toplevel)"
alias gl="git log"
alias glo="git log --pretty='oneline'"
alias glol="git log --graph --oneline --decorate"

alias l="ls -hvA"
alias ll="ls -lhvA"

load_nvm() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
}
