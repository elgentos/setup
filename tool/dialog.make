$(DIALOG):
	sudo apt install software-properties-common -y
	sudo apt update
	sudo apt install dialog -y

dialog: | $(DIALOG)

install:: | dialog
