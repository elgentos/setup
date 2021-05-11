SOFTWARE_PROPERTIES_COMMON := $(shell command -v add-apt-repository || echo /usr/bin/add-apt-repository)

$(SOFTWARE_PROPERTIES_COMMON):
	sudo apt install software-properties-common -y
