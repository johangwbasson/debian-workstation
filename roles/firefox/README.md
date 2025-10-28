# Firefox Role

This role installs the latest Firefox from Flathub and removes Firefox ESR from Debian repositories.

## Responsibilities

- Remove Firefox ESR package from Debian repositories
- Install the latest Firefox from Flathub as a Flatpak application
- Verify Firefox Flatpak installation

## Rationale

Following the package preference order (Flatpak > 3rd party repos > Debian repos), this role:
- Uses Firefox from Flathub to get the latest version
- Removes the outdated Firefox ESR from Debian repositories
- Ensures Firefox stays up-to-date through Flatpak updates

## Variables

See `defaults/main.yml` for available variables:

- `firefox_flatpak_id`: Flatpak application ID (default: "org.mozilla.firefox")
- `firefox_debian_packages_to_remove`: List of Debian packages to remove
- `firefox_install_flatpak`: Whether to install Firefox Flatpak (default: true)

## Dependencies

This role depends on the `flatpak` role, which:
- Installs Flatpak
- Configures Flathub repository
- Installs KDE Discover Flatpak backend

The dependency is automatically handled through `meta/main.yml`.

## Features

### Package Removal
- Removes `firefox-esr` package
- Removes related language packs
- Purges configuration files
- Runs autoremove to clean up unused dependencies

### Flatpak Installation
- Checks if Firefox is already installed (idempotent)
- Installs Firefox from Flathub
- Verifies successful installation
- Uses non-interactive installation (-y flag)

## Example Usage

```yaml
- hosts: local
  roles:
    - firefox
```

## Customization

Override variables if needed:

```yaml
- hosts: local
  roles:
    - role: firefox
      vars:
        firefox_debian_packages_to_remove:
          - firefox-esr
          - firefox-esr-l10n-*
```

## Post-Installation

After running this role:
1. Firefox ESR will be removed from your system
2. Firefox Flatpak will be installed and available in your application menu
3. Firefox will auto-update through Flatpak
4. You can manage Firefox updates via KDE Discover or `flatpak update`

## Notes

- The Flatpak version runs in a sandbox for better security
- Firefox profile data is stored separately from the ESR version
- First launch may take slightly longer as Flatpak sets up the runtime
