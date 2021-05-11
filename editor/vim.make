VIM := $(shell command -v vim || echo /usr/bin/vim)

$(VIM):
	sudo apt install vim -y

vim: | $(VIM)

install:: | vim
