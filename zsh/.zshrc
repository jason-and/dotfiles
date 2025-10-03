# =============================================================================
# Environment Variables
# =============================================================================
export STARSHIP_CONFIG=~/.starship.toml
export EDITOR=emacsclient
export BROWSER=zen-browser
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export FPATH="/usr/bin/eza/completions/zsh:$FPATH"

# =============================================================================
# History Configuration
# =============================================================================
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# =============================================================================
# Basic Aliases
# =============================================================================
alias em='emacsclient -n -c -a emac'
alias grep='grep -n --color'
alias cat='bat'
alias ls="eza --color=always --long -G --git -a -m --group-directories-first  --icons=always --no-time --no-user --no-permissions"
alias reload-zsh="source ~/.zshrc"
alias zshconfig="emacsclient -c -n ~/.zshrc"
alias r="radian"
alias copy="wl-copy"
alias pi='ssh pi4@192.168.0.220'
alias vim='nvim'
alias cp='cp -i -v'
alias mv='mv -i -v'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias rm='rm -i -v'
alias qgis='QT_QPA_PLATFORM=xcb qgis &'
# -----------------------------------------------------
# Git
# -----------------------------------------------------
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias git merge="git merge --no-ff"
# alias gp="git push"
# alias gpl="git pull"
# alias gst="git stash"
# alias gsp="git stash; git pull"
# alias gfo="git fetch origin"
# alias gcheck="git checkout"
# alias gcredential="git config credential.helper store"
#
# =============================================================================
# FZF Configuration (Fuzzy Finder)
# =============================================================================
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Use fd instead of find
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Preview configuration
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"


# Advanced customization of fzf options
_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# FZF completion generators using fd
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}


# =============================================================================
# Yazi
# =============================================================================

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# =============================================================================
# ZSH Completion and Navigation
# =============================================================================
autoload -Uz +X compinit && compinit

# Case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Auto suggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Zoxide (better cd) configuration
eval "$(zoxide init zsh)"
alias cd="z"

# =============================================================================
# Package Managers and Tools
# =============================================================================

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


# Starship prompt
eval "$(starship init zsh)"

# systemd use user enviroment
systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XAUTHORITY

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/andrew/.lmstudio/bin"
export PATH="/home/andrew/.pixi/bin:$PATH"

#vim motions in terminal
bindkey -v

export LEDGER_FILE=~/finance/2025.journal
