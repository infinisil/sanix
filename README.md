# Sane stable stateless NixOS setup

This is a fairly straightforward setup for making a NixOS system configuration stateless without relying on experimental Nix features.

This means:
- `nix-channel` is disabled
- Nixpkgs is managed with [niv](https://github.com/nmattia/niv) or [npins](https://github.com/andir/npins)  [^1]
- The same Nixpkgs is used for the system and all Nix commands
- This includes the Nixpkgs version, config and overlays

[^1]: Yes niv and npins are third-party tools, but they're essentially just nice wrappers around `nix-prefetch-url` and co.

## Usage

We're assuming that you just installed NixOS by going through the [official installation docs](https://nixos.org/manual/nixos/stable/#sec-installation).

### Setup

1. Clone this repo to a local directory and enter it:
   ```
   nix-shell -p git --run \
     'git clone https://github.com/infinisil/sane-stable-nixos nixos'
   cd nixos
   ```
2. Add your initial NixOS configuration files, either
   - Move your existing configuration files into it:
     ```
     sudo mv /etc/nixos/* .
     ```
   - Generate new ones:
     ```
     nixos-generate-config --dir .
     ```
3. Pin Nixpkgs to the [latest stable version](https://nixos.org/manual/nixos/stable/release-notes) using [niv](https://github.com/nmattia/niv) or [npins](https://github.com/andir/npins):
   ```
   nix-shell -p niv --run \
     'niv init --nixpkgs NixOS/nixpkgs --nixpkgs-branch nixos-23.11'
   ```
   or
   ```
   nix-shell -p npins
     npins init --bare
     npins add --name nixpkgs github nixos nixpkgs --branch nixos-23.11
     exit
   ```
4. Remove all stateful channels:
   ```
   sudo rm -v /nix/var/nix/profiles/per-user/*/channels*
   ```
5. Rebuild:
   ```
   sudo ./rebuild switch
   ```
6. Log out and back in again.

### Making changes

Here are some changes you can make:
- Change the NixOS configuration in `./configuration.nix`
- Update the pinned Nixpkgs:
  ```
  niv update nixpkgs
  ```
  or
  ```
  npins update nixpkgs
  ```
- Upgrade to a newer release:
  ```
  niv update nixpkgs --branch nixos-23.11
  ```
  or

  ```
  npins add --name nixpkgs github nixos nixpkgs --branch nixos-24.05
  ```
- Change the Nixpkgs config by editing `nixpkgs/config.nix`
- Add Nixpkgs overlays to `nixpkgs/overlays.nix`
- Regenerate the hardware configuration:
  ```
  nixos-generate-configuration --dir .
  ```

To apply the changes, run
```
sudo ./rebuild switch
```

All options to `./rebuild` are forwarded to `nixos-rebuild`.

After rebuilding, the changes are reflected in the system.
Furthermore, all Nix commands on the system will also use the the same values.
