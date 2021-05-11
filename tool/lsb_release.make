LSB_RELEASE := $(shell command -v lsb_release || echo /usr/bin/lsb_release)

$(LSB_RELEASE):
	sudo apt install lsb-release -y

lsb_release: | $(LSB_RELEASE)
