#!/bin/bash

set -e  # Exit on any error

echo "================================================"
echo "   Docker & Docker Compose Installation Script  "
echo "================================================"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# ✅ Suppress ALL interactive prompts automatically
export DEBIAN_FRONTEND=noninteractive

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run as root or with sudo${NC}"
  exit 1
fi

echo -e "${YELLOW}Step 1: Updating system...${NC}"
apt-get update -y && apt-get upgrade -y \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confold"

echo -e "${YELLOW}Step 2: Installing dependencies...${NC}"
apt-get install -y \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confold" \
  ca-certificates curl gnupg lsb-release apt-transport-https software-properties-common

# echo -e "${YELLOW}Step 2.1: Installing Git...${NC}"
# apt-get install -y \
#   -o Dpkg::Options::="--force-confdef" \
#   -o Dpkg::Options::="--force-confold" \
#   git

# git --version
# echo -e "${GREEN}✅ Git installed successfully!${NC}"

echo -e "${YELLOW}Step 3: Adding Docker GPG key & repository...${NC}"
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

echo -e "${YELLOW}Step 4: Installing Docker Engine...${NC}"
apt-get update -y
apt-get install -y \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confold" \
  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo -e "${YELLOW}Step 5: Installing Docker Compose (standalone)...${NC}"
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo -e "${YELLOW}Step 6: Starting & enabling Docker...${NC}"
systemctl start docker
systemctl enable docker

echo -e "${YELLOW}Step 7: Adding current user to docker group...${NC}"
if [ -n "$SUDO_USER" ]; then
  usermod -aG docker "$SUDO_USER"
  echo -e "${GREEN}User '$SUDO_USER' added to docker group${NC}"
else
  echo -e "${YELLOW}Skipping user group add (running as root)${NC}"
fi

echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}   Installation Complete! Verifying...         ${NC}"
echo -e "${GREEN}================================================${NC}"

docker --version
docker compose version
docker-compose --version

echo ""
echo -e "${GREEN}✅ Docker and Docker Compose installed successfully!${NC}"
# echo -e "${YELLOW}⚠️  Log out and back in for docker group changes to take effect.${NC}"

# echo -e "${YELLOW}Step 8: Installing latest Node.js...${NC}"
# curl -fsSL https://deb.nodesource.com/setup_current.x | bash
# apt-get install -y nodejs

# # Verify installation
# node -v
# npm -v

# echo -e "${GREEN}✅ Node.js installed successfully!${NC}"

echo -e "${YELLOW}Step 8: Installing Nixpacks...${NC}"
curl -sSL https://nixpacks.com/install.sh | bash
echo -e "${GREEN}✅ Nixpacks installed successfully!${NC}"

echo -e "${YELLOW}Step 9: Installing Docker Buildx...${NC}"
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/buildx/releases/download/v0.33.0/buildx-v0.33.0.linux-amd64 -o ~/.docker/cli-plugins/docker-buildx
chmod +x ~/.docker/cli-plugins/docker-buildx
docker buildx version
echo -e "${GREEN}✅ Docker Buildx installed successfully!${NC}"
