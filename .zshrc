export HISTCONTROL=ignoredups
#export HISTIGNORE="fg*:bg*:history*:exit"
export HISTSIZE=100000

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

peco-history() {
    local NUM=$(history | wc -l)
    local FIRST=$((-1*(NUM-1)))

    if [ $FIRST -eq 0 ] ; then
        history -d $((HISTCMD-1))
        echo "No history" >&2
        return
    fi

    local CMD=$(fc -l $FIRST | sort -k 2 -k 1nr | uniq -f 1 | sort -nr | sed -E 's/^[0-9]+[[:blank:]]+//' | peco | head -n 1)

    if [ -n "$CMD" ] ; then
        history -s $CMD

        if type osascript > /dev/null 2>&1 ; then
            (osascript -e 'tell application "System Events" to keystroke (ASCII character 30)' &)
        fi
    else
        history -d $((HISTCMD-1))
    fi
}
#bind -x '"\C-r":peco-history'

# docker
alias dls="docker container ls"
alias dce="docker-compose exec"
alias dcb="docker-compose up --build -d"

function dockertags {
  curl -s -S "https://registry.hub.docker.com/v1/repositories/$1/tags" | jq '.[]["name"]'
}

# ctags
alias rt='ctags --langmap=RUBY:.rb --exclude="*.js" --exclude=".git*" -R .'
