#!/bin/bash
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

export SHELL=/bin/bash
export TERM=xterm
export STARSHIP_CONFIG=~/starship.toml

function get_hostname {
  export SHORTNAME=${HOSTNAME%%.*}
}

#function git_branch() { 
#  gitbranch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'); 
#}

#function user_color {
#  id | grep "root" > /dev/null
#  RETVAL=$?
#  if [[ $RETVAL == 0 ]]; then
#    usercolor="[0;31m";
#  else
#    usercolor="[0;32m";
#  fi
#}

#function settitle() {
#  u=${USERNAME}
#  h="$u@${HOSTNAME}"
#  echo -ne "\e]2;$h\a\e]1;$h\a";
#}

# Set directory colors
#eval `dircolors ~/.dir_colors`


#user_color
#PROMPT_COMMAND='settitle; git_branch; get_hostname; history -a;'
#PS1='\[\e${usercolor}\][\u]\[\e${cwdcolor}\][${PWD}]\[\e${branchcolor}\]${gitbranch}\[\e${inputcolor}\] ~ $ '
#PS1='\n\[\e${cwdcolor}\][${PWD}] \[\e${branchcolor}\]${gitbranch}\n\ [\e${usercolor}\][\u] \[\e${host_name}\][${SHORTNAME}]\[\e${inputcolor}\] $ '
#export PS1

# Aliases
#alias ls='ls -a -l --color'
alias grep='grep -n --color'
alias ls=' exa --header --long -a'


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/andrew/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/andrew/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/andrew/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/andrew/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

eval "$(starship init bash)"

