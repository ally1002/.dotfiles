# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/bin:$PATH"

export FACIL123="$HOME/Desktop/$USER/facil123"

plugins=(
    git
    asdf
    zsh-autosuggestions
    F-Sy-H # fast-syntax-highlighting plugin
)

source $ZSH/oh-my-zsh.sh

. "$HOME/.asdf/asdf.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Powerlevel10k configuration
ZSH_THEME="powerlevel10k/powerlevel10k"
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Home brew configuration
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Custom aliases and functions
alias facil123="cd $FACIL123"
alias aly="cd $HOME/Desktop/aly"
alias localhost="facil123 && bin/dev"
alias google="flatpak run com.google.Chrome"
alias fucking="sudo"
alias todo="nvim ~/Desktop/aly/todo.md"
alias zshconfig="nvim ~/.zshrc"
alias nvimdir="cd ~/.config/nvim/"
alias nvimconfig="nvim ~/.config/nvim/init.lua"
alias coverage="facil123 && xdg-open coverage/"

# needs a parameter <path> to work
function yw() {
  facil123 && npm run jest:watch $1
}

function jest-error() {
  bash ~/jest-error.bash $1 $2
}

eval $(thefuck --alias)
eval $(thefuck --alias FUCK)
