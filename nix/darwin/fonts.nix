{
  pkgs,
  ...
}:
{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.hack
      hackgen-nf-font
      udev-gothic-nf
    ];
  };
}
