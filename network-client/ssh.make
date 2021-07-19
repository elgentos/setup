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

$(SSH_CONFIG): | $(SSH) $(GIT)
	$(GIT) clone git@gitlab.elgentos.nl:elgentos/ssg.git $(GITPROJECTS)/ssg
	echo "Include $(GITPROJECTS)/ssg/ssh/config" >> $(SSH_CONFIG)
	for domain in $(shell grep Hostname $(GITPROJECTS)/ssg/ssh/config | awk '{print $$2}'); do \
  		echo "Adding known host: $$domain"; \
		ssh-keyscan "$$domain" >> $(SSH_KNOWN_HOSTS); \
	done

ssh-config: | $(SSH_CONFIG)

install:: | $(SSH_KEY) $(SSH_CONFIG)
