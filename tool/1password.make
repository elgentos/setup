$(1PASSWORD): | $(CURL)
	$(CURL) -L https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb \
		--output /tmp/1password.deb
	sudo dpkg --install /tmp/1password.deb || true
	rm -f /tmp/1password.deb


1password: $(1PASSWORD)

optional:: | 1password
