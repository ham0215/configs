# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

export HISTCONTROL=ignoredups
#export HISTIGNORE="fg*:bg*:history*:exit"
export HISTSIZE=10000

export PS1="[\u:\W]\$ "

# vim
[[ $VIM ]] && PS1="\[\e[1;34m\](vi)\[\e[00m\] $PS1"

# stop
stty stop undef

# general
alias vi="/usr/local/bin/vim -u ~/.vimrc-local8.1"
alias f="find . -name"

# git
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

# docker
alias dls="docker container ls"
alias dce="docker-compose exec"
alias dcb="docker-compose up --build -d"

# rails
alias rt='ctags --langmap=RUBY:.rb --exclude="*.js" --exclude=".git*" -R .'
#alias be="bundle exec"
#alias routes="bundle exec rake routes"
#alias rubocop="bundle exec rubocop"
#alias rspec="bundle exec rspec"
#alias gmigrate="bundle exec rails g migration"
#alias migrate="bundle exec rails db:migrate"
#alias prepare="bundle exec rake db:test:prepare"
