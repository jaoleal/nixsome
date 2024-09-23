default:
    @just --list

set-build:
    @just set-conf
    @just build

build:
    sudo nixos-rebuild switch

set-conf:
    #!/usr/bin/env bash
    sudo rm -rf /etc/nixos/*
    cp *.nix /etc/nixos/
    cp flake.lock /etc/nixos/

prof-install:
    nix profile install --experimental-features 'nix-command flakes'

set-hman:
    rm -rf ~/.config/home-manager/*
    cp -r home.nix ~/.config/home-manager/
    home-manager switch