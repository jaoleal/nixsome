default:
    @just --list

set-build-desk:
    @just set-conf
    sudo nixos-rebuild switch --flake /etc/nixos/#desktop

set-build-note:
    @just set-conf
    sudo nixos-rebuild switch --flake /etc/nixos/#notebook

set-conf:
    #!/usr/bin/env bash
    sudo cp /etc/nixos/hardware-configuration.nix .
    sudo rm -rf /etc/nixos/*
    sudo cp *.nix /etc/nixos/
    sudo cp flake.lock /etc/nixos/

prof-install:
    nix profile install --experimental-features 'nix-command flakes'

set-hman:
    rm -rf ~/.config/home-manager/*
    cp -r home.nix ~/.config/home-manager/
    home-manager switch
