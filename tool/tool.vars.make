AG := $(shell command -v ag || echo /usr/bin/ag)
ACT := $(shell command -v act || echo /usr/local/bin/act)
CURL := $(shell command -v curl || echo /usr/bin/curl)
IP := $(shell command -v ip || echo /usr/sbin/ip)
JQ := $(shell command -v jq || echo /usr/bin/jq)
LSB_RELEASE := $(shell command -v lsb_release || echo /usr/bin/lsb_release)
MULTITAIL := $(shell command -v multitail || echo /usr/bin/multitail)
SYMLINKS := $(shell command -v symlinks || echo /usr/bin/symlinks)
TMUX := $(shell command -v tmux || echo /usr/bin/tmux)
TMUXINATOR := $(shell command -v tmuxinator || echo /usr/bin/tmuxinator)
TMUXINATOR_COMPLETION_ZSH = /usr/local/share/zsh/site-functions/_tmuxinator
TMUXINATOR_COMPLETION_BASH = /etc/bash_completion.d/tmuxinator.bash
UFW := $(shell command -v ufw || echo /usr/sbin/ufw)
