$(CLAUDE): | $(HOMEBREW)
	eval "$$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew install claude-code

claude: | $(CLAUDE)

install:: | claude
