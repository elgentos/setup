$(JETBRAINS_TOOLBOX): | $(JQ) $(CURL)
	$(CURL) -L --output - $(shell $(CURL) 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | $(JQ) '.TBA[0].downloads.linux.link' | sed 's/"//g') | tar zxf - -C /tmp
	sudo chmod +x /tmp/jetbrains-toolbox-*/bin/jetbrains-toolbox.desktop
	sudo mv /tmp/jetbrains-toolbox-*/bin $(JETBRAINS_TOOLBOX)

$(JETBRAINS_TOOLBOX_SETTINGS): | $(JETBRAINS_TOOLBOX)
	mkdir -p $(shell dirname $(JETBRAINS_TOOLBOX_SETTINGS))
	echo $(INTERACTIVE) | grep -q '1' && $(JETBRAINS_TOOLBOX) || echo '{}' > $(JETBRAINS_TOOLBOX_SETTINGS)

jetbrains-toolbox: $(JETBRAINS_TOOLBOX_SETTINGS)

install:: | jetbrains-toolbox
