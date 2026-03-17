$(MAGEBOX): | $(HOMEBREW)
	$(HOMEBREW) install qoliber/magebox/magebox
	$(MAGEBOX) bootstrap

magebox: | $(MAGEBOX)

install:: | magebox
