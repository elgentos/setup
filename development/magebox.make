$(MAGEBOX): | $(HOMEBREW)
	CI="" $(HOMEBREW) install qoliber/magebox/magebox
	$(MAGEBOX) bootstrap --unattended --tld=localhost
	mkdir -p $(HOME)/workspace/elgentos/example/pub
	cd $(HOME)/workspace/elgentos/example && $(MAGEBOX) init elgentos.example
	echo '<?php phpinfo();' > $(HOME)/workspace/elgentos/example/pub/index.php

magebox: | $(MAGEBOX)

install:: | magebox
