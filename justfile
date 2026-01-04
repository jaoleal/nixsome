default:
    @just --list

# Run CI checks locally
ci:
    @echo "Running CI checks..."
    nix flake check
    @echo "Building all configurations..."
    nix build .#nixosConfigurations.backend.config.system.build.toplevel
    nix build .#nixosConfigurations.wsl-userland.config.system.build.toplevel
    nix build .#nixosConfigurations.galaxy-book.config.system.build.toplevel
    nix build .#nixosConfigurations.floresta-mini-node.config.system.build.toplevel
    @echo "Checking formatting..."
    nix fmt -- --check .

# Format all Nix files
fmt:
    nix fmt

# Update flake.lock
update:
    nix flake update

# Build hardened ISO for a target (backend, galaxy-book, or floresta-mini-node)
build-iso target:
    nix build .#nixosConfigurations.{{ target }}-iso.config.system.build.isoImage

# Build WSL tarball
build-wsl:
    nix build .#packages.x86_64-linux.wsl-tarball

# Set the last home-manager generation to active.
set-hman:
    @just _set-homeconf
    home-manager switch

# Make a nixos switch on target
up target:
    sudo nixos-rebuild switch --flake .#{{ target }}

# Executes check on target
check target:
    @just _set-sysconf
    nix flake check /etc/nixos#{{ target }}

zed path=".":
    nix-shell -p zed-editor --run "zeditor {{ path }}"

# Build and run a vm
try target:
    nixos-rebuild build-vm --flake .#{{ target }}
    ./result/bin/run-{{ target }}-vm

# Allows /etc/nixos to jaoleal... Once in a life of a partition.
allow:
    sudo chown jaoleal /etc/nixos

# Move some files around to make nixos satisfied.
_set-sysconf:
    #!/usr/bin/env bash
    rm -rf /etc/nixos/*
    cp -r ./src /etc/nixos/
    cp -r containers/ /etc/nixos/
    cp .sops.yaml /etc/nixos/
    cp -r secrets/ /etc/nixos/
    cp -r hardware-config/ /etc/nixos/
    cp flake.nix /etc/nixos/
    cp flake.lock /etc/nixos/

# Move some files around to make home-manager satisfied.
_set-homeconf:
    #!/usr/bin/env bash
    rm -rf ~/.config/home-manager
    mkdir -p ~/.config/home-manager
    cp -r ./src/home.nix ~/.config/home-manager/

