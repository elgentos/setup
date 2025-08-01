$(JETBRAINS_TOOLBOX): | $(JQ) $(CURL)
	$(CURL) -L --output - $(shell $(CURL) 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | $(JQ) '.TBA[0].downloads.linux.link' | sed 's/"//g') | tar zxf - -C /tmp
	mkdir -p $(JETBRAINS_TOOLBOX_DIR)
	mv /tmp/jetbrains-toolbox-*/* $(JETBRAINS_TOOLBOX_DIR)
	sudo cp $(JETBRAINS_TOOLBOX_DIR)/bin/jetbrains-toolbox $(JETBRAINS_TOOLBOX)
	$(JETBRAINS_TOOLBOX)/bin/jetbrains-toolbox & TOOLBOX_PID=$$!; sleep 10; kill $$TOOLBOX_PID || true

$(JETBRAINS_TOOLBOX_SETTINGS): | $(JETBRAINS_TOOLBOX)
	mkdir -p $(shell dirname $(JETBRAINS_TOOLBOX_SETTINGS))
	echo $(INTERACTIVE) | grep -q '1' && $(JETBRAINS_TOOLBOX) || echo '{}' > $(JETBRAINS_TOOLBOX_SETTINGS)

jetbrains-toolbox: $(JETBRAINS_TOOLBOX_SETTINGS)

install:: | jetbrains-toolbox
