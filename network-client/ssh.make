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

install:: | $(SSH_KEY)
