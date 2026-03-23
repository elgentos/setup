# elgentos setup

This repository can be used to bootstrap a fresh workstation.

Current supported operating systems:

- Ubuntu 24.04 LTS (x86_64)

## Installation

There are two installation paths:

### Autoinstall (full OS install)

The `autoinstall.yaml` file can be used with Ubuntu Server's autoinstall to provision a workstation from scratch. It handles partitioning, package installation, and late-commands that install additional software.

After each change in this file, you should validate it!

To validate the autoinstall config:

```
source .venv/bin/activate
python3 autoinstall-validate.py
```

### Post-install (existing OS)

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

## What gets installed

### Via autoinstall (late-commands)

- [1Password](https://1password.com/)
- [Backblaze B2 CLI](https://www.backblaze.com/docs/cloud-storage-command-line-tools)
- [Brave](https://brave.com/)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- [Docker](https://www.docker.com/) + [Docker Compose](https://docs.docker.com/compose/)
- [Homebrew](https://brew.sh/)
- [MageBox](https://magebox.dev)
- [nvm](https://github.com/nvm-sh/nvm)
- [Oh My Zsh](https://ohmyz.sh/)
- [Warp](https://www.warp.dev/)

### Via Makefile

- [Bash](https://www.gnu.org/software/bash/)
- [Composer](https://getcomposer.org/)
- [cURL](https://curl.haxx.se/)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [GIT](https://git-scm.com/)
- [JetBrains Toolbox](https://www.jetbrains.com/toolbox-app/)
- [jq](https://stedolan.github.io/jq/)
- [lsb_release](https://refspecs.linuxfoundation.org/LSB_3.0.0/LSB-PDA/LSB-PDA/lsbrelease.html)
- [`node`, `npm`, `nvm`](https://nodejs.org/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Slack](https://slack.com/)
- [Vim](https://www.vim.org/)
- [ZSH](https://www.zsh.org/)

### Snaps (via autoinstall)

- Chromium, Discord, gcolor3, Postman, PHPStorm, Spotify, SQLite Browser, Steam, Slack

## Optional

To cherry-pick optional software, use the following targets:

### Web browsers

- [brave](https://brave.com/)
- [firefox](https://www.mozilla.org/en-US/firefox/)
- [google-chrome](https://www.google.com/chrome/)

### Productivity

- [`gimp`](https://www.gimp.org/)

### Tools

- [`ag`](https://github.com/ggreer/the_silver_searcher)
- [`composer-changelogs`](https://packagist.org/packages/pyrech/composer-changelogs)
- [`composer-lock-diff`](https://packagist.org/packages/davidrjonas/composer-lock-diff)
- [`multitail`](https://linux.die.net/man/1/multitail)
- [`ssg`](https://github.com/elgentos/ssg-js) (SSH GUI)
- [`symlinks`](https://tracker.debian.org/pkg/symlinks)
- [`tmux`](https://tracker.debian.org/pkg/tmux)
- [`tmuxinator`](https://tracker.debian.org/pkg/tmuxinator)
- [`tmuxinator_completion`](https://github.com/tmuxinator/tmuxinator/tree/master/completion)

### Networking

- [`dnsmasq`](http://www.thekelleys.org.uk/dnsmasq/doc.html)

### Example

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
variable. It defaults to `ubuntu:24.04`.

```
IMAGE=ubuntu:24.04 ./docker-make all
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
