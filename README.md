# Workstation setup

This repository can be used to bootstrap a fresh workstation.

Current supported operating systems:

- Ubuntu 20.04 (x86_64)

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

[![Install required](https://github.com/johmanx10/setup/workflows/make%20install/badge.svg)](https://github.com/johmanx10/setup/actions?query=workflow%3A%22make+install%22)

Run the installation.

```
make install
```

## Result

The following files have been symbolically linked from the current repository to
the home directory:

| File                                                                             | Target alias     |
|:---------------------------------------------------------------------------------|:-----------------|
| [`.gitconfig`](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration) | `make gitconfig` |
| [`.gitignore`](https://git-scm.com/docs/gitignore)                               | `make gitignore` |
| [`.zshrc`](http://zsh.sourceforge.net/Doc/Release/Files.html#Files)              | `make zshrc`     |

In addition, the following files have been generated:

| File                                                                                  | Target alias          |
|:--------------------------------------------------------------------------------------|:----------------------|
| [`.gitconfig-user`](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration) | `make gitconfig-user` |

The following software has been installed:

| Name                                                                                          | Target alias             |
|:----------------------------------------------------------------------------------------------|:-------------------------|
| [Bash](https://www.gnu.org/software/bash/)                                                    | `make bash`              |
| [cURL](https://curl.haxx.se/)                                                                 | `make curl`              |
| [Docker](https://www.docker.com/)                                                             | `make docker`            |
| [GIT](https://git-scm.com/)                                                                   | `make git`               |
| [Google Chrome](https://www.google.com/chrome/)                                               | `make google-chrome`     |
| [JetBrains Toolbox](https://www.jetbrains.com/toolbox-app/)                                   | `make jetbrains-toolbox` |
| [jq](https://stedolan.github.io/jq/)                                                          | `make jq`                |
| [lsb_release](https://refspecs.linuxfoundation.org/LSB_3.0.0/LSB-PDA/LSB-PDA/lsbrelease.html) | `make lsb_release`       |
| [Oh My Zsh](https://ohmyz.sh/)                                                                | `make oh-my-zsh`         |
| [Vim](https://www.vim.org/)                                                                   | `make vim`               |
| [ZSH](https://www.zsh.org/)                                                                   | `make zsh`               |

# Optional

[![make optional](https://github.com/johmanx10/setup/workflows/make%20optional/badge.svg)](https://github.com/johmanx10/setup/actions?query=workflow%3A%22make+optional%22)

All the following software can be installed at-once using:

```
make optional
```

To cherry-pick optional software, use the following phony targets:

| Name                                                                                      | Target                            | Build status |
|:------------------------------------------------------------------------------------------|:----------------------------------|:-------------|
| [Discord](https://discord.com/)                                                           | `make discord`                    | [![make discord](https://github.com/johmanx10/setup/workflows/make%20discord/badge.svg)](https://github.com/johmanx10/setup/actions?query=workflow%3A%22make+discord%22) |
| [Docker compose](https://docs.docker.com/compose/)                                        | `make docker-compose`             | [![make docker-compose](https://github.com/johmanx10/setup/workflows/make%20docker-compose/badge.svg)](https://github.com/johmanx10/setup/actions?query=workflow%3A%22make+docker-compose%22) |
| [Docker compose development](https://github.com/JeroenBoersma/docker-compose-development) | `make docker-compose-development` | [![make docker-compose-development](https://github.com/johmanx10/setup/workflows/make%20docker-compose-development/badge.svg)](https://github.com/johmanx10/setup/actions?query=workflow%3A%22make+docker-compose-development%22) |
| [Epic Games Store](https://www.epicgames.com/store/en-US/)                                | `make epic-games-store`           | Will be added once [Lutris supports unattended installations](https://github.com/lutris/lutris/pull/3029). |
| [GIMP](https://www.gimp.org/)                                                             | `make gimp`                       | [![make gimp](https://github.com/johmanx10/setup/workflows/make%20gimp/badge.svg)](https://github.com/johmanx10/setup/actions?query=workflow%3A%22make+gimp%22) |
| [Lutris](https://lutris.net/)                                                             | `make lutris`                     | [![make lutris](https://github.com/johmanx10/setup/workflows/make%20lutris/badge.svg)](https://github.com/johmanx10/setup/actions?query=workflow%3A%22make+lutris%22) |
| [RetroArch](https://www.retroarch.com/)                                                   | `make retroarch`                  | [![make retroarch](https://github.com/johmanx10/setup/workflows/make%20retroarch/badge.svg)](https://github.com/johmanx10/setup/actions?query=workflow%3A%22make+retroarch%22) |
| [Slack](https://slack.com/)                                                               | `make slack`                      | [![make slack](https://github.com/johmanx10/setup/workflows/make%20slack/badge.svg)](https://github.com/johmanx10/setup/actions?query=workflow%3A%22make+slack%22) |
| [Steam](https://store.steampowered.com/)                                                  | `make steam`                      | [![make steam](https://github.com/johmanx10/setup/workflows/make%20steam/badge.svg)](https://github.com/johmanx10/setup/actions?query=workflow%3A%22make+steam%22) |
| [Teamviewer](https://www.teamviewer.com/)                                                 | `make teamviewer`                 | [![make teamviewer](https://github.com/johmanx10/setup/workflows/make%20teamviewer/badge.svg)](https://github.com/johmanx10/setup/actions?query=workflow%3A%22make+teamviewer%22) |
| [Transmission Remote GTK](https://linux.die.net/man/1/transmission-remote)                | `make transmission-remote`        | [![make transmission-remote](https://github.com/johmanx10/setup/workflows/make%20transmission-remote/badge.svg)](https://github.com/johmanx10/setup/actions?query=workflow%3A%22make+transmission-remote%22) |

# Development

[![docker-make vim](https://github.com/johmanx10/setup/workflows/docker-make%20vim/badge.svg)](https://github.com/johmanx10/setup/actions?query=workflow%3A%22docker-make+vim%22)

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
