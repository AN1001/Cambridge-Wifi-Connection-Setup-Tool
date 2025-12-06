#!/bin/bash

# ==========================================
# Eduroam IWD Configuration Generator
# ==========================================

# --- Color Definitions for UI ---
# ANSI escape codes for terminal colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color (Reset)

# --- Root Privilege Check ---
# This script writes to /var/lib/iwd which requires root permissions.
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERROR] Please run this script as root (sudo).${NC}"
  exit 1
fi

# --- User Interface Header ---
clear
echo -e "${CYAN}==============================================${NC}"
echo -e "${CYAN}   Cambridge Eduroam Configuration (IWD)      ${NC}"
echo -e "${CYAN}==============================================${NC}"
echo -e "${YELLOW}This will generate /var/lib/iwd/eduroam.8021x${NC}"
echo ""

# --- Input Section ---

# Prompt for Username
# -e allows backslash interpretation, but read -p is safer for prompts
echo -e -n "${GREEN}Enter your username token (e.g. abc12+computer@cam.ac.uk): ${NC}"
read USERNAME

# Prompt for Password
# -s hides the input for security
echo -e -n "${GREEN}Enter your password (e.g. fgn7hkitaravkriv): ${NC}"
read -s PASSWORD
echo "" # Newline after hidden input

# --- Configuration Generation ---

FILE_PATH="/var/lib/iwd/eduroam.8021x"

echo ""
echo -e "${YELLOW}[*] Generating configuration file...${NC}"

# Write content to file using HEREDOC
# We use quotes around 'EOF' to prevent expansion, 
# but we actually WANT expansion for $USERNAME/$PASSWORD here, so we don't quote EOF.
cat <<EOF > "$FILE_PATH"
[Security]
EAP-Method=PEAP
EAP-Identity=_pub@cam.ac.uk
EAP-PEAP-Phase2-Method=MSCHAPV2
EAP-PEAP-Phase2-Identity=$USERNAME
EAP-PEAP-Phase2-Password=$PASSWORD
EAP-PEAP-CACert=/etc/ssl/certs/DigiCert_Global_Root_G2.pem
EAP-PEAP-ServerDomainMask=token-public.wireless.cam.ac.uk

[Settings]
AutoConnect=true
EOF

# --- Permissions & Cleanup ---

# Secure the file so only root can read the password
chmod 600 "$FILE_PATH"

echo -e "${GREEN}[SUCCESS] File created at $FILE_PATH${NC}"
echo -e "${CYAN}You may need to restart iwd: systemctl restart iwd${NC}"
