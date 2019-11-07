if [ -f ~/.bashrc ] ; then
. ~/.bashrc
fi

export PATH="/usr/local/opt/mysql-client/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

alias v="cd ~/local/visits-works/"
alias tt="tail -f log/test.log"
alias tl="tail -f log/local.log"
alias td="tail -f log/development.log"
alias cc="cd ~/local/visits-works/consulting-cloud-backend"
alias cs="cd ~/local/visits-works/consulting-cloud-cs"
alias hq="cd ~/local/visits-works/consensus-hq-backend"
alias ig="cd ~/local/visits-works/ideagram-backend"
alias ia="cd ~/local/visits-works/ideagram-administrate"
alias ham="cd ~/local/ham0215"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/naoto_hamada/local/google/google-cloud-sdk/path.bash.inc' ]; then . '/Users/naoto_hamada/local/google/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/naoto_hamada/local/google/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/naoto_hamada/local/google/google-cloud-sdk/completion.bash.inc'; fi

# sql
alias sql_cc_dev='cloud_sql_proxy -instances=consulting-cloud-dev:asia-northeast1:default=tcp:53307 -credential_file=/Users/naoto_hamada/local/sql_keys/consulting-cloud-dev-59b0fae37ac8.json'
alias sql_cc_stg='cloud_sql_proxy -instances=consulting-cloud-stg:asia-northeast1:cc-stg-mysql=tcp:53307 -credential_file=/Users/naoto_hamada/local/sql_keys/consulting-cloud-stg-540b666c527f.json'
alias sql_cc_prd='cloud_sql_proxy -instances=consulting-cloud-prd:asia-northeast1:cc-prd-mysql-failover=tcp:53307 -credential_file=/Users/naoto_hamada/local/sql_keys/consulting-cloud-prd-0e0b02c4ca8c.json'
alias sql_hq_dev='cloud_sql_proxy -instances=consensus-hq-dev:asia-northeast1:default=tcp:53307 -credential_file=/Users/naoto_hamada/local/sql_keys/consensus-hq-dev-48e8275e4ba5.json'
alias sql_hq_stg='cloud_sql_proxy -instances=consensus-hq-stg:asia-northeast1:hq-stg-mysql=tcp:53307 -credential_file=/Users/naoto_hamada/local/sql_keys/consensus-hq-stg-69f0019ef7ef.json'
alias sql_hq_prd='cloud_sql_proxy -instances=consensus-hq-prd:asia-northeast1:hq-prd-mysql-failover=tcp:53307 -credential_file=/Users/naoto_hamada/local/sql_keys/consensus-hq-prd-fd4e5a67ddde.json'
