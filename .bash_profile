. "$HOME/.bashrc"

eval "$(anyenv init -)"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH="/usr/local/opt/llvm@8/bin:$PATH"

. /usr/local/opt/asdf/libexec/asdf.sh

. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash
