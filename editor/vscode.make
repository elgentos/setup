$(VSCODE): | $(CURL)
	$(CURL) -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o /tmp/vscode-latest.deb
	sudo dpkg --install /tmp/vscode-latest.deb || true

vscode: | $(VSCODE)

optional:: | vscode
