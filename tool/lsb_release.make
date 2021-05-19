$(LSB_RELEASE):
	sudo apt install lsb-release -y

lsb_release: | $(LSB_RELEASE)
