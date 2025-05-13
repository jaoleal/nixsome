
{ ... }:
{
  buildNixos =
    {
      hostname,
      username,
      inputs,
      userland ? true,
      system ? "x86_64-linux",
      stateVersion ? "24.05",
      extraModules ? [ ],
    }:
    let
          pkgs = import inputs.nixpkgs {
             inherit system;
      
             config.allowUnfree = true;
            };
      #pkgs = import inputs.nixpkgs-unstable {
      #  inherit system;
#
 #       config.allowUnfree = true;
  #    };
      unstablePkgs = import inputs.nixpkgs-unstable {
        inherit system;

        config.allowUnfree = true;
      };

      _assertHostname = pkgs.lib.asserts.assertMsg (hostname == "") "you must specify a hostname!";

      _assertUsername = pkgs.lib.asserts.assertMsg (username == "") "you must specify a username!";

      #graphicalMod =
      #  if userland then
      #    (import ./graphical_standard.nix { inherit inputs pkgs; })
      #  else
      #    (import ./graphical_minimal.nix { inherit pkgs; });

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

        ./graphical_minimal.nix
        # intraNetworkModule
      ] ++ extraModules;
    };

}
