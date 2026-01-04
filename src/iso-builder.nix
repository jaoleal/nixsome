{ ... }:
{
  buildNixosISO =
    {
      hostname,
      inputs,
      system ? "x86_64-linux",
      stateVersion ? "24.05",
      baseConfig,
      hardened ? true,
    }:
    let
      pkgs = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      # Import the base configuration's modules
      baseConfigPath = ./${baseConfig};

    in
    inputs.nixpkgs-unstable.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          pkgs
          inputs
          system
          hostname
          stateVersion
          ;
      };
      modules = [
        # Import the base configuration
        baseConfigPath
        # Import the minimal ISO installer configuration
        "${inputs.nixpkgs-unstable}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        # Apply hardening if requested
        (
          if hardened then
            "${inputs.nixpkgs-unstable}/nixos/modules/profiles/hardened.nix"
          else
            { }
        )
        # Additional ISO-specific configuration
        (
          { lib, ... }:
          {
            # Override some settings from the base config that might not work in ISO
            services.xserver.enable = lib.mkForce false;
            # Ensure we can build the ISO
            isoImage.makeEfiBootable = true;
            isoImage.makeUsbBootable = true;
          }
        )
      ];
    };
}
