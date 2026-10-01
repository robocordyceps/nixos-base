# nixos-base
A very basic NixOS configuration that only serves as a boilerplate to authenticate against Github to pull the private NixOS configuration repository

## Usage
1. Install NixOS, then `nixos-generate-config` (creates `/etc/nixos/hardware-configuration.nix`).
2. Copy `configuration.nix` over `/etc/nixos/configuration.nix` and run `sudo nixos-rebuild switch`.
3. Log in as `admin` (initial password `changeme`, change it with `passwd`).
4. Authenticate: `gh auth login` (choose GitHub.com, HTTPS, login with a web browser / device code).
5. Pull the private config: `gh repo clone <owner>/<private-repo>` (plain `git clone https://github.com/...` also works via the gh credential helper).
6. Switch to it: `sudo nixos-rebuild switch --flake ./<private-repo>#<host>`.
