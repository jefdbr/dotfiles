HISTFILE=~/.config/zsh/.histfile
HISTSIZE=5000
SAVEHIST=100000
setopt autocd extendedglob
unsetopt beep
bindkey -v

eval $(keychain --eval --quiet id_rsa)

zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**'
zstyle :compinstall filename '/home/jeffrey/.zshrc'
PS1='%F{red}%n%F{white}@%F{yellow}%m%F{white}:%F{cyan}%2~%F{white}%# %F{reset}'

autoload -Uz compinit
compinit

alias update='yay -Syu --noconfirm'
alias vim="nvim"
alias ssh='TERM=xterm ssh'
alias ls='ls --color=auto'
alias o='xdg-open'
alias size='du --max-depth=1 -h'
alias dwengo_db_run='echo -n "Postgres password: " && read -s password && echo \
            && sudo docker run --name db \
            -e POSTGRES_USER=postgres \
            -e POSTGRES_PASSWORD=$password \
            -e POSTGRES_DB=dwengo_db \
            -p 5432:5432 -d postgres'
alias dwengo_db_rm='sudo docker stop db && sudo docker rm db'
