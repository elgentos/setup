$(SSG): | $(GIT) $(NPM) $(NVM) $(BASH) $(SSH_KEY)
	rm -rf $(GITPROJECTS)/ssg-js
	$(GIT) clone https://github.com/elgentos/ssg-js.git $(GITPROJECTS)/ssg-js
	cd $(GITPROJECTS)/ssg-js \
		&& 		$(BASH) -c "source $(NVM) && $(NPM) install" \
		&& sudo $(BASH) -c "source $(NVM) && $(NPM) install -g ssg-js"
	mkdir -p "$(shell dirname "$(SSG)")"
	sudo ln -s "$$($(BASH) -c "source $(NVM) && command -v ssg")" "$(SSG)"

ssg: | $(SSG)

optional:: | ssg
