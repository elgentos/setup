NPM := $(shell command -v npm || echo "$$HOME/.nvm/versions/node/v*.*.*/bin/npm")
NODE := $(shell command -v node || echo "$$HOME/.nvm/versions/node/v*.*.*/bin/node")
NVM := $(shell command -v nvm || echo "$$HOME/.nvm/nvm.sh")
