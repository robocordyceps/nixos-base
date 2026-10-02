# nixos-base
A very basic NixOS configuration that only serves as a boilerplate to authenticate against Github to pull the private NixOS configuration repository

## Disk layout (Disko)
`disko-config.nix` partitions two SSDs:
- **2TB (main)**: ESP (512M) + ext4 root, mounted at `/`. Houses the OS.
- **4TB (storage)**: single ext4 partition, mounted at `/mnt/storage`. Used purely for persistent storage.

Before installing, edit `disko-config.nix` and replace both `device` placeholders with the real
disk identifiers, e.g. from `ls -l /dev/disk/by-id/` (prefer `by-id` paths over `/dev/sdX`, which
can change across reboots).

## Usage (fresh install with Disko)
1. Boot the NixOS installer ISO and clone/copy this repo onto the target machine.
2. Edit `disko-config.nix` with the correct `by-id` device paths for the 2TB and 4TB disks.
3. Partition and format both disks (this is destructive — it wipes the listed disks):
   `sudo nix --experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko ./disko-config.nix`
4. Generate the hardware config without filesystems (Disko provides them):
   `sudo nixos-generate-config --no-filesystems --root /mnt`
5. Copy `configuration.nix` and `disko-config.nix` into `/mnt/etc/nixos/`.
6. Install: `sudo nixos-install`, then set the `admin` password when prompted and reboot.
7. Log in as `admin` (or the `initialPassword` of `changeme` if you skipped step 6's prompt), change it with `passwd`.
8. Authenticate: `gh auth login` (choose GitHub.com, HTTPS, login with a web browser / device code).
9. Pull the private config: `gh repo clone <owner>/<private-repo>` (plain `git clone https://github.com/...` also works via the gh credential helper).
10. Switch to it: `sudo nixos-rebuild switch --flake ./<private-repo>#<host>`.

## Usage (existing install)
1. Install NixOS, then `nixos-generate-config` (creates `/etc/nixos/hardware-configuration.nix`).
2. Copy `configuration.nix` and `disko-config.nix` over to `/etc/nixos/` and run `sudo nixos-rebuild switch`.
3. Continue from step 7 above.
