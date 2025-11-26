# pixxel-dev-container
Neovim oriented moduler dev container framework

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

Step 1: Checkout a copy of this repo on any debian oriented distro

Step 2: run `install.sh` in order to ensure all installed requirements are ready, as well as to build the dockerfile

Step 3: Make a clone of the `./example-project/` template directory to wherever you please

Step 4: Edit the `flake.nix` flags as needed to enabled/disable features to be included in your container

Step 5: Edit the docker-compose.yml file, fixing the following fields:

```
services:
  dev:
    ...
    container_name: example-project
    environment:
      # https://github.com/ohmyzsh/ohmyzsh/wiki/themes
      ZSH_THEME: "jonathan" <<< Feel free to modify this as you wish
    volumes:
      ...
      - workspace-example-project:/workspace << Update the volume name to match what you set below
      ...

volumes:
  ...
  workspace-example-project: << Change this volume name to be unique as well
```

For example if my project Im working on was called something like FakeCompany's FakeApp I'd do something like

```
services:
  dev:
    image: pixxel-dev-container
    container_name: fake-company-fake-app
    tty: true
    stdin_open: true
    environment:
      # https://github.com/ohmyzsh/ohmyzsh/wiki/themes
      ZSH_THEME: "jonathan"
    volumes:
      - nix-store:/nix
      - workspace-fake-company-fake-app:/workspace
      - ./flake.nix:/env/flake.nix:ro

volumes:
  nix-store:
  workspace-fake-company-fake-app:
```
 
Step 6: `docker compose up -d` to start the container up. Once it has a status of "healthy" then...

Step 7: Use `docker exec -it <your-containers-name> zsh` to open up an interactive shell and you should be good to go!

Example, based on the above example config: `docker exec -it fake-company-fake-app zsh`

# Core Packages

## Neovim
This is the backbone of this stack, I use neovim heavily as my preferred IDE for all work. One challenge I have faced is the fact that over time, as I adapt my neovim config to handle a wider and wider set of LSPs, languages, configs, projects, etc, it also becomes polluted with way too many plugins to be loaded in at once. This makes stuff like updates, load times, etc, start to get bogged down.

Since the whole point of using neovim in the first place was to leverage its blinding speed, I wanted to couple its own configuration steps up to the nix config (primarily by leveraging env variables)

The end result is this: If my nix config only has, say, the Rust + NPM modules enabled, I really only should be installing, configuring, and loading the same matching plugins in neovim and ignoring the rest. This heavily optimizes my neovim load times and greatly reduces things like install/update speed, as well as reduces memory usage a little bit too.

## tmux + tmuxinator
This is by far my favorite multiplexer for any distro. Tmux is heavily configurable, plays very nice keybind-wise with stuff like neovim, and allows me the ability to leverage tools like `tmuxinator` to setup a quick "jump right in" preset of "tabs" for a project

## fzf
This is possibly one of my most used CLI tools, the absolute beast of utility this stuff provides is unprecedented. If you havent gotten used to it, just try out stuff like `some-tool --help | fzf` as a way to make browsing the help docs of a tool you use WAY easier. No longer is it a huge pain to figure out the exact right flags you need to use for `tar`!

## lazygit

This is hands down my preferred git TUI, it's just incredibly user friendly and overall feels really good to use. I love this tool and I recommend it to anyone who cares!
