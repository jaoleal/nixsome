default:
    @just --list

# Set the last home-manager generation to active.
set-hman:
    @just _set-homeconf
    home-manager switch

# Make a nixos switch on target
up target:
    @just _set-sysconf
    sudo nixos-rebuild switch --flake /etc/nixos/#{{target}} --impure

# Executes check on target
check target:
    @just _set-sysconf
    nix flake check /etc/nixos#{{target}}

# Build and run a vm
try target:
    nixos-rebuild build-vm --flake .#{{target}}
    ./result/bin/run-{{target}}-vm

# Allows /etc/nixos to jaoleal... Once in a life of a partition.
allow:
    sudo chown jaoleal /etc/nixos

# Move some files around to make nixos satisfied.
_set-sysconf:
    #!/usr/bin/env bash
    cp /etc/nixos/src/hardware-configuration.nix ./src/hardware-config/hardware-configuration.nix
    rm -rf /etc/nixos/*
    cp -r ./src /etc/nixos/
    cp -r hardware-config/ /etc/nixos/
    cp flake.nix /etc/nixos/
    cp flake.lock /etc/nixos/

# Move some files around to make home-manager satisfied.
_set-homeconf:
    #!/usr/bin/env bash
    rm -rf ~/.config/home-manager
    mkdir -p ~/.config/home-manager
    cp -r ./src/home.nix ~/.config/home-manager/
