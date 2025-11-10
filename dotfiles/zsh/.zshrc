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

# FZF
source <(fzf --zsh)

# SEE INSTALLED/DELETED PACKAGES
alias aqqe="comm -13 <(sort ~/factory_pkgs/factory_Qqet.txt) <(paru -Qqet | sort)"
alias dqqe="comm -23 <(sort ~/factory_pkgs/factory_Qqet.txt) <(paru -Qqet | sort)"
alias aqqet="comm -13 <(sort ~/factory_pkgs/factory_Qqe.txt) <(paru -Qqe | sort)"
alias dqqet="comm -23 <(sort ~/factory_pkgs/factory_Qqe.txt) <(paru -Qqe | sort)"

# QOL ALIASES
alias dotf="~/linux-config/install.sh"
alias la="ls -A"
alias open="xdg-open"
alias zed="zeditor"
alias zz="cd .."

# ZIG
alias zigalloc="~/linux-config/scripts/zig/echo_template.sh"

# ODIN
alias odin-tracker="cp ~/linux-config/scripts/odin/mem_tracker.odin ."
odinb1() { odin build $@ -o:speed -out:release -vet -strict-style -source-code-locations:obfuscated }
odinb1u() { odin build $@ -o:speed -out:release -vet -strict-style -source-code-locations:obfuscated -disable-assert -no-bounds-check }
odinb2() { odin build $@ -o:aggressive -out:release -vet -strict-style -source-code-locations:obfuscated }
odinb2u() { odin build $@ -o:aggressive -out:release -vet -strict-style -source-code-locations:obfuscated -disable-assert -no-bounds-check }
odinb3() { odin build $@ -o:aggressive -out:release -vet -strict-style -source-code-locations:obfuscated -microarch:native }
odinb3u() { odin build $@ -o:aggressive -out:release -vet -strict-style -source-code-locations:obfuscated -disable-assert -no-bounds-check -microarch:native }

# FUNCTIONS
pdfpp() {
  rm -rf ~/Downloads/tmp_pdfpp
  mkdir ~/Downloads/tmp_pdfpp
  pdftoppm -jpeg ~/Downloads/tmp.pdf ~/Downloads/tmp_pdfpp/page
  xdg-open ~/Downloads/tmp_pdfpp
  rm -rf ~/Downloads/tmp.pdf
}
