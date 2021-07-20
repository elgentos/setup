$(DIALOG):
	sudo apt install -y dialog

dialog: | $(DIALOG)

install:: | dialog
