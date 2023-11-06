#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# History
export HISTCONTROL=ignoreboth

# Color variables
color_reset='\e[0m'
color_red='\e[1;31m'
color_green='\e[1;32m'
color_brown='\e[1;33m'
color_blue='\e[1;34m'
color_purple='\e[1;35m'

# Color support
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'

# Prompt
PS1="\[${color_blue}\]\W\[${color_reset}\]"

if [ -z "$GIT_PROMPT" ]; then
  if [ -f /usr/share/git/completion/git-prompt.sh ]; then
    GIT_PROMPT=/usr/share/git/completion/git-prompt.sh
  fi
fi

if [ -n "$GIT_PROMPT" ]; then
  . "$GIT_PROMPT"
  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWSTASHSTATE=1
  GIT_PS1_SHOWUNTRACKEDFILES=1
  GIT_PS1_SHOWUPSTREAM=1
  PS1="${PS1}\[${color_purple}\]"'$(__git_ps1 " (%s)")'"\[${color_reset}\]"
fi

prompt_color=$color_green

if [ "$EUID" == "0" ]; then 
  prompt_color=$color_red
fi

PS1="${PS1} \[${prompt_color}\]\\\$\[${color_reset}\] "

if [ -z "$BASH_PREEXEC" ]; then
  if [ -f /usr/share/bash-preexec/bash-preexec.sh ]; then
    BASH_PREEXEC=/usr/share/bash-preexec/bash-preexec.sh
  fi
fi

if [ -n "$BASH_PREEXEC" ]; then
  . "$BASH_PREEXEC"

  function preexec() {
    start=$(date +%s)

    # show last command name
    lastcmd=$(history 1 | cut -c8-)
    echo -ne "\e]2;$lastcmd\a\e]1;$lastcmd\a";
  }

  function precmd() {
    PS1=$(echo -n "$PS1" | sed -r 's/took \\\[\\e\[33m\\\]([0-9]+s|[0-9]+m[0-9]+s|[0-9]+h[0-9]+m[0-9]+s)\\\[\\e\[0m\\\] //g')
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

    PS1="took \[${color_brown}\]${formatted}\[${color_reset}\] ${PS1}"
  }
fi

# Bash completion
if [ -z "$BASH_COMPLETION" ]; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    BASH_COMPLETION=/usr/share/bash-completion/bash_completion
  fi
fi

if [ -n "$BASH_COMPLETION" ]; then
  . "$BASH_COMPLETION"
fi

# Fuzzy finder
if [ -z "$FZF_KEY_BINDINGS" ]; then
  if [ -f /usr/share/fzf/key-bindings.bash ]; then
    FZF_KEY_BINDINGS=/usr/share/fzf/key-bindings.bash
  fi
fi

if [ -n "$FZF_KEY_BINDINGS" ]; then
  . "$FZF_KEY_BINDINGS"
fi

