#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Color variables
color_reset='\e[0m'
color_red='\e[31m'
color_green='\e[32m'
color_brown='\e[33m'
color_blue='\e[34m'
color_purple='\e[35m'

# Color support
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'

# Prompt
PS1="${color_blue}\W${color_reset}"

if [ -f /usr/share/git/completion/git-prompt.sh ]; then
  . /usr/share/git/completion/git-prompt.sh
  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWSTASHSTATE=1
  GIT_PS1_SHOWUNTRACKEDFILES=1
  GIT_PS1_SHOWUPSTREAM=1
  PS1=${PS1}${color_purple}'$(__git_ps1 " (%s)")'${color_reset}
fi

prompt_color=$color_green

if [ "$EUID" == "0" ]; then 
  # Root user
  prompt_color=$color_red
fi

PS1="${PS1} ${prompt_color}\\\$${color_reset} "

if [ -f /usr/share/bash-preexec/bash-preexec.sh ]; then
  . /usr/share/bash-preexec/bash-preexec.sh

  function preexec() {
    start=$(date +%s)
  }

  function precmd() {
    if [ "$start" == "" ]; then
      return 0
    fi
    end=$(date +%s)
    elapsed=$((end-start))
    start=
    if [ $elapsed -eq 0 ]; then
      return 0
    elif [ $elapsed -gt 3600 ]; then
      formatted=$(date -d@${elapsed} -u +%-Hh%-Mm%-Ss)
    elif [ $elapsed -gt 60 ]; then
      formatted=$(date -d@${elapsed} -u +%-Mm%-Ss)
    else
      formatted=${elapsed}s
    fi
    printf "took ${color_brown}%s${color_reset} " "$formatted"
  }
fi

# Bash completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi
