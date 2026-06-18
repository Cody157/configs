######################
## helper functions ##
######################

## RETURNS (
##   returning_a_value: boolean
##   value: any
##   rest: any[]
get_named_arg() {
  local -n _args=$1
  key=$2
  local -n return_value=$3
  default=$4

  num_elements=${#_args[@]}
  index=0
  while [ $index -lt $num_elements ]; do
    if [[ ${_args[$index]} = $key ]]; then
      break
    fi

    index=$[index + 1]
  done

  if [[ $index = $num_elements ]]; then
    return_value=$default
  else
    return_value=${_args[$[index + 1]]}
    unset _args[$index]
    unset _args[$[index + 1]]
    _args=("${_args[@]}")
  fi
}

pad_right() {
  str=$1
  pad_count=$2
  pad_char=${3:-' '}

  # len = ${#str}
  while [[ ${#str} -lt $pad_count ]]; do
    str=$str$pad_char
  done

  echo "$str"
}

###############
## ls stuffs ##
###############

alias la='ls  -A'
alias l='ls   -CF'
alias ll='ls  --group-directories-first -AlhgG'
alias llx='ll -X' # Sort by extension type
alias llt='ll -t' # Sort by modification time
alias lls='ll -S' # Sort by file size

lll() {
  ll -F $1 | less
}

# Recursive
alias llR='ll -RF'
llr() {
  llR $1 | less
}

##################
## grep aliases ##
##################

alias grep='grep --color=always'

grepr() {
  grep -rn "$1" .
}

grepx() {
  grep -rn "$1" . | grep -vE "$2"
}

grepxi() {
  grepx "$2" "$1"
}

################################
## random convenience aliases ##
################################

alias executable='chmod 764' # Keeps default permissions except executable by owner
alias go-back='. _go-back'
alias re-source='source ~/.bash_profile'
alias now="node -e 'console.log(new Date())'"
alias ding="afplay ~/sounds/AnimationFlyToDownloads.aiff"
# This won't work in iTerm, since I set it to eat the beep sound
alias beep="echo $'\a'"
alias format-json="pbpaste | jq '.' | pbcopy"
alias format-json-copy="pbpaste | jq '.' | pbpcopy"
alias format-json-print="pbpaste | jq '.'"
alias pq="pbpaste | jq '.'"
alias broken-ts="tsc --noEmit | cut -f1 -d'(' | uniq"
alias tsn="ts-node --compiler-options='{\"noUnusedLocals\": false, \"noUnusedParameters\": false}'"

strip-cr() {
  tr -d '\r' < $1 > $2
}

search() {
  if [[ $2 == '' ]]; then
    dir="."
  else
    dir=$2
  fi

  find $dir -name $1 2> /dev/null
}

# Stuff around finding running processes
processes() {
  ps -eaf | grep $1 | grep -v 'grep' | cut -c1-80
}

process-ids() {
  # the `| grep -v grep` is to avoid picking up this grep execution... so hopefully I'm not looking for grep
  ps -eaf | grep $1 | grep -v 'grep' | awk '{ print $2 }'
}

kill-processes() {
  kill $(ps -eaf | grep $1 | grep -v 'grep' | awk '{ print $2 }')
}

encode() {
  echo -n $1 | base64
}

decode() {
  echo `echo -n $1 | base64 --decode`
}

switch() {
  location="$(dir $1)"
  if [[ $? -eq 0 ]]; then
    cd $location
  else
    echo "$location"
  fi
}
alias s="switch"

#################
## git aliases ##
#################

alias git-log='git log --oneline -10'
alias git-graph='git-log --graph'
alias git-ca='git commit --amend --no-edit'
alias git-sr='git submodule deinit --all && git submodule init && git submodule update'
alias git-m='git checkout main && git pull'

git-close() {
  current_branch="$(git branch --show-current)"
  echo "$(git checkout master && git pull && git branch -d $current_branch)"
}

############################
## docker-compose aliases ##
############################

alias dc=docker-compose
alias dup='docker-compose up -d'
alias dlogs='docker-compose logs -f'
# Maybe make a version of this that only runs one thing?

dupl() {
  dup $1 && dlogs $1
}

declare -A _dc_map
# _dc_map[tests]='insight-engine'

dc-find() {
  name="$(docker ps --format 'table {{.Names}}' | tail -n +2)"

  if [[ $name == "" ]]; then
    echo "None found!"
    return
  fi

  col=10
  while read -r line; do
    # %% is "remove longest substring from back of string matching supplied pattern"
    # So this removes everything after (inclusive) the first _
    sub=${line%%_*}
    inferred=${_dc_map[$sub]:-$sub}
    if [[ ${#sub} -gt ${#col} ]]; then
      col=${#sub}
    fi
    if [[ ${#inferred} -gt ${#col} ]]; then
      col=${#inferred}
    fi
  done <<< "$name"

  col=$col+5

  echo "$(pad_right inferred $col) $(pad_right short $col) full"

  while read -r line; do
    # %% is "remove longest substring from back of string matching supplied pattern"
    # So this removes everything after (inclusive) the first _
    sub=${line%%_*}
    inferred=${_dc_map[$sub]:-$sub}
    echo "$(pad_right $inferred $col) $(pad_right $sub $col) $line"
  done <<< "$name"
}

########################
## kubernetes aliases ##
########################

alias k='kubectl'
#alias kd='kubectl --context ojodev'
#alias ks='kubectl --context ojostage'
#alias kp='kubectl --context ojoprod'
#alias kb='kubectl --context beta'
#alias kp='kubectl --context prod'
#alias ks='kubectl --context staging'
#alias kback='kubectl --context backend'

# kubectx replacecs most of this stuff
#alias kube-context='kubectl config current-context'
#alias kube-beta='kubectl config use-context beta'
#alias kube-prod='kubectl config use-context prod'
#alias kube-staging='kubectl config use-context staging'
#alias kc='kubectl config use-context'
#alias kube-mini='kubectl config use-contex minikube'

########################
## virtualenv aliases ##
########################

alias vpython='./virtualenv/bin/python'

# $1 = base of path to virtualenv without trailing slash
vsource() {
  if [[ $1 = "" ]]; then
    source "virtualenv/bin/activate"
  else
    source "$1/virtualenv/bin/activate"
  fi
}


#####################
## eclipse aliases ##
#####################
eclipse() {
  if [[ $1 = "" ]]; then
    /Applications/eclipse.app/Contents/MacOS/eclipse &> /dev/null & disown
  else
    /Applications/eclipse.app/Contents/MacOS/eclipse -data $1 &> /dev/null & disown
  fi
}


##################
## python stuff ##
##################

pm() {
  path=$1

  # Could check that it's a py file or a directory with an __main__.py...
  if [[ ! -e $path ]]; then
    echo "$path is not a valid path"
    return
  fi

  # Remove extension
  if [[ $path == *.py ]]; then
    path=${path:0:-3}
  fi

  # Remove leading ./
  if [[ $path == ./* ]]; then
    path=${path:2}
  fi

  # Replace / with .
  path=${path//\//.}
  python -m $path
}

alias poetry-env='poetry env use $(pyenv which python)'
alias poetry-shell='eval $(poetry env activate)'
alias venv-init='python -m venv .venv'
alias venv='source venv/bin/activate'

##################
## Kotlin stuff ##
##################

alias kotlin-repl=kotlinc-jvm

#################
## pod aliases ##
#################

k-first() {
  if [[ $1 = "" ]]; then
    echo "Usage: k-first pod_name [info_type]"
    echo "  pod_name: used in grep"
    echo "  info_type=[name, ip]; default: name"
    echo "Options:"
    echo "  -o: context; eg: beta, prod"
    echo "  -n: namespace; eg: default, datadog; default: pod_name"
    echo "Examples:"
    echo "  k-first conductor-api"
    echo "  k-first ait-panel ip"
    echo "  k-first ait-panel -o prod"
    echo "  k-first node-agent -n datadog"
    return
  fi

  local context
  args=("$@")

  get_named_arg args -o context ""
  get_named_arg args -n namespace ""
  pod_name=${args[0]}

  if [[ $namespace = "" ]]; then
    namespace=$pod_name
  fi

  info_type=${args[1]}
  if [[ $info_type != "" && $info_type != "name" && $info_type != "ip" ]]; then
    echo "info_type can only be one of"
    echo "  name"
    echo "  ip"
    return
  fi

  info_index=1
  if [[ $info_type = "ip" ]]; then
    info_index=6
  fi

  request=(kubectl --namespace $namespace)

  if [[ $context != "" ]]; then
    request=(${request[@]} --context $context)
  fi

  request=(${request[@]} get pod -o wide)

  echo "$(
    ${request[@]} |
    grep --color=never $pod_name |
    head -n 1 |
    awk "{ print \$$info_index }"
  )"
}

k-port-forward() {
  if [[ $1 = "" ]]; then
    echo "Usage: k-port-forward pod_name [port_map]"
    echo "  pod_name: used in grep"
    echo "  port_map: local_port[:<pod_port>=local_port]; default: 8000"
    echo "Options:"
    echo "  -o: context; eg: beta, prod"
    echo "  -n: namespace; eg: default, datadog; default: pod_name"
    echo "Examples:"
    echo "  k-port-forward conductor-api"
    echo "  k-port-forward ait-panel 5000"
    echo "  k-port-forward ait-panel 5000 -o prod"
    echo "  k-port-forward ait-panel 5000:5000"
    echo "  k-port-forward node-agent 8126 -n datadog"
    return
  fi

  local context
  args=("$@")

  get_named_arg args -o context ""
  get_named_arg args -n namespace ""
  name=${args[0]}
  port_map=${args[1]:-8000}

  if [[ $context = "" ]]; then
    context=$(kubectl config current-context)
  fi

  if [[ $namespace = "" ]]; then
    namespace=$name
  fi

  pod_name=$(k-first $name -o $context -n $namespace)

  echo "Pod: $context.$pod_name.$namespace"

  kubectl --context $context --namespace $namespace port-forward $pod_name $port_map
}

alias k-pf='k-port-forward'

## This should not be used. Not sure what's going on, but the last one closed comes back and even killing it manually brings up another one.
# k-pf-watch() (
#   if [[ $1 = "" ]]; then
#     echo "Usage: k-pf-watch pod_name [port_map]"
#     echo "  pod_name: used in grep"
#     echo "  port_map: local_port[:<pod_port>=local_port]; default: 8000"
#     echo "Options:"
#     echo "  -o: context; eg: beta, prod"
#     echo "  -n: namespace; eg: default, datadog; default: pod_name"
#     echo "Examples:"
#     echo "  k-pf-watch conductor-api"
#     echo "  k-pf-watch ait-panel 5000"
#     echo "  k-pf-watch ait-panel 5000 -o prod"
#     echo "  k-pf-watch ait-panel 5000:5000"
#     echo "  k-pf-watch node-agent 8126 -n datadog"
#     return
#   fi
# 
#   local context
#   args=("$@")
# 
#   get_named_arg args -o context ""
#   get_named_arg args -n namespace $name 
#   name=${args[0]}
#   port_map=${args[1]:-8000}
# 
#   if [[ $context = "" ]]; then
#     context=$(kubectl config current-context)
#   fi
# 
#   if [[ $namespace = "" ]]; then
#     namespace=$name
#   fi
# 
#   __keep_watching=true
#   
#   _k-pf-watch() {
#     k-port-forward $1 $2 -o $3 -n $4 &
#     wait
#   
#     if [[ $__keep_watching == true ]]; then
#       _k-pf-watch $1 $2 $3 $4
#     fi
#   }
# 
#   (_k-pf-watch $name $port_map $context $namespace) &
#   wait
# 
#   __keep_watching=false
#   kill $process_id
# )

k-exec() {
  if [[ $1 = "" ]]; then
    echo "Usage: k-exec pod_name [command]"
    echo "  pod_name: used in grep"
    echo "  command: to be run by exec; default: /bin/bash"
    echo "  container_name: name of the container in the pod to exec into"
    echo "    must be preceded by -c"
    echo "Options:"
    echo "  -c: container name"
    echo "  -o: context; eg: beta, prod"
    echo "  -n: namespace; eg: default, datadog; default: pod_name"
    echo "Examples:"
    echo "  k-exec conductor-api"
    echo "  k-exec ait-panel env"
    echo "  k-exec ait-panel -c api"
    echo "  k-exec ait-panel env -c api"
    echo "  k-exec ait-panel env -c api -o prod"
    echo "  k-exec node-agent node-agent -n datadog"
    return
  fi

  local context container
  args=("$@")

  get_named_arg args -o context ""
  get_named_arg args -c container ""
  get_named_arg args -n namespace ""
  name=${args[0]}
  run_command=${args[1]:-'/bin/bash'}

  if [[ $context = "" ]]; then
    context=$(kubectl config current-context)
  fi

  if [[ $namespace = "" ]]; then
    namespace=$name
  fi

  # get namespace from current context and use that -- no longer matches how I use this
  # if [[ $namespace = "" ]]; then
  #   context_namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')
  #   namespace=${context_namespace:-"default"}
  # fi

  pod_name=$(k-first $name -o $context -n $namespace)

  echo "Pod: $context.$pod_name.$namespace"

  request=(
    kubectl --context $context --namespace $namespace
    exec -it $pod_name
  )

  if [[ $container != "" ]]; then
    request=(${request[@]} -c $container)
  fi

  request=(${request[@]} -- $run_command)

  ${request[@]}
}

k-roll() {
  if [[ $1 = "" ]]; then
    echo "Usage: k-roll deployment_name"
    echo "  deployment_name: name of deployment"
    echo "Options:"
    echo "  -o: context; eg: ojodev, ojoprod"
    echo "  -n: namespace; eg: default, datadog; default: [deployment_name]"
    echo "Examples:"
    echo "  k-roll consumer-notification"
    echo "  k-roll consumer-notification -o ojoprod"
    echo "  k-roll ait-panel-api -n ait-panel"
    return
  fi

  local context
  args=("$@")

  get_named_arg args -o context ""
  get_named_arg args -n namespace ""
  deployment_name=${args[0]}

  if [[ $context = "" ]]; then
    context=$(kubectl config current-context)
  fi

  if [[ $namespace = "" ]]; then
    namespace=$deployment_name
  fi

  echo "Rolling: $context.$deployment_name.$namespace"
  kubectl --context $context --namespace $namespace rollout restart deployment/$deployment_name
}

###################
## evans aliases ##
###################

evans-repl() {
  if [[ $1 = "" ]]; then
    echo "Usage: evans-repl pod_name [port_map]"
    echo "  pod_name: used in grep"
    echo "  port_map: local_port[:<pod_port>=local_port]; default: 0:8000"
    echo "Options:"
    echo "  -o: context; eg: beta, prod"
    echo "  -n: namespace; eg: default, datadog; default: pod_name"
    echo "Examples:"
    echo "  evans-repl relationship-manager"
    echo "  evans-repl relationship-manager 8000:8000"
    echo "  evans-repl relationship-manager -o ojoprod"
    echo "Description:"
    echo "  This will port-forward the service as specified and then open an evans repl to interact with it."
    echo "  If the local port is already in use, it will attempt to use that instead of port-forwarding."
    return
  fi

  local context
  args=("$@")

  get_named_arg args -o context ""
  get_named_arg args -n namespace $name 
  name=${args[0]}
  port_map=${args[1]:-"0:8000"}

  local_port=${port_map%:*}
  # remote_port=${port_map#*:}

  if [[ $context = "" ]]; then
    context=$(kubectl config current-context)
  fi

  if [[ $namespace = "" ]]; then
    namespace=$name
  fi

  if [[ $local_port != "0" ]]; then
    in_use="$(lsof -i :$local_port)"
    if [[ $in_use = "" ]]; then
      echo "The specified port ($local_port) is already in use, try again"
      return -1
    fi
  fi

  _k-pf-watch() {
    k-port-forward $1 $2 -o $3 -n $4 &
    wait
  
    if [[ $__keep_watching == true ]]; then
      _k-pf-watch $1 $2 $3 $4
    fi
  }

  ## This is unfinished. Need to
  ## - capture the port chosen by port-forward... or select one from here and pass it on
  ## - run evans repl
  return 0

  (k-port-forward $name $port_map -o $context -n $namespace) &
  wait

  echo "$(ps ps -s $$ -o pid=)"
}
