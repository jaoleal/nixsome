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
      # Use the same nixpkgs that provides lib.nixosSystem to avoid mismatches.
      pkgs = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      unstablePkgs = pkgs; # optional alias, since we already use unstable pkgs

    in
    inputs.nixpkgs-unstable.lib.nixosSystem {
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
      ] ++ extraModules;
    };


}
