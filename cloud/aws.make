$(AWS): | $(GIT) $(DOCKER) $(SSH_KEY)
	$(GIT) clone \
		https://gist.github.com/87e29fd4aa06ec42216c80a6e3649fa5.git \
		$(GITPROJECTS)/aws-cli
	chmod +x $(GITPROJECTS)/aws-cli/aws.sh
	sudo ln -s $(GITPROJECTS)/aws-cli/aws.sh $(AWS)
	@echo $(INTERACTIVE) | grep -q '1' && sudo $(AWS) --version || echo -n ''

aws: | $(AWS)

install:: | aws
