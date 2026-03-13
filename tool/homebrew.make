$(HOMEBREW): | $(BASH) $(CURL)
	NONINTERACTIVE=1 $(BASH) -c "$$($(CURL) -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo 'eval "$$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $(ZSHRC)

homebrew: | $(HOMEBREW)

install:: | homebrew
