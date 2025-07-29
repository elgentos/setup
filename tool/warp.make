$(WARP): | $(CURL)
	$(CURL) -L https://app.warp.dev/download?package=deb --output /tmp/warp.deb
	sudo dpkg --install /tmp/warp.deb || true
	rm -f /tmp/warp.deb
warp: | $(WARP)

optional:: | warp
