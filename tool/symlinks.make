SYMLINKS := $(shell command -v symlinks || echo /usr/bin/symlinks)

$(SYMLINKS):
	sudo apt install -y symlinks

symlinks: | $(SYMLINKS)

optional:: | symlinks
