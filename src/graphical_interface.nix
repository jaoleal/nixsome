{
  pkgs,
  ...
}:
{
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
  environment.gnome.excludePackages =

    (
      with pkgs;
      [
        epiphany
        evince
        gedit
        gnome-photos
        gnome-tour
        gnome-music
        gnome-maps
        gnome-contacts
        gnome-weather
        epiphany
        geary
        evince
        totem
        tali
        iagno
        hitori
        atomix
        gnome-klotski
        gnome-mines
        gnome-nibbles
        gnome-robots
        gnome-sudoku
        gnome-taquin
        gnome-tetravex
        quadrapassel
        swell-foop
        lightsoff
        four-in-a-row
        gnome-chess
        yelp
        gnome-logs
        seahorse

      ]
    );
  # Install required packages for extensions and GNOME functionality
  environment.systemPackages =
    let
      gnome-extensions = with pkgs.gnomeExtensions; [
        wireguard-vpn-extension
        blur-my-shell
        caffeine
        dash-to-dock
        removable-drive-menu
        tiling-assistant
        vitals
      ];
    in
    with pkgs;
    [
      
      # Extension requirements
      glib # Required for GSettings and various GNOME extensions
      gtk3 # GTK3 libraries
      gtk4 # GTK4 libraries for newer extensions
      libgtop # System monitoring library (required for Vitals)
      lm_sensors
      hddtemp
      udisks
      upower
      networkmanager
      gnome-tweaks
      dconf-editor
    ];
  # Programs that complement the setup
  programs = {
    # Gaming mode support (for GameBar overlay)
    gamemode.enable = true;
  };

}
