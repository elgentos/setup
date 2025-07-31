$(WARP): | $(CURL)
	sudo apt install fontconfig libegl1 libwayland-egl1 libxcursor1 libxi6 libxkbcommon-x11-0 -y
	$(CURL) -L https://app.warp.dev/download?package=deb --output /tmp/warp.deb
	sudo dpkg --install /tmp/warp.deb || true
	rm -f /tmp/warp.deb

warp: | $(WARP)

optional:: | warp
