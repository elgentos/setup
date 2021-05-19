$(NVM): | $(CURL) $(BASH) $(ZSHRC)
	$(CURL) -sf https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | $(BASH)
	echo 'export NVM_DIR="$$HOME/.nvm"' >> $(ZSHRC)
	echo '[ -s "$$NVM_DIR/nvm.sh" ] && \. "$$NVM_DIR/nvm.sh"  # This loads nvm' >> $(ZSHRC)
	echo '[ -s "$$NVM_DIR/bash_completion" ] && \. "$$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> $(ZSHRC)

$(NODE): | $(NVM) $(BASH)
	$(BASH) -c 'source $(NVM) && nvm install 10'

node: | $(NODE)

$(NPM): | $(NODE)
npm: | $(NPM)

install:: | npm
