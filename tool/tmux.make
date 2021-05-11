TMUX := $(shell command -v tmux || echo /usr/bin/tmux)
TMUXINATOR := $(shell command -v tmuxinator || echo /usr/bin/tmuxinator)
TMUXINATOR_COMPLETION_ZSH = /usr/local/share/zsh/site-functions/_tmuxinator
TMUXINATOR_COMPLETION_BASH = /etc/bash_completion.d/tmuxinator.bash

$(TMUX):
	sudo apt install -y tmux

tmux: | $(TMUX)

$(TMUXINATOR): | $(TMUX)
	sudo apt install -y tmuxinator

tmuxinator: | $(TMUXINATOR)

$(TMUXINATOR_COMPLETION_ZSH): | $(TMUXINATOR) $(ZSH) $(CURL)
	sudo mkdir -p "$(shell dirname "$(TMUXINATOR_COMPLETION_ZSH)")";
	$(CURL) -L https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh \
		| sudo tee $(TMUXINATOR_COMPLETION_ZSH)

$(TMUXINATOR_COMPLETION_BASH): | $(TMUXINATOR) $(BASH) $(CURL)
	sudo mkdir -p "$(shell dirname "$(TMUXINATOR_COMPLETION_BASH)")";
	$(CURL) -L https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.bash \
		| sudo tee $(TMUXINATOR_COMPLETION_BASH)

tmuxinator_completion: | $(TMUXINATOR_COMPLETION_ZSH) $(TMUXINATOR_COMPLETION_BASH)

optional:: | tmux tmuxinator tmuxinator_completion
