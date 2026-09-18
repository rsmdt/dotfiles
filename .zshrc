# zmodload zsh/zprof
setopt autocd

# XDG Base Directory Specification
# Many tools (brew bundle, etc.) check this variable for config location
# @see https://specifications.freedesktop.org/basedir-spec/latest/
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Local bin directory for user scripts
export PATH="$HOME/.local/bin:$PATH"

# Flag for interactive TTY sessions
# Use this to guard command overloads (cd, rm, etc.) that shouldn't run in automation
_is_user_tty=false
[[ -o interactive && -t 1 ]] && _is_user_tty=true

# if (( $+commands[herdr] )); then
#   : ${HERDR_AUTOSTART:=true}
#   if [[ "$HERDR_AUTOSTART" == "true" && -z "$HERDR_ENV" && -z "$TMUX" && -z "$VIM" && -o interactive && -t 0 && -t 1 && "$TERM" != "dumb" ]]; then
#     herdr
#   fi
# fi

if [[ $+commands[brew] == "0" ]]; then
  # if [[ "$(uname -m)" == "x86_64" ]]; then
  #   if [[ -f /usr/local/Homebrew/bin/brew ]]; then
  #     eval $(/usr/local/Homebrew/bin/brew shellenv)
  #   fi
  # else
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval $(/opt/homebrew/bin/brew shellenv)
  fi
fi

if [[ $+commands[git] == "0" ]]; then
  print "zsh: git command not found. Install git to load zsh correctly." >&2
  return 1
fi

#
# Setup zinit plugin manager
# @see https://github.com/zdharma-continuum/zinit
#
# # Self update
# zinit self-update
#
# # Plugin update
# zinit update
#
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "${ZINIT_HOME}" ]; then
  mkdir -p "$(dirname ${ZINIT_HOME})"
  git clone https://github.com/zdharma-continuum/zinit.git --depth=1 "${ZINIT_HOME}"
fi

source "${ZINIT_HOME}/zinit.zsh"

##
# Zinit plugins with Turbo mode optimization
# @see https://zdharma-continuum.github.io/zinit/wiki/INTRODUCTION/
#
# Turbo mode (wait) defers loading until after prompt for faster startup
# lucid = don't show "Loaded plugin" messages
# depth=1 = shallow clone for faster install
#

# fzf-tab is turbo loaded; until it lands, tab falls back to zsh's own menu
zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# Syntax highlighting - turbo loaded
zinit ice wait lucid depth=1
zinit light zsh-users/zsh-syntax-highlighting

# Autosuggestions - turbo loaded with fix for first prompt
# atload calls the start function since precmd won't fire on first prompt
zinit ice wait lucid depth=1 atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# Extra completions - turbo loaded, blockf prevents fpath modification issues
zinit ice wait lucid depth=1 blockf atpull'zinit creinstall -q .; zinit cclear'
zinit light zsh-users/zsh-completions

# OMZ snippets - turbo loaded for non-critical features
# @see https://github.com/zdharma-continuum/zinit?tab=readme-ov-file#migration
zinit ice wait lucid
zinit snippet OMZ::lib/completion.zsh

zinit ice wait lucid
zinit snippet OMZ::plugins/colored-man-pages

# Optimized compinit: only regenerate completion dump once per day
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
  touch ~/.zcompdump
else
  compinit -C  # Use cached completions without security check
fi

zinit cdreplay -q

#
# User configuration

# WezTerm shell integration for semantic zones
# Enables: jump between prompts (Cmd+Shift+Up/Down), select command output (triple-click)
#   @see https://wezterm.org/shell-integration.html
if [[ "$TERM_PROGRAM" == "WezTerm" || "$TERM" == "wezterm" ]]; then
  if [[ -f "$HOME/.config/wezterm/wezterm.sh" ]]; then
    source "$HOME/.config/wezterm/wezterm.sh"
  fi
fi

# Enable prompt (oh-my-posh) with smart caching
# Auto-regenerates cache when theme file is modified
if [[ $+commands[oh-my-posh] == "1" ]]; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/daywalker.toml)"
fi

# fzf-tab configuration
#
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# # set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
# zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --oneline --color=always --tree --level=2 $realpath'
# # switch group using `<` and `>`
# zstyle ':fzf-tab:*' switch-group '<' '>'
# # make use of tmux popup
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

[[ "$_is_user_tty" == "true" ]] && alias rm='rm -I'

# Preferred editor for local and remote sessions
#   brew install nvim
if [[ $+commands[nvim] == "1" ]]; then
  if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
  else
    export EDITOR='nvim'
  fi

  alias vim="nvim"
  alias v=nvim
else
  export EDITOR='vim'
  alias v=vim
fi

# Tool version manager for Node, Ruby, others (alternative to asdf)
#   brew install mise
#
# @see https://mise.jdx.dev/
if [[ $+commands[mise] == "1" ]]; then
  # Use --shims for faster startup (no hook on every command)
  # Trade-off: Won't auto-switch versions when cd'ing into directories
  # Use `mise activate zsh` instead if you need auto-switching
  eval "$(mise activate zsh --shims)"
fi

# Better cat with colors
#   brew install bat
# Theme is dynamic to support dark-notify mid-session switching
if [[ $+commands[bat] == "1" ]]; then
  function cat() {
    local theme
    if defaults read -globalDomain AppleInterfaceStyle &>/dev/null 2>&1; then
      theme="tokyonight_moon"
    else
      theme="tokyonight_day"
    fi

    command bat --theme="$theme" "$@"
  }
fi

# Better top
#   brew install btop
# @see https://github.com/aristocratos/btop
if [[ $+commands[btop] == "1" ]]; then
  alias top=btop
fi

# better df (display free disk space)
#   brew install duf
# @see https://github.com/muesli/duf
if [[ $+commands[duf] == "1" ]]; then
  alias df=duf
fi

# better du (disk usage satistics)
#   brew install dust
# @see https://github.com/bootandy/dust
if [[ $+commands[dust] == "1" ]]; then
  alias du="dust -r"
fi

# Better ls
#   brew install eza
# @see https://github.com/eza-community/eza
if [[ $+commands[eza] == "1" ]]; then
  alias ls="eza --group-directories-first --icons"
  alias l="ls --oneline"
  alias ll="ls --long --git"
  alias la="l --all"
  alias lt="l --tree --level=5 --ignore-glob='.git|node_modules'"
else
  echo "Get better ls output with: brew install eza"

  alias ls="ls -G"
  alias l="ls"
  alias ll="ls -lh"
  alias la="ls -a"
  alias lt="ls"
fi

# Better grep
#   brew install ripgrep
if [[ $+commands[rg] == "1" ]]; then
  alias grep=rg
else
  alias grep="grep --color=auto --exclude-dir={.git,.vscode}"
fi

# better cd
#   brew install zoxide
# @see https://github.com/ajeetdsouza/zoxide
if [[ $+commands[zoxide] == "1" && "$_is_user_tty" == "true" ]]; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# Command-line fuzzy finder
#   brew install fzf
# @see https://github.com/junegunn/fzf
if [[ $+commands[fzf] == "1" ]]; then
  # Options to fzf command
  export FZF_COMPLETION_OPTS='--border --info=inline'
  # Options for path completion (e.g. vim **<TAB>)
  export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'
  # Options for directory completion (e.g. cd **<TAB>)
  export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'

  source <(fzf --zsh)

  # Use fd (https://github.com/sharkdp/fd) for listing path candidates.
  # - The first argument to the function ($1) is the base path to start traversal
  # - See the source code (completion.{bash,zsh}) for the details.
  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
  }

  # Advanced customization of fzf options via _fzf_comprun function
  # - The first argument to the function is the name of the command.
  # - You should make sure to pass the rest of the arguments to fzf.
  _fzf_comprun() {
    local command=$1
    shift

    case "$command" in
      cd) fzf --preview 'eza --group-directories-first --color=always --icons --tree --level=2 {} | head -200' "$@" ;;
      *)  fzf --preview 'bat -n --color=always {}' "$@" ;;
      # *)  fzf "$@" ;;
    esac
  }
fi

# Magical shell history with SQLite backend
#   brew install atuin
# @see https://atuin.sh/
if [[ $+commands[atuin] == "1" ]]; then
  eval "$(atuin init zsh)"
fi

source "${HOME}/.zshrc.user.zsh"

# zprof
