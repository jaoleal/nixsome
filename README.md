# JLs NixOs config

Hi! This is my over-engineered NixOs configuration that sustain my daily workflow and some very usefull services.

## Hardware

### Beefy

AMD Ryzen™ 9 5950X
128 RAM
RX 6750 XT 12 VRAM

### Paty

i3-1315u
8 RAM

## Features

This repository includes:

- **Multiple NixOS configurations**: backend, wsl-userland, galaxy-book, and floresta-mini-node
- **CI/CD automation**: Automated testing and flake updates via GitHub Actions
- **Hardened ISO exports**: Generate installation ISOs with security hardening
- **WSL tarball exports**: Package WSL configurations for easy Windows deployment
- **Portable apps**: Run scripts directly from the repository using `nix run`

## Getting Started

### Building Configurations

Build any configuration:
```bash
nix build .#nixosConfigurations.<config-name>.config.system.build.toplevel
```

Available configurations:
- `backend`
- `wsl-userland`
- `galaxy-book`
- `floresta-mini-node`

### Switch to a Configuration

```bash
sudo nixos-rebuild switch --flake .#<config-name>
```

Or using the justfile:
```bash
just up <config-name>
```

## CI/CD Workflows

### Continuous Integration

The repository includes automated CI that runs on every push and pull request:
- **Flake validation**: Ensures the flake structure is correct
- **Configuration builds**: Builds all NixOS configurations to catch errors early
- **Formatting checks**: Validates Nix code formatting

### Automated Updates

A weekly workflow (every Monday) automatically:
- Updates `flake.lock` with the latest input versions
- Opens a pull request with the changes for review

### Dependabot

GitHub Dependabot monitors and updates GitHub Actions versions automatically.

## Hardened ISO Images

Generate hardened installation ISOs for your configurations:

```bash
# Build a hardened ISO
just build-iso backend
just build-iso galaxy-book
just build-iso floresta-mini-node
```

Or directly with Nix:
```bash
nix build .#nixosConfigurations.backend-iso.config.system.build.isoImage
```

The ISOs are built with:
- The base configuration from the corresponding host
- Minimal installation environment
- Security hardening enabled

The resulting ISO will be in `./result/iso/`.

## WSL Tarball Export

Export the `wsl-userland` configuration as a WSL-compatible tarball:

```bash
# Build the WSL tarball
just build-wsl
```

Or directly with Nix:
```bash
nix build .#packages.x86_64-linux.wsl-tarball
```

### Importing into WSL

On Windows, import the tarball:
```powershell
wsl --import NixOS C:\WSL\NixOS .\result\tarball\nixos-wsl-installer.tar.gz
```

## Portable Apps

Run scripts directly from this repository without cloning:

```bash
# Run example script
nix run github:jaoleal/nixsome#example-script

# Or use in a shell
nix shell github:jaoleal/nixsome#example-script
```

See `packages/README.md` for how to add your own portable apps.

## Development

### Using justfile

The repository includes a `justfile` with common tasks:

```bash
# List all available commands
just

# Run CI checks locally
just ci

# Format all Nix files
just fmt

# Update flake inputs
just update

# Build a hardened ISO
just build-iso <target>

# Build WSL tarball
just build-wsl

# Test a configuration in a VM
just try <config-name>
```

### Formatting

Format all Nix files:
```bash
just fmt
# or
nix fmt
```

Check formatting without making changes:
```bash
nix fmt -- --check .
```

### Local CI Testing

Run the same checks as CI locally:
```bash
just ci
```

This will:
1. Run `nix flake check`
2. Build all configurations
3. Check code formatting

## Project Structure

```
.
├── .github/
│   ├── workflows/      # GitHub Actions CI/CD workflows
│   └── dependabot.yml  # Dependabot configuration
├── containers/         # Container configurations
├── hardware-config/    # Hardware-specific configurations
├── packages/          # Portable apps and scripts
├── secrets/           # Encrypted secrets (SOPS)
├── src/
│   ├── backend/       # Backend server configuration
│   ├── wsl-userland/  # WSL configuration
│   ├── galaxy-book/   # Galaxy Book laptop configuration
│   ├── floresta-mini-node/ # Floresta Bitcoin node configuration
│   ├── users/         # User configurations
│   ├── builder.nix    # NixOS builder function
│   ├── iso-builder.nix # ISO builder function
│   └── default.nix    # Main source exports
├── flake.nix          # Flake configuration
├── flake.lock         # Locked flake inputs
├── justfile           # Task runner configuration
└── README.md          # This file
```

## Contributing

1. Make your changes
2. Run `just fmt` to format code
3. Run `just ci` to verify everything works
4. Submit a pull request

## License

See LICENSE file for details.