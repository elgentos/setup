# Workstation setup

This repository can be used to bootstrap a fresh workstation.

# Prerequisites

Ensure the `git` client has been installed.

```
apt install git -y
```

Add an SSH key to the list of
[allowed Github keys](https://github.com/settings/keys).

```
ssh-keygen -t rsa -C github@johmanx.com
cat ~/.ssh/id_rsa.pub
```

# Installation

Create the `git` directory.

```
mkdir -p ~/git
```

Clone the current repository in that directory.

```
cd ~/git && git clone git@github.com:johmanx10/setup.git
```

Navigate into the setup directory.

```
cd ~/git/setup
```

Run the installation.

```
make install
```

## Result

The following files have been symbolically linked from the current repository to
the home directory:

- `.gitconfig`
- `.gitignore`
- `.zshrc`

The following software has been installed:

- Bash
- cURL
- Docker
- GIT
- JetBrains Toolbox
- jq
- OhMyZsh
- ZSH