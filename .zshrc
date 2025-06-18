# Fig pre block. Keep at the top of this file.
# [[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
export HISTCONTROL=ignoredups
#export HISTIGNORE="fg*:bg*:history*:exit"
export HISTSIZE=1000000
export SAVEHIST=1000000

# PATH
# export PATH="$HOME/.pyenv/bin:$PATH"
# eval "$(pyenv init -)"

# prompt
autoload -Uz colors && colors
export PROMPT="%{$fg[cyan]%}%c%{$reset_color%} %% "
[[ $VIM ]] && PROMPT="%{$fg[green]%}(vi)%{$reset_color%} $PROMPT"

# copilot cli
# eval "$(github-copilot-cli alias -- "$0")"

# stop
stty stop undef

setopt nonomatch

# general
alias vi="/usr/bin/vim -u ~/.vimrc-local8.1"
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
  curl -s -S "https://registry.hub.docker.com/v2/repositories/library/$1/tags/?page_size=100000"  | jq '.results[].name'
}

# ctags
alias rt='ctags --langmap=RUBY:.rb --exclude="*.js" --exclude=".git*" -R .'
alias pt='ctags --langmap=Python:.py --exclude=".git*" -R .'

# kubectl
function ckube {
  local c="$(kubectl config get-contexts | sed -e '1d' | peco | sed -e 's/* //g' | awk '{print $2}')"
  if [ -n "$c" ]; then
    kubectl config use-context $c
  fi
}

# gcloud
function gccurrent() {
  cat $HOME/.config/gcloud/active_config
}

function cgcloud() {
  gcloud config configurations activate $(gcloud config configurations list | awk '{print $1}' | grep -v NAME | peco)
}

# one char alias
alias a="docker compose up --build -d"
alias b="git checkout -b"
alias c="cp -p"
alias d="git diff"
alias e="ch"
alias f="find . -name"
alias g="git grep"
alias h="gc"
alias i="git branch -D"
alias j="git status"
alias k="git pull"
alias l="ls -ltr"
alias m="git commit"
alias n="git add"
alias o="open ."
alias p="gp"
alias q="docker compose logs -f"
alias s="docker compose restart"
alias t="tail -f"
alias u="git branch"
alias v="gvi"
alias w="docker container ls"
alias x="docker compose exec"
alias y="open https://ham0215.github.io/alias.html"
alias z="docker compose down"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/naoto.hamada/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/naoto.hamada/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/naoto.hamada/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/naoto.hamada/google-cloud-sdk/completion.zsh.inc'; fi

# Fig post block. Keep at the bottom of this file.
# [[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
eval "$(mise activate zsh)"
