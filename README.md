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

| File              | Target alias          |
|:------------------|:----------------------|
| `.gitconfig`      | `make gitconfig`      |
| `.gitconfig-user` | `make gitconfig-user` |
| `.gitignore`      | `make gitignore`      |
| `.zshrc`          | `make zshrc`          |

The following software has been installed:

| Name              | Target alias             |
|:------------------|:-------------------------|
| Bash              | `make bash`              |
| cURL              | `make curl`              |
| Docker            | `make docker`            |
| GIT               | `make git`               |
| Google Chrome     | `make google-chrome`     |
| JetBrains Toolbox | `make jetbrains-toolbox` |
| jq                | `make jq`                |
| lsb_release       | `make lsb_release`       |
| Oh My ZSH         | `make oh-my-zsh`         |
| Vim               | `make vim`               |
| ZSH               | `make zsh`               |

# Optional

![make optional](https://github.com/johmanx10/setup/workflows/make%20optional/badge.svg)

All the following software can be installed at-once using:

```
make optional
```

To cherry-pick optional software, use the following phony targets:

| Name                    | Target                     | Build status |
|:------------------------|:---------------------------|:-------------|
| Discord                 | `make discord`             | ![make discord](https://github.com/johmanx10/setup/workflows/make%20discord/badge.svg) |
| GIMP                    | `make gimp`                | ![make gimp](https://github.com/johmanx10/setup/workflows/make%20gimp/badge.svg) |
| Lutris                  | `make lutris`              | ![make lutris](https://github.com/johmanx10/setup/workflows/make%20lutris/badge.svg) |
| Slack                   | `make slack`               | ![make steam](https://github.com/johmanx10/setup/workflows/make%20slack/badge.svg) |
| Steam                   | `make steam`               | ![make steam](https://github.com/johmanx10/setup/workflows/make%20steam/badge.svg) |
| Transmission Remote GTK | `make transmission-remote` | ![make transmission-remote](https://github.com/johmanx10/setup/workflows/make%20transmission-remote/badge.svg) |

# Development

![docker-make vim](https://github.com/johmanx10/setup/workflows/docker-make%20vim/badge.svg)

In order to locally test a Make target, run the following:

```
./docker-make <TARGET>
```

Where `<TARGET>` is the target to be tested. E.g.: `steam` for Steam.

To test all installations, run:

```
./docker-make all
```

To specify the Docker image that runs the build, provide the `IMAGE` environment
variable. It defaults to `ubuntu:20.04`.

```
IMAGE=ubuntu:18.04 ./docker-make all
```
