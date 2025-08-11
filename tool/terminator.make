$(TERMINATOR):
	sudo apt update
	sudo apt install terminator -y

terminator: | $(TERMINATOR)

optional:: | terminator
