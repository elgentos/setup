$(1PASSWORD): | $(CURL)
	sudo apt install -y \
		gnupg2 \
		libatk-bridge2.0-0 \
		libatk1.0-0 \
		libdrm2 \
		libgbm1 \
		libgtk-3-0 \
		libnotify4 \
		libnss3 \
		libxcb-shape0 \
		libxcb-xfixes0 \
		libxshmfence1 \
		xdg-utils

	$(CURL) -L https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb \
		--output /tmp/1password.deb
	sudo dpkg --install /tmp/1password.deb || true
	rm -f /tmp/1password.deb

1password: | $(1PASSWORD)

optional:: | 1password
