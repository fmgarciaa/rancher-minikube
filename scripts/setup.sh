#!/bin/bash

set -e # Exit immediately if a command fails

# Colors for output
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[36m'
RESET='\033[0m'

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate required commands
echo -e "Step 1: Validating required commands."
for cmd in minikube kubectl helm; do
    echo -e "${CYAN}[info] Checking if $cmd is installed...${RESET}"
    if ! command_exists "$cmd"; then
        echo -e "${RED}[error] $cmd is not installed. Please install it before running this script.${RESET}"
        exit 1
    fi
done
echo -e "${GREEN}[success]✅ All required commands are installed.${RESET}"

# Check Minikube status
echo -e "Step 2: Checking Minikube status."
if minikube status --format='{{.Host}}' 2>/dev/null | grep -q "Running"; then
    echo -e "${GREEN}[success]✅ Minikube is already running.${RESET}"
    echo -e "${YELLOW}❗ Enable the following Minikube addons for the stack to work:\n- ingress-dns\n- ingress\nCommands:\nminikube addons enable ingress-dns\nminikube addons enable ingress.${RESET}"
else
    echo -e "${CYAN}[info] Minikube is not running. Starting Minikube...${RESET}"
    minikube start --driver=docker --kubernetes-version=v1.31.0 --memory=4096 --cpus=4 --addons=ingress --addons=ingress-dns
    echo -e "${GREEN}[success]✅ Minikube is ready.${RESET}"
fi

# Install CDR and Cert-Manager
echo -e "Step 3: Installing cert-manager with CRDs."
helm repo add jetstack https://charts.jetstack.io --force-update >/dev/null 2>&1
echo -e "${CYAN}[info] cert-manager helm repo add and update.${RESET}"
echo -e "${CYAN}[info] cert-manager helm repo install...${RESET}"
deployment_message=$(helm install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --version v1.12.2 \
    --set installCRDs=true 2>/dev/null | grep "cert-manager .* has been deployed successfully!")
echo -e "${GREEN}[success]✅ $deployment_message${RESET}"

# Install Rancher
echo -e "Step 4: Installing Rancher."
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable --force-update >/dev/null 2>&1
echo -e "${CYAN}[info] rancher helm repo add and update.${RESET}"
echo -e "${CYAN}[info] rancher helm repo install...${RESET}"
helm install rancher rancher-stable/rancher \
    --namespace cattle-system \
    --create-namespace \
    --values ./values.yaml >/dev/null 2>&1
echo -e "${GREEN}[success]✅ Rancher Server has been installed!${RESET}"
echo -e "${YELLOW}📌 NOTE: Rancher may take several minutes to fully initialize. Please stand by while certificates are being issued, containers are starting, and the ingress rule is coming up.${RESET}"
