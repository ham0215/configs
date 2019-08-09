# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

export HISTCONTROL=ignoredups
#export HISTIGNORE="fg*:bg*:history*:exit"
export HISTSIZE=10000

export PS1="[:\W]\$ "

# vim
[[ $VIM ]] && PS1="\[\e[1;34m\](vi)\[\e[00m\] $PS1"

# stop
stty stop undef

# general
alias vi="/usr/local/bin/vim -u ~/.vimrc-local8.1"
alias f="find . -name"

# git
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
elif [ -f $(brew --prefix)/etc/bash_completion.d/git-completion.bash ]; then
  . $(brew --prefix)/etc/bash_completion.d/git-completion.bash
fi
alias gs="git status"
alias gb="git branch"
alias gd="git diff"
alias gg="git grep"

function gc {
  local c="$(git branch | peco | sed -e 's/* //g' | awk '{print $1}')"
  if [ -n "$c" ]; then
    git checkout $c
  fi
}

function gp {
  local c="$(git branch | grep '*' | awk '{print $2}')"
  if [ -n "$c" ]; then
    git push origin $c
  fi
}

function chrome {
  cp -p $HOME/Library/Application\ Support/Google/Chrome/Default/History /tmp/chrome_history
  local c="$(sqlite3 /tmp/chrome_history 'select url from urls' | peco)"
  if [ -n "$c" ]; then
    open -a '/Applications/Google Chrome.app' "$c"
  fi
}

# docker
alias dls="docker container ls"
alias dce="docker-compose exec"
alias dcb="docker-compose up --build -d"

# ctags
alias rt='ctags --langmap=RUBY:.rb --exclude="*.js" --exclude=".git*" -R .'
