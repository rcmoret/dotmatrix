# ~/.bashrc
# vim:set ft=sh sw=2 sts=2:

source "$HOME/.sharedrc"

alias 'be'='bundle exec'
alias 'g'='git status'
alias 'gbr'='git branch'
alias 'ggl'='git log --oneline --abbrev-commit --all --graph --color --decorate'
alias 'gg'='git log --oneline --abbrev-commit --all --graph --color | head'
alias 'grh'='git reset HEAD'
alias 'gs'='git stash'
alias 'gsp'='git stash pop'
alias 'll'='ls -la'
alias 'cprmt'='less ~/repos/misc/rmt.md | pbcopy'
alias 'cpemd'='less ~/repos/misc/emd.md | pbcopy'
alias 'add-ssh-key'='ssh-add -K ~/.ssh/id_rsa'

shovel() ( cd ~/vagrant/code/dev && ./script/run shovel "$@"; )

# Store 10,000 history entries
export HISTSIZE=10000
# Don't store duplicates
export HISTCONTROL=erasedups
# Append to history file
shopt -s histappend

export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig

VISUAL=vim
EDITOR="$VISUAL"
LESS="FRX"
RI="--format ansi -T"
PSQL_EDITOR='vim -c"setf sql"'
CLICOLOR=1
LSCOLORS=gxgxcxdxbxegedabagacad
LDFLAGS="-L/usr/local/opt/llvm@8/lib -Wl,-rpath,/usr/local/opt/llvm@8/lib"
CPPFLAGS="-I/usr/local/opt/llvm@8/include"

export VISUAL EDITOR LESS RI PSQL_EDITOR CLICOLOR LSCOLORS
export IMAC='ryanmoret@192.168.1.81'
export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig

if [ -f ~/.fzf.bash ]; then
  source ~/.fzf.bash
fi

export FZF_DEFAULT_COMMAND='
(git ls-tree -r --name-only HEAD ||
  find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
    sed s/^..//) 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

alias 'ssh-imac'='ssh $IMAC'

if [ -t 1 ]; then
bind 'set bind-tty-special-chars off'
bind '"\ep": history-search-backward'
bind '"\en": history-search-forward'
bind '"\C-w": backward-kill-word'
bind '"\C-q": "%-\n"'
fi

export HISTIGNORE="%*"

[ -z "$PS1" ] || stty -ixon

prefix=
if [ -n "$SSH_CONNECTION" ]; then
  prefix="\[\033[01;33m\]\u@\h"
else
  prefix="\[\033[01;32m\]\u@\h"
fi

[ -z "$PS1" ] || export PS1="$prefix\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\$(git_prompt_info '(%s)')$ "

if [ -f '/usr/local/etc/bash_completion.d/git-completion.bash' ]; then
  source '/usr/local/etc/bash_completion.d/git-completion.bash'
fi

# Aliases
# * Additional aliases are found in `.sharedrc`
#
alias reload='source ~/.bash_profile; echo -e "\n\u2699  \033[0;33mBASH config reloaded\033[0m \u2699"'

# use `g` like git
_g() {
  if [[ $# > 0 ]]; then
    git "$@"
  else
    git status
  fi
}

alias g=_g
# enable completion for `g`
__git_complete g _git

[ ! -f "$HOME/.bashrc.local" ] || . "$HOME/.bashrc.local"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
