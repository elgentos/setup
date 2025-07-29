$(DIALOG):
	sudo add-apt-repository universe
	sudo apt update
	sudo apt install dialog -y

dialog: | $(DIALOG)

install:: | dialog
