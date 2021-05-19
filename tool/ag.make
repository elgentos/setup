$(AG):
	sudo apt install silversearcher-ag -y

ag: | $(AG)

optional:: | ag
