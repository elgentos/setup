# Workstation setup

This repository can be used to bootstrap a fresh workstation.

Current supported operating systems:

- Ubuntu 20.04

# Prerequisites

Ensure essential software has been installed.

```
apt install git build-essential sudo -y
```

Or, if you are not running as a super user, assuming `sudo` is available.

```
sudo apt install git build-essential -y
```

Add an SSH key to the list of
[allowed Github keys](https://github.com/settings/keys).

```
ssh-keygen -t rsa -C github@johmanx.com
cat ~/.ssh/id_rsa.pub
```

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

# Install

![Install required](https://github.com/johmanx10/setup/workflows/make%20install/badge.svg)

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
- Google Chrome
- JetBrains Toolbox
- jq
- OhMyZsh
- Vim
- ZSH

# Optional

![make optional](https://github.com/johmanx10/setup/workflows/make%20optional/badge.svg)

All the following software can be installed at-once using:

```
make optional
```

To cherry-pick optional software, use the following phony targets:

| Name                    | Target                     | Build status |
|:------------------------|:---------------------------|:-------------|
| GIMP                    | `make gimp`                | ![make gimp](https://github.com/johmanx10/setup/workflows/make%20gimp/badge.svg) |
| Steam                   | `make steam`               | ![make steam](https://github.com/johmanx10/setup/workflows/make%20steam/badge.svg) |
| Transmission Remote GTK | `make transmission-remote` | ![make transmission-remote](https://github.com/johmanx10/setup/workflows/make%20transmission-remote/badge.svg) |

# Development

In order to locally test a Make target, run the following:

```
docker run --rm -it -v $PWD:/setup -w /setup ubuntu:20.04 bash
apt update -y
apt install -y build-essential sudo
make <TARGET>
```

Where `<TARGET>` is the target to be tested. E.g.: `steam` for Steam.

To test all installations, choose `all` as target.