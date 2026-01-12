# pixxel-dev-container

Neovim oriented modular dev container framework

# Whats this do?

This is a modular config built on the `nixos/nix` container, that is setup to utilize a "core" baked in set of opinionated packages, plus additional "per container" mounted packages.

The "core" set of packages is baked into the dockerfile itself, and then the extras you mount via something like docker-compose

The template config (located in `./example-project/`) furthermore has some handy prefab volume mounts, namely persisting the nix package store across containers, such that you substantially reduce load times if you re-use packages often (which you assuredly will)

Once you bootstrap up the container, you can connect to it via `docker exec` to get your interactive shell, and perform all your development work inside the container.

Once done with it, you can just delete the container (and the workspace volume if you please) to completely scorched earth wipe away any remnants of it in a single command.

# Whats the point?

At its core, this is an opinionated stack of tools to solve my own personal, very specific challenge.

I work as a contract developer typically, and that means I have a wide variety of client projects with extremely different stacks that I interact with often.

The issue I encounter, which I like to call "sdk pollution", is the fact that during the development lifecycle with a given client I tend to need to install all manner of tools, sdks, languages, servers, yadda yadda.

Months later when I am effectively done on that project, it can be challenging to remember precisely what individual things I need to delete and clean up afterwards to get myself back to square one for the next client.

Docker to the rescue! By containerizing my entire development environment inside of docker, I can just nuke the container once I'm done with it to wipe everything away!

But manually maintaining Dockerfiles is a huge pain, and if I want a modular setup where each "module" is cached individually, then it's not enough.

This is where nix comes into play, its a powerful suite of tools as a package manager ecosystem meant to enable me to declare re-usable, composable, modular files that define an entire development environment. That way even if I nuke a container for SomeClient, if months later I need to do more work for them, I can just re-use that config file (as long as I dont delete *that*! Those files are quite small so you should definitely keep them around) to stand my environment right back up again the same as before.

# Installing

1. Clone the repository:
```bash
git clone --recurse-submodules https://github.com/SteffenBlake/pixxel-dev-container.git
cd pixxel-dev-container
```

2. Update submodules (required for Neovim configuration):
```bash
git submodule update --init --recursive
```

3. Run the installer to ensure all prerequisites are installed and the dev container image is built:
```bash
./install.sh
```

# Creating a New Project

1. Copy the example template directory:
```bash
cp -r example-project ~/dev-containers/my-project
```

2. Replace all instances of `workspace-example` in `docker-compose.yml` and volume names with your project name.

3. Edit `flake.nix` to enable or disable features (toggles) you want in your dev container.

# Starting the Dev Container

Start the container:
```bash
docker compose up -d && watch docker ps -a
```

Once the container is healthy, open an interactive shell:
```bash
docker exec -it monogame nix develop /env --impure
```

Your project workspace is mounted inside `/workspace`.

# Preinstalled Tools

**Shell & Terminal**

- `zsh` – The default shell inside the container, chosen for its speed, configurability, and scripting capabilities. Provides a more powerful interactive shell experience than Bash.  

- `oh-my-zsh` – Framework for managing Zsh configuration, with hundreds of themes and plugins. Makes shell customization and productivity enhancements simple.  

- `tmux` – Terminal multiplexer that allows multiple terminal sessions within a single window. Essential for managing long-running tasks and switching between projects without losing state.  

- `tmuxinator` – Tmux session manager that automates workspace setup. Lets you define complex project layouts and restore them with a single command.  

**Editors & Diffing**

- `neovim` – Modern, highly extensible Vim-based editor preconfigured with your Neovim submodule. Provides a fast, terminal-native editing experience with plugins, LSP integration, and advanced text manipulation.  

- `delta` – A syntax-highlighting pager for Git diffs. Makes reviewing code changes easier and more readable than the standard `git diff`.  

**Version Control & Git Helpers**

- `lazygit` – Terminal UI for Git that allows fast navigation of branches, commits, and staging. Chosen for its speed and simplicity compared to raw Git commands.  

- `ripgrep` – Fast search tool for finding text patterns in files. Used for project-wide searches with superior speed compared to `grep`.  

**Utilities**

- `fzf` – Fuzzy finder for the command line. Integrates with Git, file navigation, and shell history to boost productivity.  

- `gum` – CLI utility for creating interactive prompts, menus, and styled outputs. Used in scripts like `install.sh` for friendly user interaction.  

**Containers & Deployment**

- `docker` + `docker-compose` plugin – Provides containerization and orchestration capabilities. Allows you to build, run, and manage isolated dev environments easily within the containerized workflow.  

**SSH & Networking**

- `openssh` – Provides SSH client capabilities for connecting to remote servers and handling SSH keys inside the container. Supports secure development workflows and remote operations.  

# Preinstalled Tools

## Shell & Terminal

### Zsh
The default shell inside the container, chosen for its speed, configurability, and scripting capabilities. Provides a more powerful interactive shell experience than Bash.

### Oh-My-Zsh
Framework for managing Zsh configuration, with hundreds of themes and plugins. Makes shell customization and productivity enhancements simple.

### Tmux
Terminal multiplexer that allows multiple terminal sessions within a single window. Essential for managing long-running tasks and switching between projects without losing state.

### Tmuxinator
Tmux session manager that automates workspace setup. Lets you define complex project layouts and restore them with a single command.

## Editors & Diffing

### Neovim
Modern, highly extensible Vim-based editor preconfigured with your Neovim submodule. Provides a fast, terminal-native editing experience with plugins, LSP integration, and advanced text manipulation.

### Delta
A syntax-highlighting pager for Git diffs. Makes reviewing code changes easier and more readable than the standard `git diff`.

## Version Control & Git Helpers

### Lazygit
Terminal UI for Git that allows fast navigation of branches, commits, and staging. Chosen for its speed and simplicity compared to raw Git commands.

### Ripgrep
Fast search tool for finding text patterns in files. Used for project-wide searches with superior speed compared to `grep`.

## Utilities

### Fzf
Fuzzy finder for the command line. Integrates with Git, file navigation, and shell history to boost productivity.

### Gum
CLI utility for creating interactive prompts, menus, and styled outputs. Used in scripts like `install.sh` for friendly user interaction.

## Containers & Deployment

### Docker + Docker Compose Plugin
Provides containerization and orchestration capabilities. Allows you to build, run, and manage isolated dev environments easily within the containerized workflow.

## SSH & Networking

### OpenSSH
Provides SSH client capabilities for connecting to remote servers and handling SSH keys inside the container. Supports secure development workflows and remote operations.

# Configurable Toggles

**Dotnet SDKs**
- `enableDotnet7`
- `enableDotnet8`
- `enableDotnet9`
- `enableDotnet10`

**Android**
- `enableAndroid33`
- `enableAndroid34`
- `enableAndroid35`
- `enableAndroid36`

**Game Dev**
- `enableMonogame`

**Node.js / Frontend**
- `enableNodeJs20`
- `enableNodeJs22`
- `enableNodeJs24`
- `enableTypescript`
- `enableSvelte`
- `enableVue`
- `enableAngular`
- `enableReact`

**Other Languages / Tools**
- `enableRust`
- `enableHugo`

