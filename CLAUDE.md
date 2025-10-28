This project is a ansible playbook to provision a Debian 13 Kde machine.

- Ensure all roles are idempotent.
- A role should have one responsibility.
- Keep extra files in the role itself
- Verify playbook by running ansible-lint

Order of preference for packages:

- flatpak
- 3rd party debian repositories
- debian repositories
