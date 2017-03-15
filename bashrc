# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f ~/.bash_aliases ]; then
      . ~/.bash_aliases
fi
if [ -f ~/.ps1_git ]; then
      . ~/.ps1_git
fi

export HISTCONTROL=ignoredups:erasedups # no duplicate entries
export HISTSIZE=100000                  # big big history
export HISTFILESIZE=100000              # big big history
shopt -s histappend                     # append to history, don't overwrite it

# setup color variables
COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_BLUE="\033[0;34m"
COLOR_WHITE="\033[0;37m"
COLOR_RESET="\033[0m"

function git_color {
  local git_status="$(git status 2> /dev/null)"

  if [[ ! $git_status =~ "working directory clean" ]]; then
    echo -e $COLOR_RED
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $COLOR_YELLOW
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e $COLOR_GREEN
  else
    echo -e $COLOR_OCHRE
  fi
}

function git_branch {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "+$branch"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "-$commit"
  fi
}

PS1="\[$COLOR_WHITE\][\u@local \W]"          # basename of pwd
PS1+="\[\$(git_color)\]"        # colors git status
PS1+="\$(git_branch) "           # prints current branch
PS1+="\[$COLOR_BLUE\]\$\[$COLOR_RESET\] "   # '#' for root, else '$'
export PS1



# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

PERL_MB_OPT="--install_base \"/home/rlins/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/rlins/perl5"; export PERL_MM_OPT;

# Instalacao das Funcoes ZZ (www.funcoeszz.net)
export ZZOFF=""  # desligue funcoes indesejadas
export ZZPATH="$HOME/github/linux-utils/funcoeszz-15.5.sh"  # script
source "$ZZPATH"
source "$HOME/github/linux-utils/futils.sh" # script futils
