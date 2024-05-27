# dotfiles

This repo is heavily influenced by [TechDufus](https://github.com/TechDufus/dotfiles)'s repo. Go check it out!


## Requirements

### Operating System

This Ansible playbook only supports `MacOS (Darwin)` distribution. This is by design to provide a consistent development experience across hosts.


## Usage

### Install

This playbook includes a custom shell script located at `bin/dotfiles`. This script is added to your $PATH after installation and can be run multiple times while making sure any Ansible dependencies are installed and updated.

<!-- This shell script is also used to initialize your environment after installing `Ubuntu|Arch` and performing a full system upgrade as mentioned above. -->

> NOTE: You must follow required steps before running this command or things may become unusable until fixed.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/matthiashamacher/dotfiles/main/bin/dotfiles)"
```

If you want to run only a specific role, you can specify the following bash command:
```bash
curl -fsSL https://raw.githubusercontent.com/TechDufus/matthiashamacher/main/bin/dotfiles | bash -s -- --tags comma,seperated,tags
```

### Update

This repository is continuously updated with new features and settings which become available to you when updating.

To update your environment run the `dotfiles` command in your shell:

```bash
dotfiles
```

This will handle the following tasks:

- Verify Ansible is up-to-date
<!-- - Generate SSH keys and add to `~/.ssh/authorized_keys` -->
- Clone this repository locally to `~/.dotfiles`
- Verify any `ansible-galaxy` plugins are updated
- Run this playbook with the values in `~/.config/dotfiles/group_vars/all.yaml`

This `dotfiles` command is available to you after the first use of this repo, as it adds this repo's `bin` directory to your path, allowing you to call `dotfiles` from anywhere.

Any flags or arguments you pass to the `dotfiles` command are passed as-is to the `ansible-playbook` command.

For Example: Running the tmux tag with verbosity
```bash
dotfiles -t tmux -vvv
```