$(SYMLINKS):
	sudo apt install -y symlinks

symlinks: | $(SYMLINKS)

optional:: | symlinks
