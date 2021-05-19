# Use systemctl, or a dummy.
SYSTEMCTL := $(shell command -v systemctl || echo echo systemctl)
