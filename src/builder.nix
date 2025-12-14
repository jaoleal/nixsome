{ ... }:
{
  buildNixos =
    {
      hostname,
      username,
      inputs,
      system ? "x86_64-linux",
      stateVersion ? "24.05",
      extraModules ? [ ],
    }:
    let

      pkgs = import inputs.nixpkgs {
        inherit system;

        config.allowUnfree = true;
      };

      unstablePkgs = import inputs.nixpkgs-unstable {
        inherit system;

        config.allowUnfree = true;
      };
      #intraNetworkModule = import ./intra-network.nix;

    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          pkgs
          unstablePkgs
          inputs
          system
          hostname
          username
          stateVersion
          ;
      };
      modules = [
        ./${hostname}
        ./users/${username}.nix

        # intraNetworkModule
      ]
      ++ extraModules;
    };

}
