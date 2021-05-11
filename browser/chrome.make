CHROME := $(shell command -v google-chrome || echo /usr/bin/google-chrome)

$(CHROME): | $(CURL)
	sudo apt install -y \
		fonts-liberation \
		libasound2 \
		libatk-bridge2.0-0 \
		libatk1.0-0 \
		libatspi2.0-0 \
		libcairo2 \
		libcups2 \
		libdbus-1-3 \
		libdrm2 \
		libexpat1 \
		libgbm1 \
		libgdk-pixbuf2.0-0 \
		libglib2.0-0 \
		libgtk-3-0 \
		libnspr4 \
		libnss3 \
		libpango-1.0-0 \
		libpangocairo-1.0-0 \
		libx11-6 \
		libx11-xcb1 \
		libxcb-dri3-0 \
		libxcb1 \
		libxcomposite1 \
		libxdamage1 \
		libxext6 \
		libxfixes3 \
		libxrandr2 \
		wget \
		xdg-utils
	$(CURL) -L https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    		--output /tmp/google-chrome-stable_current_amd64.deb
	sudo dpkg --install /tmp/google-chrome-stable_current_amd64.deb
	rm -f /tmp/google-chrome-stable_current_amd64.deb

google-chrome: | $(CHROME)

browsers:: | google-chrome
optional:: | google-chrome
