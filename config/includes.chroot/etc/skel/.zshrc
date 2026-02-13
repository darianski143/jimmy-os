export ZSH_DISABLE_COMPFIX=true
autoload -Uz compinit
compinit

PROMPT='%F{cyan}%n@%m%f %F{yellow}%~%f %# '
alias ll='ls -lah'
alias update='sudo apt update && sudo apt upgrade'
