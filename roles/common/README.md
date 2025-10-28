# Common Role

This role handles common system configuration for Debian 13 KDE machines.

## Responsibilities

- Update system package cache
- Install common utility packages

## Variables

See `defaults/main.yml` for available variables.

## Dependencies

None

## Example Usage

```yaml
- hosts: local
  roles:
    - common
```
