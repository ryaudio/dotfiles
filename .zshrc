# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel9k/powerlevel9k"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs virtualenv anaconda)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# Add a space in the first prompt
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%f"
POWERLEVEL9K_ANACONDA_BACKGROUND='violet'
POWERLEVEL9K_VIRTUALENV_BACKGROUND='violet'

# Visual customisation of the second prompt line
local user_symbol="$"
if [[ $(print -P "%#") =~ "#" ]]; then
    user_symbol = "#"
fi
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%B%F{black}%K{yellow}%} %m $user_symbol%{%b%f%k%F{yellow}%} %{%f%}"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
  tmux
)
autoload -U compinit && compinit  # Needed for zsh-completions

source $ZSH/oh-my-zsh.sh

# Pyenv enabled in login shells only (.zprofile) to avoid overwriting venvs like poetry

# Python poetry
export PATH="$HOME/.poetry/bin:$PATH"

# Rust cargo
export PATH="$HOME/.cargo/bin:$PATH"

# CUDA Toolkit
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

# GO workspace (where `go get` installs stuff, etc)
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:/usr/local/go/bin:$PATH"

# Clang
export PATH="/usr/local/opt/llvm/bin:$PATH"

# OpenSSL
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"

# Personal aliases
 alias ohmyzsh="mate ~/.oh-my-zsh"

# Custom functions
function puntar() {(
  set -e
  set -o pipefail
  file="$1"
  output="${file%%.*}" # get filename without extension: https://stackoverflow.com/a/965069
  if test ! -f "$file"; then
    echo "The file \"$file\" doesn't exist!" >&2
    exit -1
  fi
  mkdir -p "$output"
  # {@:2} gets all arguments after first: https://stackoverflow.com/a/9057392
  # unix (mac) du has no way to print in bytes, but does have kilobytes with -k. PV provides suffixes to report size in kilobytes, so we use that.
  cat "$file" | pv -s $(du -k "$file" | awk '{print $1}')k | tar ${@:2} -xf - -C "$output"
)}
export puntar

function ptar() {(
  set -e
  set -o pipefail
  file="$2"
  output="$3"
  compressor="$1"
  if test ! -e "$file"; then
    echo "The file \"$file\" doesn't exist!" >&2
    exit -1
  fi
  # {@:2} gets all arguments after first: https://stackoverflow.com/a/9057392
  # unix (mac) du has no way to print in bytes, but does have kilobytes with -k. PV provides suffixes to report size in kilobytes, so we use that.
  tar -cf - "$file" -P | pv -s $(du -sk "$file" | awk '{print $1}')k | $compressor > "$output"
)}
export ptar

function pgtar() {(
  set -e
  ptar gzip "$1" "$2"
)}
export pgtar

function pchildren() {(
  # get all the pids of child processes recursively
  # https://unix.stackexchange.com/a/317605
  [ "$#" -eq 1 -a -d "/proc/$1/task" ] || exit 1
  PID_LIST= 
	findpids() {
    [ ! -d "/proc/$1/task" ] && return
    for pid in /proc/$1/task/*; do
    	pid="$(basename "$pid")"
      PID_LIST="$PID_LIST$pid "
      for cpid in $(cat /proc/$1/task/$pid/children) ; do
        findpids $cpid
     	done
    done
	}
	findpids $1
	echo $PID_LIST
)}
export pchildren

# rsync doesn't show progress by default
alias rsync='rsync --info=progress2'

# also make it easy to resume large transfers in a clean way
function copy() {(
  set -e
  fname="$(basename -- "$1")"
  rsync --partial-dir ".$fname.tmp" $1 $2
)}
export copy

export PYTHONPATH=$PYTHONPATH:/usr/local/lib

# opam configuration
test -r /Users/ryan.butler/.opam/opam-init/init.zsh && . /Users/ryan.butler/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
