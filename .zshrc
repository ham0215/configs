export HISTCONTROL=ignoredups
#export HISTIGNORE="fg*:bg*:history*:exit"
export HISTSIZE=1000
export SAVEHIST=100000

# prompt
autoload -Uz colors && colors
export PROMPT="%{$fg[cyan]%}%c%{$reset_color%} %% "
[[ $VIM ]] && PROMPT="%{$fg[green]%}(vi)%{$reset_color%} $PROMPT"

# stop
stty stop undef

# general
alias vi="/usr/local/bin/vim -u ~/.vimrc-local8.1"
alias f="find . -name"
alias ls="ls -G"

fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
autoload -U compinit
compinit -u
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

function gsw {
  local c="$(git branch | peco | sed -e 's/* //g' | awk '{print $1}')"
  if [ -n "$c" ]; then
    git switch $c
  fi
}

function gp {
  local c="$(git branch | grep '*' | awk '{print $2}')"
  if [ -n "$c" ]; then
    git push origin $c
  fi
}

function ch {
  cp -p $HOME/Library/Application\ Support/Google/Chrome/Default/History /tmp/chrome_history
  local c="$(sqlite3 /tmp/chrome_history 'select url from urls' | peco)"
  if [ -n "$c" ]; then
    open -a '/Applications/Google Chrome.app' "$c"
  fi
}

function avi {
  vi $(ag $@ | peco --query "$LBUFFER" | awk -F : '{print "-c " $2 " " $1}')
}

function gvi {
  vi $(git grep -n $@ | peco --query "$LBUFFER" | awk -F : '{print "-c " $2 " " $1}')
}

function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

# docker
alias dls="docker container ls"
alias dce="docker-compose exec"
alias dcb="docker-compose up --build -d"

function dockertags {
  curl -s -S "https://registry.hub.docker.com/v1/repositories/$1/tags" | jq '.[]["name"]'
}

# ctags
alias rt='ctags --langmap=RUBY:.rb --exclude="*.js" --exclude=".git*" -R .'
