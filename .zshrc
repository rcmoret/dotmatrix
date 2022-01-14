fpath=(
  $fpath
  ~/.zsh/functions
  /usr/local/share/zsh/site-functions
)

source "$HOME/.sharedrc"

stty sane

# color term
export CLICOLOR=1
export LSCOLORS=Dxfxcxdxbxegedabadacad
export ZLS_COLORS=$LSCOLORS
export LC_CTYPE=en_US.UTF-8
export LESS=FRX
export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig

export FZF_CTRL_T_OPTS=" --preview 'bat --style=numbers --color=always {} | head -500'"
export VISUAL EDITOR LESS RI PSQL_EDITOR CLICOLOR LSCOLORS
export IMAC='ryanmoret@192.168.1.79'

VISUAL=vim
EDITOR="$VISUAL"
LESS="FRX"
RI="--format ansi -T"
PSQL_EDITOR='vim -c"setf sql"'
CLICOLOR=1
LSCOLORS=gxgxcxdxbxegedabagacad
LDFLAGS="-L/usr/local/opt/llvm@8/lib -Wl,-rpath,/usr/local/opt/llvm@8/lib"
CPPFLAGS="-I/usr/local/opt/llvm@8/include"

# make with the nice completion
autoload -U compinit; compinit

# Completion for kill-like commands
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"
zstyle ':completion:*:ssh:*' tag-order hosts users
zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host users hosts-ipaddr

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'

zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zshcache

# make with the pretty colors
autoload colors; colors

# just say no to zle vim mode:
bindkey -e

# options
setopt appendhistory extendedglob histignoredups nonomatch prompt_subst interactivecomments

# Bindings
# external editor support
autoload edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Partial word history completion
bindkey '\ep' up-line-or-search
bindkey '\en' down-line-or-search
bindkey '\ew' kill-region

if [ -z "$TMUX" ]; then
  fg-widget() {
    stty icanon echo pendin -inlcr < /dev/tty
    stty discard '^O' dsusp '^Y' lnext '^V' quit '^\' susp '^Z' < /dev/tty
    zle reset-prompt
    if jobs %- >/dev/null 2>&1; then
      fg %-
    else
      fg
    fi
  }

  zle -N fg-widget
  bindkey -M emacs "^Z" fg-widget
  bindkey -M vicmd "^Z" fg-widget
  bindkey -M viins "^Z" fg-widget
fi

# prompt
p=
if [ -n "$SSH_CONNECTION" ]; then
  p='%{$fg_bold[yellow]%}%n@%m'
else
  p='%{$fg_bold[green]%}%n'
fi
PROMPT="$p%{\$reset_color%}:%{\$fg_bold[cyan]%}%~%{\$reset_color%}\$(git_prompt_info '(%s)')~> "

alias 'be'='bundle exec'
alias 'g'='git status'
alias 'gbr'='git branch'
alias 'ggl'='git log --oneline --abbrev-commit --all --graph --color --decorate'
alias 'gg'='git log --oneline --abbrev-commit --all --graph --color | head'
alias 'grh'='git reset HEAD'
alias 'gs'='git stash'
alias 'gsp'='git stash pop'
alias 'll'='ls -la'

# show non-success exit code in right prompt
RPROMPT="%(?..{%{$fg[red]%}%?%{$reset_color%}})"

# history
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# default apps
(( ${+PAGER}   )) || export PAGER='less'
(( ${+EDITOR}  )) || export EDITOR='vim'
export PSQL_EDITOR='vim -c"setf sql"'

# Aliases
# * Additional aliases are found in `.sharedrc`
#
alias l="ls -F -G -lah"
alias ll="ls -la"
alias la="ls -a"
alias lsd='ls -ld *(-/DN)'
alias md='mkdir -p'
alias rd='rmdir'
alias cd..='cd ..'
alias ..='cd ..'
alias groutes='rake routes | grep $@'
alias reload='source ~/.zshrc; echo -e "\n\u2699  \e[33mZSH config reloaded\e[0m \u2699"'

alias 'be'='bundle exec'
alias 'g'='git status'
alias 'gbr'='git branch'
alias 'ggl'='git log --oneline --abbrev-commit --all --graph --color --decorate'
alias 'gg'='git log --oneline --abbrev-commit --all --graph --color | head'
alias 'grh'='git reset HEAD'
alias 'gs'='git stash'
alias 'gsp'='git stash pop'
alias 'gpu'='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias 'cprmt'='less ~/repos/misc/rmt.md | pbcopy'
alias 'cpemd'='less ~/repos/misc/emd.md | pbcopy'
alias 'cpsfk'='less ~/repos/sfmc/key | pbcopy'
alias 'add-ssh-key'='ssh-add -K ~/.ssh/id_rsa'
export IMAC='ryanmoret@192.168.1.66'
alias 'ssh-imac'='ssh $IMAC'
alias 'routes'="bundle exec rails routes | fzf"
alias 'bam'='bundle install && RAILS_ENV=test bundle exec rails db:migrate && RAILS_ENV=development bundle exec rails db:migrate'

l.() {
  ls -ld "${1:-$PWD}"/.[^.]*
}

export ASDF_RUBY_BUILD_VERSION=master
export PLATFORM_DEV="$HOME/repos/dev"
shovel() ( $PLATFORM_DEV/script/run shovel "$@"; )

cuke() {
  local file="$1"
  shift
  cucumber "features/$(basename $file)" $@
}
compctl -g '*.feature' -W features cuke

# import local zsh customizations, if present
zrcl="$HOME/.zshrc.local"
[[ ! -a $zrcl ]] || source $zrcl

# set cd autocompletion to commonly visited directories
cdpath=(~ ~/src $DEV_DIR $SOURCE_DIR)

# remove duplicates in $PATH
typeset -aU path

export PATH=/usr/local/opt/postgresql@12/bin:$PATH:/Users/ryanmoret/Library/Python/3.8/bin:/Users/ryanmoret/scripts:/usr/local/opt/libpq/bin

command -v brew > /dev/null && [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh 

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

bindkey "\e[3~" delete-char

my-backward-delete-word() {
    local WORDCHARS="*?-[]~=&;!#$%^(){}<>"
    # local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^W' my-backward-delete-word

export FZF_CTRL_T_OPTS=" --preview 'bat --style=numbers --color=always {} | head -500'"
_gen_fzf_default_opts() {
  local base03="234"
  local base02="235"
  local base01="240"
  local base00="241"
  local base0="244"
  local base1="245"
  local base2="254"
  local base3="230"
  local yellow="136"
  local orange="166"
  local red="160"
  local magenta="125"
  local violet="61"
  local blue="33"
  local cyan="37"
  local green="64"

  # Comment and uncomment below for the light theme.

  # Solarized Dark color scheme for fzf
  # export FZF_DEFAULT_OPTS="
  #   --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue
  #   --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
  # "
  ## Solarized Light color scheme for fzf
  export FZF_DEFAULT_OPTS="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:$base2,hl+:$blue
    --color info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow
  "
}
_gen_fzf_default_opts

export BAT_THEME="Solarized (light)"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

export ASDF_DIR=/usr/local/opt/asdf/libexec
. /usr/local/opt/asdf/asdf.sh
