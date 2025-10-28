# APT Sources Role

This role manages the `/etc/apt/sources.list` file for Debian systems.

## Responsibilities

- Configure APT repository sources for Debian 13 (Trixie)
- Include main, contrib, non-free, and non-free-firmware components
- Enable security and backports repositories
- Disable all source repositories (deb-src)
- Backup existing sources.list before modifications

## Variables

See `defaults/main.yml` for available variables:

- `debian_release`: Debian release number (default: "13")
- `debian_codename`: Debian release codename (default: "trixie")
- `debian_mirror`: Main Debian mirror URL
- `debian_security_mirror`: Security updates mirror URL
- `backup_sources_list`: Whether to backup existing sources.list (default: true)

## Repositories Included

- Main repository (main, contrib, non-free, non-free-firmware)
- Updates repository
- Security repository
- Backports repository

All source repositories (deb-src) are commented out.

## Dependencies

None

## Example Usage

```yaml
- hosts: local
  roles:
    - apt-sources
```

## Customization

Override variables in your playbook or vars file:

```yaml
- hosts: local
  roles:
    - role: apt-sources
      vars:
        debian_mirror: "http://ftp.de.debian.org/debian"
```
