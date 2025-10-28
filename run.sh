#!/usr/bin/env bash
#
# Run script for Ansible playbook
# Executes the main playbook with proper checks and options

set -e  # Exit on error
set -u  # Exit on undefined variable

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# Check if Ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    error "ansible-playbook not found. Please run ./bootstrap.sh first"
fi

# Check if .vars.yml exists
if [ ! -f .vars.yml ]; then
    error ".vars.yml not found. Please run ./bootstrap.sh or create it from .vars.yml.example"
fi

# Parse command line arguments
CHECK_MODE=false
VERBOSE=""
TAGS=""
SKIP_TAGS=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--check)
            CHECK_MODE=true
            shift
            ;;
        -v|--verbose)
            VERBOSE="-v"
            shift
            ;;
        -vv|--very-verbose)
            VERBOSE="-vv"
            shift
            ;;
        -vvv|--debug)
            VERBOSE="-vvv"
            shift
            ;;
        -t|--tags)
            TAGS="--tags $2"
            shift 2
            ;;
        --skip-tags)
            SKIP_TAGS="--skip-tags $2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -c, --check           Run in check mode (dry-run)"
            echo "  -v, --verbose         Verbose output"
            echo "  -vv, --very-verbose   Very verbose output"
            echo "  -vvv, --debug         Debug output"
            echo "  -t, --tags TAGS       Run only tasks with specified tags"
            echo "  --skip-tags TAGS      Skip tasks with specified tags"
            echo "  -h, --help            Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                    # Run playbook normally"
            echo "  $0 --check            # Dry-run to see what would change"
            echo "  $0 -vv                # Run with verbose output"
            echo "  $0 --tags apt-sources # Run only apt-sources tasks"
            exit 0
            ;;
        *)
            error "Unknown option: $1. Use --help for usage information."
            ;;
    esac
done

# Build ansible-playbook command
ANSIBLE_CMD="ansible-playbook site.yml --ask-become-pass"

if [ "$CHECK_MODE" = true ]; then
    ANSIBLE_CMD="$ANSIBLE_CMD --check"
    info "Running in CHECK MODE (dry-run) - no changes will be made"
fi

if [ -n "$VERBOSE" ]; then
    ANSIBLE_CMD="$ANSIBLE_CMD $VERBOSE"
fi

if [ -n "$TAGS" ]; then
    ANSIBLE_CMD="$ANSIBLE_CMD $TAGS"
fi

if [ -n "$SKIP_TAGS" ]; then
    ANSIBLE_CMD="$ANSIBLE_CMD $SKIP_TAGS"
fi

# Display configuration
info "Configuration:"
info "  Playbook: site.yml"
info "  Inventory: inventory.ini"
info "  Variables: .vars.yml"
echo ""
info "You will be prompted for your sudo password"
echo ""

# Ask for confirmation if not in check mode
if [ "$CHECK_MODE" = false ]; then
    warn "This playbook will make changes to your system."
    read -p "Do you want to continue? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        info "Aborted by user"
        exit 0
    fi
fi

# Run the playbook
info "Running playbook..."
echo -e "${BLUE}Command: $ANSIBLE_CMD${NC}"
echo ""

eval $ANSIBLE_CMD

# Check exit status
if [ $? -eq 0 ]; then
    echo ""
    info "Playbook execution completed successfully!"
else
    error "Playbook execution failed!"
fi
