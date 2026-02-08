#!/usr/bin/env zsh

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
GITCONFIG_LOCAL="$HOME/.config/git/config.local"
GITCONFIG_DIR="$(dirname "$GITCONFIG_LOCAL")"
GITCONFIG_MAIN="$HOME/.config/git/config"

# Check if 1Password CLI is installed
if ! command -v op &>/dev/null; then
  echo -e "${RED}Error: 1Password CLI (op) is not installed${NC}"
  echo "Install it from: https://developer.1password.com/docs/cli/get-started/"
  exit 1
fi

# Check if signed in to 1Password
if ! op account list &>/dev/null; then
  echo -e "${RED}Error: Not signed in to 1Password CLI${NC}"
  echo 'Run: eval $(op signin)'
  exit 1
fi

# Get vault (ID or name)
echo -e "${BLUE}Enter 1Password vault ID or name [default: dev]:${NC} "
read VAULT
VAULT="${VAULT:-dev}"

# Get item (ID or name)
echo -e "${BLUE}Enter 1Password item ID or name [default: GitHubSigningKey]:${NC} "
read ITEM_REF
ITEM_REF="${ITEM_REF:-GitHubSigningKey}"

if [ -z "$ITEM_REF" ]; then
  echo -e "${RED}Error: Item ID or name cannot be empty${NC}"
  exit 1
fi

FIELDS="public key"

echo -e "${YELLOW}Fetching public key from 1Password...${NC}"

# Try to fetch the public key with error handling
if ! PUBLIC_KEY=$(op item get "$ITEM_REF" --vault "$VAULT" --fields "$FIELDS" 2>&1); then
  echo -e "${RED}Error: Failed to fetch public key from 1Password${NC}"
  echo -e "${RED}$PUBLIC_KEY${NC}"
  exit 1
fi

if [ -z "$PUBLIC_KEY" ]; then
  echo -e "${RED}Error: Public key field is empty${NC}"
  exit 1
fi

echo -e "${GREEN}✓ Public key retrieved successfully${NC}"

# Create config directory if it doesn't exist
if [ ! -d "$GITCONFIG_DIR" ]; then
  echo -e "${YELLOW}Creating directory: $GITCONFIG_DIR${NC}"
  mkdir -p "$GITCONFIG_DIR"
fi

# Check if config already exists and has signing configuration
if [ -f "$GITCONFIG_LOCAL" ]; then
  if grep -q "signingkey" "$GITCONFIG_LOCAL" 2>/dev/null; then
    echo -e "${YELLOW}Warning: Existing signing configuration found${NC}"
    echo -n "Overwrite existing configuration? (y/N): "
    read CONFIRM
    if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
      echo -e "${YELLOW}Aborted${NC}"
      exit 0
    fi

    # Backup existing config
    BACKUP_FILE="${GITCONFIG_LOCAL}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}Creating backup: $BACKUP_FILE${NC}"
    cp "$GITCONFIG_LOCAL" "$BACKUP_FILE"
  fi
fi

echo -e "${YELLOW}Writing Git signing configuration...${NC}"

# Write configuration using git config
git config --file "$GITCONFIG_LOCAL" user.signingkey "$PUBLIC_KEY"
git config --file "$GITCONFIG_LOCAL" gpg.format ssh
git config --file "$GITCONFIG_LOCAL" gpg.ssh.program "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
git config --file "$GITCONFIG_LOCAL" commit.gpgsign true

echo -e "${GREEN}✓ Configuration written to $GITCONFIG_LOCAL${NC}"
echo -e "${GREEN}✓ Config will be loaded via ~/.config/git/config include${NC}"

echo ""
echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo -e "${BLUE}Verify the configuration:${NC}"
echo "  git config --get user.signingkey"
echo "  git config --get gpg.format"
echo "  git config --get commit.gpgsign"
