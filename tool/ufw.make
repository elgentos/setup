$(UFW): | $(BASH)
	sudo apt install -y ufw
	$(BASH) -c '[ -f /.dockerenv ] || sudo ufw enable'

ufw: | $(UFW)
