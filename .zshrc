export ZSH="$HOME/.oh-my-zsh"

plugins=(
	composer
	docker
	docker-compose
	dotenv
	git
	gitignore
	golang
	kubectl
	ubuntu
	ufw
)

# Make all GIT repos into named directories.
for repo in ~/git/*; do hash -d "$(basename "$repo")=$repo"; done

# Make all workspaces into named directories.
[ -d ~/development/workspace ] && for workspace in ~/development/workspace/*; do
    hash -d "$(basename "$workspace")=$workspace";
done

source $ZSH/oh-my-zsh.sh

# Profile generated for docker-compose-development.
[ -f "$HOME/.zshrc-development" ] && source "$HOME/.zshrc-development"
