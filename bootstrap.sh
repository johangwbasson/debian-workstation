#!/usr/bin/env bash
#
# Bootstrap script for Ansible playbook infrastructure
# This script installs Ansible and required dependencies

set -e  # Exit on error
set -u  # Exit on undefined variable

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*"
    exit 1
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    error "Please do not run this script as root. It will use sudo when needed."
fi

# Check if .vars.yml exists
if [ ! -f .vars.yml ]; then
    warn ".vars.yml not found. Creating from template..."
    if [ -f .vars.yml.example ]; then
        cp .vars.yml.example .vars.yml
        warn "Please edit .vars.yml with your configuration before running the playbook"
    else
        error ".vars.yml.example not found"
    fi
fi

info "Updating package cache..."
sudo apt-get update

info "Installing required system packages..."
sudo apt-get install -y \
    python3 \
    python3-pip \
    python3-apt \
    git

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    info "Installing Ansible..."
    sudo apt-get install -y ansible
else
    info "Ansible is already installed: $(ansible --version | head -n1)"
fi

# Check if ansible-lint is installed
if ! command -v ansible-lint &> /dev/null; then
    info "Installing ansible-lint..."
    sudo apt-get install -y ansible-lint
else
    info "ansible-lint is already installed: $(ansible-lint --version | head -n1)"
fi

# Install Ansible Galaxy requirements
if [ -f requirements.yml ]; then
    info "Installing Ansible Galaxy requirements..."
    ansible-galaxy collection install -r requirements.yml
else
    warn "requirements.yml not found, skipping Galaxy installation"
fi

info "Bootstrap complete!"
info "Next steps:"
info "  1. Edit .vars.yml with your configuration"
info "  2. Run ./run.sh to execute the playbook"
