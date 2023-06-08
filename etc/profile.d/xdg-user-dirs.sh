XDG_DATA_HOME="$HOME/.local/share"
XDG_CONFIG_HOME="$HOME/.config"
XDG_STATE_HOME="$HOME/.local/state"
XDG_CACHE_HOME="$HOME/.cache"

export XDG_DATA_HOME XDG_CONFIG_HOME XDG_STATE_HOME XDG_CACHE_HOME

export GOPATH="$XDG_DATA_HOME"/go

alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"

export HISTFILE="$XDG_STATE_HOME"/bash_history
