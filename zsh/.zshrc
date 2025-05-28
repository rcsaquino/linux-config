# source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# OH-MY-ZSH
export ZSH="/usr/share/oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
    git
)
source $ZSH/oh-my-zsh.sh

# ZSH
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# ZOXIDE
eval "$(zoxide init zsh)"

# ALIASES
alias la="ls -A"
alias pdifa="comm -13 <(sort ~/factory_pkgs/factory_Qqet.txt) <(paru -Qqet | sort)"
alias pdifd="comm -23 <(sort ~/factory_pkgs/factory_Qqet.txt) <(paru -Qqet | sort)"
alias pdifat="comm -13 <(sort ~/factory_pkgs/factory_Qqe.txt) <(paru -Qqe | sort)"
alias pdifdt="comm -23 <(sort ~/factory_pkgs/factory_Qqe.txt) <(paru -Qqe | sort)"
alias zed="zeditor"
alias zz="cd .."

# FUNCTIONS
pdfpp() {
  rm -rf ~/Downloads/tmp_pdfpp
  mkdir ~/Downloads/tmp_pdfpp
  pdftoppm -jpeg ~/Downloads/tmp.pdf ~/Downloads/tmp_pdfpp/page
  xdg-open ~/Downloads/tmp_pdfpp
  rm -rf ~/Downloads/tmp.pdf
}
