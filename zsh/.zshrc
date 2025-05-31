# source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# ZSH THEME
export ZSH="/usr/share/oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# ZSH PLUGINS
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
alias open="xdg-open"
alias zed="zeditor"
alias zz="cd .."

# ODIN HELPERS
alias odin-tracker="cp ~/dotfiles/not_dotfiles/mem_tracker.odin ."
odinb1() { odin build $@ -o:speed -out:release -vet -strict-style -obfuscate-source-code-locations }
odinb1u() { odin build $@ -o:speed -out:release -vet -strict-style -obfuscate-source-code-locations -disable-assert -no-bounds-check }
odinb2() { odin build $@ -o:aggressive -out:release -vet -strict-style -obfuscate-source-code-locations }
odinb2u() { odin build $@ -o:aggressive -out:release -vet -strict-style -obfuscate-source-code-locations -disable-assert -no-bounds-check }
odinb3() { odin build $@ -o:aggressive -out:release -vet -strict-style -obfuscate-source-code-locations -microarch:native }
odinb3u() { odin build $@ -o:aggressive -out:release -vet -strict-style -obfuscate-source-code-locations -disable-assert -no-bounds-check -microarch:native }

# FUNCTIONS
pdfpp() {
  rm -rf ~/Downloads/tmp_pdfpp
  mkdir ~/Downloads/tmp_pdfpp
  pdftoppm -jpeg ~/Downloads/tmp.pdf ~/Downloads/tmp_pdfpp/page
  xdg-open ~/Downloads/tmp_pdfpp
  rm -rf ~/Downloads/tmp.pdf
}
