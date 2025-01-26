#!/bin/bash

set -e # Exit immediately if a command fails

# Colors for output
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[36m'
RESET='\033[0m'

echo -e "${YELLOW}Cleaning up resources...${RESET}"

# Uninstall Ingress NGINX
echo -e "${CYAN}[info] Stopping Minikube...${RESET}"
minikube stop || echo -e "${RED}[error] Failed to stop Minikube${RESET}"
echo -e "${GREEN}[success] Minikube stopped successfully.${RESET}"

echo -e "${CYAN}[info] Deleting Minikube...${RESET}"
minikube delete || echo -e "${RED}[error] Failed to delete Minikube${RESET}"
echo -e "${GREEN}[success] Minikube deleted successfully.${RESET}"

# Final information
echo -e "${GREEN}[success] All resources have been cleaned up. You can now re-run setup.sh.${RESET}"
