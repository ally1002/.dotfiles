export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/bin:$PATH"

export FACIL123="$HOME/Desktop/$USER/facil123"

ZSH_THEME=fwalch

plugins=(
    git
    asdf
    zsh-autosuggestions
    F-Sy-H # fast-syntax-highlighting plugin
)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $ZSH/oh-my-zsh.sh


. "$HOME/.asdf/asdf.sh"

# Home brew configuration
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Custom aliases and functions
alias facil123="cd $FACIL123"
alias aly="cd $HOME/Desktop/aly"
alias fucking="sudo"
alias todo="nvim ~/Desktop/aly/todo.md"
alias nvimdir="cd ~/.config/nvim/"
alias coverage="cd $FACIL123 && xdg-open coverage/"

# needs a parameter <path> to work
function yw() {
  facil123 && npm run jest:watch $1
}

function jest-error() {
  bash ~/jest-error.bash $1 $2
}
