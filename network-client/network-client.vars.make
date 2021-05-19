SSG := $(shell command -v ssg || echo /usr/bin/ssg)
SSH := $(shell command -v ssh || /usr/bin/ssh)
SSH_KEY := $(shell echo "$$HOME/.ssh/id_rsa")
