{
  inputs = {
    pkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };
  outputs = { self, pkgs, vscode-server, ... }:
    let
      system = "x86_64-linux";

      hardware = ./hardware-configuration.nix;
    in
    {
      #devShells.${system} = {
      #impure = pkgs.mkShell {
      #packages = with pkgs; [
      #python312
      #uv
      #];
      #env =
      #{
      ## Prevent uv from managing Python downloads
      #UV_PYTHON_DOWNLOADS = "never";
      ## Force uv to use nixpkgs Python interpreter
      #UV_PYTHON = pkgs.python312.interpreter;
      #}
      #// pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
      ## Python libraries often load native shared objects using dlopen(3).
      ## Setting LD_LIBRARY_PATH makes the dynamic library loader aware of libraries without using RPATH for lookup.
      #LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
      #};
      #shellHook = ''
      #unset PYTHONPATH
      #'';
      #};
      #};
      nixosConfigurations = {
        userland = pkgs.lib.nixosSystem {
          modules = [
            hardware
            ./userland.nix
          ];
          inherit system;
        };
        backend = pkgs.lib.nixosSystem {
          modules = [
            hardware
            ./backend.nix

            vscode-server.nixosModules.default
            ({ pkgs, ... }: {
              services.vscode-server.enable = true;
            })
          ];
          inherit system;
        };
      };
    };

  description = "Remember the DISSSSS ?";
}
