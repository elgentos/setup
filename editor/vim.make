$(VIM):
	sudo apt install vim -y

vim: | $(VIM)

install:: | vim
