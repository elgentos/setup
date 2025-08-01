JETBRAINS_TOOLBOX_DIR := "$$HOME/.local/share/JetBrains/Toolbox/"
JETBRAINS_TOOLBOX := $(shell command -v jetbrains-toolbox || echo /usr/local/bin/jetbrains-toolbox)
JETBRAINS_TOOLBOX_SETTINGS := $(shell echo "$$HOME/.local/share/JetBrains/Toolbox/.settings.json")
