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
}
