# Default recipe to display help
default:
    @just --list

# Install NixOS with disko for randy (DESTRUCTIVE - will wipe disks!)
install-randy:
    @echo "⚠️  WARNING: This will WIPE your disk for the randy machine!"
    @echo "This will format /dev/nvme1n1 (boot, swap, root, and home)"
    @echo "Press Ctrl+C to cancel, Enter to continue..."
    @read
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./hosts/randy/disko.nix
    nixos-generate-config --root /mnt
    sudo nixos-install --flake .#randy
    @echo "🎉 NixOS installation complete!"
    @echo "After reboot, manually copy your dotfiles and run your home setup."

# Quick rebuild shortcuts
randy:
    sudo nixos-rebuild switch --flake .#randy

# Test configurations without switching
test-randy:
    sudo nixos-rebuild test --flake .#randy

# Build configurations without switching
build-randy:
    sudo nixos-rebuild build --flake .#randy

# Full system update (flake + rebuild + home-manager)
full-randy:
    nix flake update
    sudo nixos-rebuild switch --flake .#randy

# Update flake inputs
update:
    nix flake update

# Update specific input
update-input input:
    nix flake lock --update-input {{input}}

# Format nix files
fmt:
    nix fmt

# Check flake for errors
check:
    nix flake check

# Clean old generations (keep last 7)
clean:
    sudo nix-collect-garbage -d
    sudo nix-env --delete-generations +7 -p /nix/var/nix/profiles/system
    nix-env --delete-generations +7

# Show system generations
generations:
    sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# Boot into previous generation
rollback:
    sudo nixos-rebuild switch --rollback

# Development shell
dev:
    nix develop

# Show disk usage
disk-usage:
    sudo du -sh /nix/store
    sudo du -sh /nix/var/nix/profiles/

# Optimize nix store
optimize:
    sudo nix-store --optimize

# Show what's in the current generation
show-config:
    nix show-config

# Backup current config before major changes
backup:
    cp -r . ~/dotfiles-backup-$(date +%Y%m%d-%H%M%S)
    @echo "Backup created in ~/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Check syntax of all nix files
check-syntax:
    find . -name "*.nix" -exec nix-instantiate --parse {} \; > /dev/null

# Show flake inputs
show-inputs:
    nix flake metadata --json | jq '.locks.nodes | to_entries[] | select(.key != "root") | {(.key): .value.locked}'

# Check disk layout before installation
check-disks:
    @echo "Current disk layout:"
    @lsblk
    @echo ""
    @echo "⚠️  Disko will format these disks:"
    @echo "  /dev/nvme1n1 -> /boot (2G), swap (8G), / and /home (remaining, btrfs)"

# Verify disko configuration
verify-disko:
    @echo "Verifying disko configuration..."
    nix eval --impure --expr '(import ./hosts/randy/disko.nix).disko.devices'

# Update hardware configuration from /etc/nixos and rebuild the system
update-hw:
    cp /etc/nixos/hardware-configuration.nix ./hosts/randy/hardware-configuration.nix
    sudo nix --experimental-features "nix-command flakes" build .#nixosConfigurations.randy.config.system.build.toplevel
    sudo nixos-rebuild switch --flake .#randy
