fpath=(
  $fpath
  ~/.zsh/functions
  /usr/local/share/zsh/site-functions
)

stty sane

# color term
export CLICOLOR=1
export LSCOLORS=Dxfxcxdxbxegedabadacad
export ZLS_COLORS=$LSCOLORS
export LC_CTYPE=en_US.UTF-8
export LESS=FRX
export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig
export NVIM_PKG_PATH="$HOME/.local/share/nvim/site/pack/packer/start"

export VISUAL EDITOR LESS RI PSQL_EDITOR CLICOLOR LSCOLORS

VISUAL=nvim
EDITOR="$VISUAL"
LESS="FRX"
RI="--format ansi -T"
PSQL_EDITOR='nvim -c"setf sql"'
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

# Git helpers
#
# git_prompt_info accepts 0 or 1 arguments (i.e., format string) and returns
# the text the prompt appends: branch name, in-progress operation, dirty marks.
git_prompt_info () {
  local g="$(command git rev-parse --git-dir 2>/dev/null)"
  if [ -n "$g" ]; then
    local r
    local b
    local d
    local s
    # Rebasing
    if [ -d "$g/rebase-apply" ] ; then
      if test -f "$g/rebase-apply/rebasing" ; then
        r="|REBASE"
      fi
      b="$(command git symbolic-ref HEAD 2>/dev/null)"
    # Interactive rebase
    elif [ -f "$g/rebase-merge/interactive" ] ; then
      r="|REBASE-i"
      b="$(cat "$g/rebase-merge/head-name")"
    # Merging
    elif [ -f "$g/MERGE_HEAD" ] ; then
      r="|MERGING"
      b="$(command git symbolic-ref HEAD 2>/dev/null)"
    else
      if [ -f "$g/BISECT_LOG" ] ; then
        r="|BISECTING"
      fi
      if ! b="$(command git symbolic-ref HEAD 2>/dev/null)" ; then
        if ! b="$(command git describe --exact-match HEAD 2>/dev/null)" ; then
          b="$(cut -c1-7 "$g/HEAD")..."
        fi
      fi
    fi

    # Dirty branch
    d=''
    s=$(command git status --porcelain 2> /dev/null)
    [[ $s =~ '\?\? ' ]] && d+='+'
    [[ $s =~ "M " ]] && d+='*'
    [[ $s =~ "D " ]] && d+='-'

    printf "${1-"(%s) "}" "${b##refs/heads/}$r$d"
  fi
}

# check out a remote branch by name
gcr() {
  git checkout -b $1 origin/$1
}

# git reset empty files
gref() {
  command git --no-pager diff --cached --stat | command grep "|\s*0$" | awk '{system("command git reset " $1)}'
}

# prompt
p=
if [ -n "$SSH_CONNECTION" ]; then
  p='%{$fg_bold[yellow]%}%n@%m'
else
  p='%{$fg_bold[green]%}%n'
fi
PROMPT="$p%{\$reset_color%}:%{\$fg_bold[cyan]%}%~%{\$reset_color%}\$(git_prompt_info '(%s)')~> "


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
(( ${+EDITOR}  )) || export EDITOR='nvim'
export PSQL_EDITOR='nvim -c"setf sql"'

# Aliases
#
alias l="ls -F -G -lah"
alias ll="ls -la"
alias la="ls -a"
alias lsd='ls -ld *(-/DN)'
alias md='mkdir -p'
alias rd='rmdir'
alias cd..='cd ..'
alias ..='cd ..'
alias reload='source ~/.zshrc; echo -e "\n\u2699  \e[33mZSH config reloaded\e[0m \u2699"'
# why the fuck is smartcase on by default?
alias ag="ag -s"
alias jq="jq --color-output | less -R"

# spelling is hard
alias mdkir="mkdir"

alias 'g'='git status'
alias 'gbr'='git branch'
alias 'ggl'='git log --oneline --abbrev-commit --all --graph --color --decorate'
alias 'gg'='git log --oneline --abbrev-commit --all --graph --color | head'
alias 'grh'='git reset HEAD'
alias 'gs'='git stash'
alias 'gsp'='git stash pop'
alias 'gpu'='git push -u origin $(git branch --show-current)'
alias 'gbcr'='git branch --show-current'
alias 'gcb'='~/scripts/git-change-branch.sh'
alias 'gbl'='~/scripts/git-branch-lookup.sh'
alias 'gsno'='git show --name-only'
alias 'gdno'='git diff --name-only'
alias 'gdnoom'='git diff --name-only origin/main'
alias 'gcp'='git cherry-pick'
alias 'gca'='git cherry-pick --abort'
alias 'gcc'='git cherry-pick --continue'
alias gap='git add -p'
alias gco='git checkout'
alias gd='git diff'
alias gdc='git diff --cached'
alias glod='git log --oneline --decorate'
alias gpr='git pull --rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias reset-authors='git commit --amend --reset-author -C HEAD'
alias 'add-ssh-key'='ssh-add -K ~/.ssh/id_rsa'
alias 'routes'="bundle exec rails routes | fzf"

alias vi='nvim'
alias vim='nvim'

l.() {
  ls -ld "${1:-$PWD}"/.[^.]*
}

export ASDF_RUBY_BUILD_VERSION=master
export PLATFORM_DEV="$HOME/repos/dev"

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
cdpath=(~ ~/repos)

# remove duplicates in $PATH
typeset -aU path

export PATH=/usr/local/opt/postgresql@14/bin:$PATH:/Users/ryanmoret/Library/Python/3.8/bin:/Users/ryanmoret/scripts:/usr/local/opt/libpq/bin

command -v brew > /dev/null && [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh 

bindkey '^P' fzf-file-widget

bindkey "\e[3~" delete-char

my-backward-delete-word() {
    local WORDCHARS="*?-[]~=&;!#$%^(){}<>"
    # local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^W' my-backward-delete-word

source <(fzf --zsh)
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
  #
  # export FZF_DEFAULT_OPTS="
  #   --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue
  #   --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
  # "


  ## Solarized Light color scheme for fzf
  #
  export FZF_DEFAULT_OPTS="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:$base2,hl+:$blue
    --color info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow
  "
}
_gen_fzf_default_opts


export BAT_THEME="Solarized (light)"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/ryanmoret/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
source <(fzf --zsh)
export LSP_LOGS=$HOME/.local/state/nvim/lsp.log

eval "$(direnv hook zsh)"
eval "$(~/.local/bin/mise activate zsh)"
