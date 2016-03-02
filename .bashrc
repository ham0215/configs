# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions
alias taild='tail -f `ls -1 ~/dev/*/log/*.log | grep -v inchtm`'
alias vi="~/local/bin/vim -u ~/.vimrc-local"
alias gittree="git log --graph --pretty='format:%C(yellow)%h%Creset %s %Cgreen(%an)%Creset %Cred%d%Creset'"
alias ggrep="~/local/bin/all_git_grep"

export HISTCONTROL=ignoredups
export HISTIGNORE="fg*:bg*:history*:exit"
export HISTSIZE=10000

# vim
[[ $VIM ]] && PS1="\[\e[1;34m\](vi)\[\e[00m\] $PS1"

# stop
stty stop undef

################
# peco
################
alias peco="~/local/bin/peco"

# history
alias ph="history | tac | sed -e 's/^ \+[0-9]\+ \+//' | peco"

# vim
function pv {
  local c="$(find . | peco)"
  if [ -n "$c" ]; then
    vi $c
  fi
}

# switch_branch
function sb {
  local c="$(git branch | peco | sed -e 's/\*//')"
  if [ -n "$c" ]; then
    switch_branch $c
  fi
}

# git push
function gp {
  local c="$(git branch | grep '*' | awk '{print $2}')"
  if [ -n "$c" ]; then
    git push origin $c
  fi
}

# push_branch
function pb {
  local c="$(git branch | grep '*' | awk '{print $2}')"
  if [ -n "$c" ]; then
    push_branch $c
  fi
}
