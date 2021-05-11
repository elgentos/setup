AG := $(shell command -v ag || echo /usr/bin/ag)

$(AG):
	sudo apt install silversearcher-ag -y

ag: | $(AG)

optional:: | ag
