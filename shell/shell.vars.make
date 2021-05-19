BASH := $(shell command -v bash || echo /bin/bash)
ZSH := $(shell command -v zsh || echo /usr/bin/zsh)
ZSHRC := $(shell echo "$$HOME/.zshrc")
OH_MY_ZSH := $(shell echo "$$HOME/.oh-my-zsh/oh-my-zsh.sh")
