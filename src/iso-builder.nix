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

      unstablePkgs = pkgs;

      # Import the base configuration's modules
      baseConfigPath = ./${baseConfig};

      # Use a generic username for ISO
      username = "nixos";

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
            # Disable some services that might cause issues in ISO
            services.tailscale.enable = lib.mkForce false;
            # Use a simple user for the ISO
            # Note: Empty password is intentional for live ISO environments to allow immediate access
            # Users should set a secure password after installation or if persisting the system
            users.users.nixos = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              initialPassword = "";
            };
          }
        )
      ];
    };
}
