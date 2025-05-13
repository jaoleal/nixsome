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
  environment.gnome.excludePackages = (
    with pkgs;
    [
       # puzzle game
      #cheese # webcam tool
      epiphany # web browser
      evince # document viewer
      #geary # email reader
      gedit # text editor
      # gnome-characters
      # gnome-music
      gnome-photos
      gnome-tour
      # hitori # sudoku game
      #iagno # go game
      #tali # poker game
      #totem # video player
    ]
  );

}
