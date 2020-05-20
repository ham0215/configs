export HISTCONTROL=ignoredups
#export HISTIGNORE="fg*:bg*:history*:exit"
export HISTSIZE=100000
export SAVEHIST=100000

# PATH
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

# prompt
autoload -Uz colors && colors
export PROMPT="%{$fg[cyan]%}%c%{$reset_color%} %% "
[[ $VIM ]] && PROMPT="%{$fg[green]%}(vi)%{$reset_color%} $PROMPT"

# stop
stty stop undef

setopt nonomatch

# general
alias vi="/usr/local/bin/vim -u ~/.vimrc-local8.1"
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

function dockertags {
  curl -s -S "https://registry.hub.docker.com/v1/repositories/$1/tags" | jq '.[]["name"]'
}

# ctags
alias rt='ctags --langmap=RUBY:.rb --exclude="*.js" --exclude=".git*" -R .'


# one char alias
alias a="COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose up --build -d"
alias b="git checkout -b"
alias c="cp -p"
alias d="git diff"
alias e="ch"
alias f="find . -name"
alias g="git grep"
alias h="gc"
alias i="git branch -d"
alias j="git status"
alias k="git pull"
alias l="ls -ltr"
alias m="git commit"
alias n="git add"
alias o="open ."
alias p="gp"
alias q="docker-compose logs -f"
alias s="docker-compose restart"
alias t="tail -f"
alias u="git branch"
alias v="gvi"
alias w="docker container ls"
alias x="docker-compose exec"
alias y="open https://ham0215.github.io/alias.html"
alias z="docker-compose down"
