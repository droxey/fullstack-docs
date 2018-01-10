# zsh Config:
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"
fpath=(/usr/local/share/zsh-completions $fpath)
plugins=(colorize docker git virtualenv zsh-iterm-touchbar emoji-cli auto-ls zsh-wakatime)

# User Config:
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export SSH_KEY_PATH="~/.ssh/rsa_id"
export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"
export PYTHON="/usr/local/opt/python/libexec/bin/python"
source $ZSH/oh-my-zsh.sh

# PATH Amendments:
export PATH="/usr/local/opt/yarn/bin:$PATH"
export PATH="/usr/local/bin/yarn:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/make/libexec/gnuman:$MANPATH"

# VirtualEnv
export VIRTUALENVWRAPPER_PYTHON=/Library/Frameworks/Python.framework/Versions/3.6/bin/python3
export WORKON_HOME=~/.venv
#source /usr/local/bin/virtualenvwrapper.sh

# Ruby / OpenSSL:
export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig
export LDFLAGS=-L/usr/local/opt/openssl/lib
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"
eval "$(rbenv init -)"

# Editor Config:
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='rmate'
else
  export EDITOR='code'
fi

# pyenv Completions:
if [[ ! -o interactive ]]; then
    return
fi

compctl -K _pyenv pyenv

_pyenv() {
  local words completions
  read -cA words

  if [ "${#words}" -eq 2 ]; then
    completions="$(pyenv commands)"
  else
    completions="$(pyenv completions ${words[2,-2]})"
  fi

  reply=(${(ps:\n:)completions})
}

# iTerm2 Integration:
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
unalias imgcat

# ===
# Git Integration:
# ===
GIT_UNCOMMITTED="+"
GIT_UNSTAGED="!"
GIT_UNTRACKED="?"
GIT_STASHED="$"
GIT_UNPULLED="⇣"
GIT_UNPUSHED="⇡"

###-begin-npm-completion-###
if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###
