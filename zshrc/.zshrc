export PATH="$HOME/.local/opt/nvim-linux-x86_64/bin:$HOME/.local/bin:$PATH"

# ── Prompt ──────────────────────────────────────
autoload -Uz colors && colors
setopt PROMPT_SUBST

prompt_git_branch() {
  local branch
  branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) ||
    branch=$(git rev-parse --short HEAD 2>/dev/null) || return
  [[ -n "$branch" ]] && print -n " %F{yellow}git:($branch)%f"
}

setopt PROMPT_SUBST
PROMPT='%F{blue}╭─%f %F{green}%n%f %F{8}in%f %F{cyan}%~%f $(prompt_git_branch)
%F{blue}╰─%f %F{magenta}$%f '

# ── eza ────────────────────────────────────────

# eza aliases with icons
alias ls='eza --icons=auto --group-directories-first'
alias ll='eza -lah --icons=auto --group-directories-first'
alias la='eza -a --icons=auto --group-directories-first'
alias tree='eza --tree --icons=auto'
alias lt='eza --tree --icons=auto'

# Neovim
alias nv='nvim'
alias ex='exit'
alias tm='tmux'

alias cclean='bash ~/LinuxCleaner_42.sh'
export PATH="$HOME/.local/bin:$PATH"
