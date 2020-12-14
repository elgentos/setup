# elgentos setup

This repository can be used to bootstrap a fresh workstation.

Current supported operating systems:

- Ubuntu 20.04 (x86_64)

# Installation

[![make install](https://github.com/elgentos/setup/workflows/make%20install/badge.svg)](https://github.com/elgentos/setup/actions?query=workflow%3A%22make+install%22)


Run the following:

```
source <(curl -sf https://raw.githubusercontent.com/elgentos/setup/main/install)
```

Or, if `curl` is not available, simply download
[the installer](https://raw.githubusercontent.com/elgentos/setup/main/install)
to run it directly:

```
./install
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
- [cURL](https://curl.haxx.se/)
- [Docker](https://www.docker.com/)
- [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)
- [Docker compose](https://docs.docker.com/compose/)
- [Docker compose development](https://github.com/JeroenBoersma/docker-compose-development)
- [GIT](https://git-scm.com/)
- [JetBrains Toolbox](https://www.jetbrains.com/toolbox-app/)
- [jq](https://stedolan.github.io/jq/)
- [lsb_release](https://refspecs.linuxfoundation.org/LSB_3.0.0/LSB-PDA/LSB-PDA/lsbrelease.html)
- [Oh My Zsh](https://ohmyz.sh/)
- [Slack](https://slack.com/)
- [Vim](https://www.vim.org/)
- [ZSH](https://www.zsh.org/)

# Optional

[![make optional](https://github.com/elgentos/setup/workflows/make%20optional/badge.svg)](https://github.com/elgentos/setup/actions?query=workflow%3A%22make+optional%22)

To cherry-pick optional software, use the following targets:

## Web browsers

- [brave](https://brave.com/)
- [firefox](https://www.mozilla.org/en-US/firefox/)
- [google-chrome](https://www.google.com/chrome/)

## Productivity

- [`gimp`](https://www.gimp.org/)

## Tools

- [`ssg`](https://github.com/elgentos/ssg-js) (SSH GUI)
- [`symlinks`](https://tracker.debian.org/pkg/symlinks)
- [`tmux`](https://tracker.debian.org/pkg/tmux)
- [`tmuxinator`](https://tracker.debian.org/pkg/tmuxinator)
- [`tmuxinator_completion`](https://github.com/tmuxinator/tmuxinator/tree/master/completion)

## Web development

- [`node`, `npm`, `nvm`](https://nodejs.org/)

## Example

The following adds `gimp`, `symlinks` and `ssg` to the installation.

```
./install gimp symlinks ssg
```

# Development

[![docker-make vim](https://github.com/elgentos/setup/workflows/docker-make%20vim/badge.svg)](https://github.com/elgentos/setup/actions?query=workflow%3A%22docker-make+vim%22)

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
