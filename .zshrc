# =============================================================================
# Environment Variables
# =============================================================================
export STARSHIP_CONFIG=~/.starship.toml
export EDITOR=nvim
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
alias grep='grep -n --color'
alias cat='bat'
alias ls="eza --color=always --long -G --git -a -m --group-directories-first  --icons=always --no-time --no-user --no-permissions"
alias reload-zsh="source ~/.zshrc"
alias zshconfig="nvim ~/.zshrc"


# =============================================================================
# AUTOSTART
# =============================================================================

# =============================================================================
# Fastfetch
# =============================================================================
if [[ $(tty) == *"pts"* ]]; then
    fastfetch --config examples/13
else
    echo
    if [ -f /bin/qtile ]; then
        echo "Start Qtile X11 with command Qtile"
    fi
    if [ -f /bin/hyprctl ]; then
        echo "Start Hyprland with command Hyprland"
    fi
fi

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
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
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
# Conda initialization
__conda_setup="$('/home/andrew/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/andrew/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/andrew/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/andrew/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Starship prompt
eval "$(starship init zsh)"
