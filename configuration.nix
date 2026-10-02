# Minimal bootstrap config, used through flake.nix (see README).
# Filesystems come from disko.nix; hardware-configuration.nix must be
# generated with `nixos-generate-config --no-filesystems`.
{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-base";
  networking.networkmanager.enable = true;

  time.timeZone = "UTC";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "changeme"; # change after first login
  };

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    gh   # `gh auth login` authenticates against GitHub
    vim
  ];

  # Lets git use the gh credentials for HTTPS clones of private repos.
  programs.git = {
    enable = true;
    config = {
      credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
      credential."https://gist.github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };
  };

  system.stateVersion = "25.05";
}
