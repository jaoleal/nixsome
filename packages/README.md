# Portable Apps and Scripts

This directory contains portable applications and scripts that can be run via:
- `nix run github:jaoleal/nixsome#<app-name>`
- `nix shell github:jaoleal/nixsome#<app-name>`

## Available Apps

### example-script
A simple example script demonstrating the pattern for adding new portable apps.

Usage:
```bash
nix run github:jaoleal/nixsome#example-script
```

## Adding New Apps

To add a new app:

1. Define the package in `flake.nix` under `packages.${system}`:
```nix
my-app = pkgs.writeShellApplication {
  name = "my-app";
  runtimeInputs = [ pkgs.curl pkgs.jq ];
  text = ''
    # Your script here
  '';
};
```

2. Add the app entry in `flake.nix` under `apps.${system}`:
```nix
my-app = {
  type = "app";
  program = "${self.packages.${system}.my-app}/bin/my-app";
};
```

3. Test locally:
```bash
nix run .#my-app
```
