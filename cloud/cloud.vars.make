AWS := $(shell command -v aws || echo /usr/local/bin/aws)
GCLOUD := $(shell command -v gcloud || echo /usr/bin/gcloud)
GCLOUD_CONFIG := $(shell echo "$$HOME/.config/gcloud")
