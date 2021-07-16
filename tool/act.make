$(ACT): | $(BASH) $(CURL) .ssh/id_rsa
	$(CURL) -sf https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo $(BASH)

act: | $(ACT)

.ssh/id_rsa: | $(SSH_KEY)
	@mkdir -p "$(shell dirname "$@")"
	@for prerequisite in $|; do cp $$prerequisite $@; done

clean::
	@rm -rf .ssh
