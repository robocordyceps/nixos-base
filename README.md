# nixos-base
A very basic NixOS configuration that only serves as a boilerplate to authenticate against Github to pull the private NixOS configuration repository

## Disk layout (Disko)
`disko.nix` partitions two SSDs:

- 2TB (`main`): 1G EFI partition at `/boot`, the rest ext4 at `/` (the OS).
- 4TB (`data`): one ext4 partition at `/data` (persistent storage only).

Replace the `REPLACE-WITH-...` device paths in `disko.nix` with your disks' `/dev/disk/by-id/...` paths first.

## Fresh install (from the NixOS installer, wipes both disks)
1. Get this repo: `nix-shell -p git` then `git clone https://github.com/robocordyceps/nixos-base && cd nixos-base`.
2. Edit the device paths in `disko.nix`.
3. Partition and mount (Disko is fetched through the flake):
   `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake .#nixos-base`
4. Generate the hardware config without filesystems (Disko defines them):
   `sudo nixos-generate-config --no-filesystems --root /mnt --dir .` and keep `hardware-configuration.nix` next to `configuration.nix` (`git add` it; flakes ignore untracked files).
5. Install: `sudo nixos-install --flake .#nixos-base`, then reboot.

## Authenticate and pull the real config
1. Log in as `admin` (initial password `changeme`, change it with `passwd`).
2. Authenticate: `gh auth login` (GitHub.com, HTTPS, web browser / device code).
3. Pull the private config: `gh repo clone <owner>/<private-repo>` (plain `git clone https://github.com/...` also works via the gh credential helper).
4. Switch to it: `sudo nixos-rebuild switch --flake ./<private-repo>#<host>`.
