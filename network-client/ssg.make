SSG := $(shell command -v ssg || echo /usr/bin/ssg)

$(SSG): | $(GIT) $(NPM) $(NVM) $(BASH) $(SSH_KEY)
	$(GIT) clone git@github.com:elgentos/ssg-js.git $(GITPROJECTS)/ssg-js
	cd $(GITPROJECTS)/ssg-js \
		&& 		$(BASH) -c "source $(NVM) && npm install" \
		&& sudo $(BASH) -c "source $(NVM) && npm install -g ssg-js"

ssg: | $(SSG)

optional:: | ssg
