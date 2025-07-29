$(GNOME-EXTENSIONS):
	sudo apt install gnome-browser-connector -y

gnome-extensions: | $(gnome-extensions)

optional:: | ag