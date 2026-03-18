# Setup Project

Workstation bootstrapping repo for elgentos. Two installation paths:
- `autoinstall.yaml` — Ubuntu Server autoinstall (full OS provisioning, partitioning, late-commands)
- `Makefile` system (`install` script + `*.make` files) — post-install software setup on an existing OS

The Makefile system uses `*.vars.make` for variables and `*.make` for targets, organized by category (shell, editor, tool, etc.).

## Python

Before running Python scripts (e.g. `autoinstall-validate.py`), activate the virtual environment:

```
source .venv/bin/activate
```
