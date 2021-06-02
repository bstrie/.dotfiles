# Prompt stuff
set fish_greeting ''
set -g moon_phase 🌘
set -g host (command hostname -s)
set -g prior_bg

# Bonus colors
set -g blackplus 3c3836
set -g brblackplus 665c54
set -g whiteminus bdae93
set -g brwhiteminus ebdbb2

# Autojump
if test -f /usr/share/autojump/autojump.fish # Linux
    source /usr/share/autojump/autojump.fish
else if test -f (brew --prefix)/share/autojump/autojump.fish # Mac
    source (brew --prefix)/share/autojump/autojump.fish
end

# Aliases
alias l exa
alias ls exa
alias ll 'exa -l'
alias la 'exa -a'
alias lla 'exa -la'
alias gg 'git grep'
alias gd 'git diff -w'
alias nv 'VIMRUNTIME=/Users/bapple/code/neovim/runtime /Users/bapple/code/neovim/build/bin/nvim'
