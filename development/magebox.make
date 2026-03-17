$(MAGEBOX): | $(HOMEBREW)
	$(HOMEBREW) install qoliber/magebox/magebox
	$(MAGEBOX) bootstrap --unattended

magebox: | $(MAGEBOX)

install:: | magebox
