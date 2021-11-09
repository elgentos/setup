$(SSH): | $(GIT)

ssh: | $(SSH)

$(SSH_KEY): | $(SSH)
	mkdir -p "$(shell dirname "$(SSH_KEY)")"
	ssh-keygen \
		-t rsa \
		-b 4096 \
		-C $$USER@elgentos.nl \
		-f "$(SSH_KEY)"
	ssh-add "$(SSH_KEY)"
	cat "$(SSH_KEY).pub"

ssh-key: | $(SSH_KEY)

$(SSH_CONFIG_TEMPLATE): | $(GIT) $(SSH_KNOWN_HOSTS)
	$(GIT) clone git@gitlab.elgentos.nl:elgentos/ssg.git $(GITPROJECTS)/ssg || true

$(SSH_CONFIG): | $(SSH) $(SSH_CONFIG_TEMPLATE)
	echo "Include $(SSH_CONFIG_TEMPLATE)" >> $(SSH_CONFIG)
	make ssh-known-hosts

ssh-config: | $(SSH_CONFIG)

$(SSH_KNOWN_HOSTS): | ssh-known-hosts

ssh-known-hosts: | $(SSH) $(GIT)
	@for domain in $(GITDOMAINS) $(shell grep Hostname $(SSH_CONFIG_TEMPLATE) | awk '{print $$2}'); do \
		grep '\.' "$(SSH_KNOWN_HOSTS)" | awk '{print "<"$$1">"}' | sort -u | grep -q "<$$domain>" \
			|| ssh-keyscan "$$domain" 2>/dev/null >> $(SSH_KNOWN_HOSTS); \
	done

install:: | $(SSH_KEY) $(SSH_CONFIG) $(SSH_KNOWN_HOSTS)
