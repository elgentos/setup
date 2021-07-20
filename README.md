# elgentos setup

This repository can be used to bootstrap a fresh workstation.

Current supported operating systems:

- Ubuntu 20.04 (x86_64)

# Installation

[![Install](https://github.com/elgentos/setup/workflows/Install/badge.svg)](https://github.com/elgentos/setup/actions?query=workflow%3A%22Install%22)

```
wget -qO- https://raw.githubusercontent.com/elgentos/setup/main/install | bash
```

Or, if `wget` is not available, simply download
[the installer](https://raw.githubusercontent.com/elgentos/setup/main/install)
to run it directly:

```
bash install
```

## Result

The following files have been created in the home directory:

- [`.gitconfig`](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration)
- [`.gitconfig-user`](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration)
- [`.gitignore`](https://git-scm.com/docs/gitignore)
- [`.zshrc`](http://zsh.sourceforge.net/Doc/Release/Files.html#Files)

The following software has been installed:

- [AWS CLI](https://gist.github.com/JeroenBoersma/87e29fd4aa06ec42216c80a6e3649fa5) w/💘
- [Bash](https://www.gnu.org/software/bash/)
- [Composer](https://getcomposer.org/)
- [cURL](https://curl.haxx.se/)
- [Docker](https://www.docker.com/)
- [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)
- [Docker compose](https://docs.docker.com/compose/)
- [Docker compose development](https://github.com/JeroenBoersma/docker-compose-development)
- [GIT](https://git-scm.com/)
- [JetBrains Toolbox](https://www.jetbrains.com/toolbox-app/)
- [jq](https://stedolan.github.io/jq/)
- [lsb_release](https://refspecs.linuxfoundation.org/LSB_3.0.0/LSB-PDA/LSB-PDA/lsbrelease.html)
- [`node`, `npm`, `nvm`](https://nodejs.org/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Slack](https://slack.com/)
- [Vim](https://www.vim.org/)
- [ZSH](https://www.zsh.org/)

# Optional

To cherry-pick optional software, use the following targets:

## Cloud management

- [gcloud](https://cloud.google.com/sdk/gcloud/)

## Web browsers

- [brave](https://brave.com/)
- [firefox](https://www.mozilla.org/en-US/firefox/)
- [google-chrome](https://www.google.com/chrome/)

## Productivity

- [`gimp`](https://www.gimp.org/)

## Tools

- [`ag`](https://github.com/ggreer/the_silver_searcher)
- [`composer-changelogs`](https://packagist.org/packages/pyrech/composer-changelogs)
- [`composer-lock-diff`](https://packagist.org/packages/davidrjonas/composer-lock-diff)
- [`multitail`](https://linux.die.net/man/1/multitail)
- [`ssg`](https://github.com/elgentos/ssg-js) (SSH GUI)
- [`symlinks`](https://tracker.debian.org/pkg/symlinks)
- [`tmux`](https://tracker.debian.org/pkg/tmux)
- [`tmuxinator`](https://tracker.debian.org/pkg/tmuxinator)
- [`tmuxinator_completion`](https://github.com/tmuxinator/tmuxinator/tree/master/completion)

## Example

The following adds `gimp`, `symlinks` and `ssg` to the installation.

```
./install gimp symlinks ssg
```

# Development

In order to locally test a Make target, run the following:

```
./docker-make <TARGET>
```

Where `<TARGET>` is the target to be tested. E.g.: `gimp` for Gimp.

To test all installations, run:

```
./docker-make all
```

To specify the Docker image that runs the build, provide the `IMAGE` environment
variable. It defaults to `ubuntu:20.04`.

```
IMAGE=ubuntu:20.10 ./docker-make all
```

## Run GitHub actions locally

Using [act](https://github.com/nektos/act), GitHub actions can be tested locally
without having to push them to an existing branch.

```
make act
```

Because the file `.actrc` is preconfigured, simply run:

```
act
```
