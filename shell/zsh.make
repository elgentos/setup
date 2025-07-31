$(ZSH):
	sudo apt install zsh -y
	echo $(INTERACTIVE) | grep -q '1' && chsh --shell $(ZSH) || echo 'Skipping shell change'

$(ZSHRC):
	cp "$(shell pwd)/.zshrc" "$(ZSHRC)"

zsh: | $(ZSH) $(ZSHRC)

$(OH_MY_ZSH): | $(ZSH) $(CURL) $(BASH) $(GIT)
	$(CURL) -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
		| ZSH=$(shell dirname $(OH_MY_ZSH)) $(BASH) -s -- --keep-zshrc --unattended
	sudo apt install fonts-powerline -y

oh-my-zsh: | $(OH_MY_ZSH)

install:: | zsh oh-my-zsh
