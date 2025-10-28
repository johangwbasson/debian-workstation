# Flatpak Role

This role configures Flatpak with Flathub repository and the KDE Discover Flatpak backend.

## Responsibilities

- Install Flatpak package manager
- Install KDE Discover Flatpak backend plugin (plasma-discover-backend-flatpak)
- Add Flathub repository as a remote
- Enable Flathub remote
- Verify Flatpak configuration

## Variables

See `defaults/main.yml` for available variables:

- `flatpak_packages`: List of packages to install (default: flatpak, plasma-discover-backend-flatpak)
- `flathub_remote_name`: Name for the Flathub remote (default: "flathub")
- `flathub_remote_url`: URL to Flathub repository (default: https://dl.flathub.org/repo/flathub.flatpakrepo)
- `flatpak_installation`: Installation scope - system or user (default: "system")

## Features

### Flatpak Installation
Installs the core Flatpak runtime which allows running containerized applications.

### Flathub Repository
Adds and enables the Flathub repository, the primary source for Flatpak applications.

### KDE Discover Integration
Installs the Flatpak backend for KDE Discover, allowing you to:
- Browse and install Flatpak apps from Discover
- Manage Flatpak applications alongside native packages
- Receive updates for Flatpak apps through Discover

## Dependencies

None

## Example Usage

```yaml
- hosts: local
  roles:
    - flatpak
```

## Customization

You can override the Flathub URL or add additional Flatpak packages:

```yaml
- hosts: local
  roles:
    - role: flatpak
      vars:
        flatpak_packages:
          - flatpak
          - plasma-discover-backend-flatpak
          - xdg-desktop-portal-kde
```

## Post-Installation

After running this role:
1. Open KDE Discover
2. You should see Flatpak applications available for installation
3. Applications from Flathub will be marked with the Flatpak source
