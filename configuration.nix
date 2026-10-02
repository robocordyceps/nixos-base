# Minimal bootstrap config. Copy to /etc/nixos/ next to the generated
# hardware-configuration.nix, then run `nixos-rebuild switch`.
{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
    # Pin a commit/tag for reproducibility once the layout is finalized.
    "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
  ];

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
