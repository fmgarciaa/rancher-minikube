# Rancher-Minikube

This project automates the process of deploying Rancher in a local environment using **Minikube**. The script does the following:

1. Verifies that the required commands (`minikube`, `kubectl`, `helm`) are installed.
2. Starts Minikube if it's not running.
3. Installs **cert-manager** using Helm.
4. Deploys **Rancher** on a Kubernetes cluster managed by Minikube.

**Note:** This setup is specifically configured for **MacOS**. It is necessary to enable the `chipmk/tap/docker-mac-net-connect` setting for Docker networking.

## Requirements

Before running the script, ensure the following commands are installed on your local machine:

- [Minikube](https://minikube.sigs.k8s.io/docs/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)
- **Docker** installed and running (MacOS).

Additionally, to ensure Docker networking works correctly with Minikube, **enable the Docker Mac networking connection** by running the following commands in your terminal:

1. Install `docker-mac-net-connect` using **Homebrew**:

   ```bash
   brew install chipmk/tap/docker-mac-net-connect
   ```

2. Start the `docker-mac-net-connect` service:

   ```bash
   sudo brew services start chipmk/tap/docker-mac-net-connect
   ```

These steps will set up the necessary networking configuration for Minikube to work properly with Docker on MacOS.

## Usage Instructions

1. **Clone the repository** or download the script.

   ```bash
   git clone https://github.com/fmgarciaa/rancher-minikube.git
   cd rancher-minikube
   ```

2. **Run the deployment script**:

   Make sure the script has execution permissions. If not, assign them with the following command:

   ```bash
   chmod +x ./scripts/setup.sh
   ```

   Then, run the script with:

   ```bash
   ./scripts/setup.sh
   ```

   The script will perform the following actions:

   - It will check if **minikube**, **kubectl**, and **helm** are installed.
   - It will start Minikube if it’s not already running.
   - It will install **cert-manager** using Helm.
   - It will deploy **Rancher** to your Minikube cluster.

3. **Minikube Configuration**:

   If Minikube is not running, the script will start it with the following configuration:

   - Driver: `docker`
   - Kubernetes version: `v1.31.0`
   - Memory: `4096MB`
   - CPUs: `4`
   - It will enable the `ingress` and `ingress-dns` addons.

4. **Access Rancher**:

   Once Rancher is installed, you can access its web interface. To get the access URL, run the following command:

   ```bash
   kubectl get ingress -n cattle-system
   ```

   This will provide the public URL where Rancher will be available.

   Note: Rancher may take several minutes to fully initialize as certificates are being issued, containers are starting, and the ingress rule is coming up.

## Customization

If you need to customize the Rancher installation values, you can modify the `values.yaml` file. This file is used during the Rancher installation to set additional configurations.

## Cleanup

If you want to remove the entire stack, you can use the `cleanup.sh` script. This script will:

- Uninstall **Rancher**.
- Remove the **cert-manager**.
- Stop and delete the **Minikube** cluster.

To run the cleanup script, use the following steps:

1. Ensure the script has execution permissions:

   ```bash
   chmod +x ./scripts/cleanup.sh
   ```

2. Run the script:

   ```bash
   ./scripts/cleanup.sh
   ```

   This will clean up the resources and stop the Minikube cluster.

## Troubleshooting

If you encounter issues during script execution, check the following:

- Ensure you have enough memory and CPU on your machine to run Minikube.
- If the script fails to install **cert-manager** or **Rancher**, make sure Helm is properly configured and the repositories are up to date.
- You can check the logs of Minikube and Kubernetes pods with the following commands:

  ```bash
  minikube logs
  kubectl logs <pod-name> -n cattle-system
  ```

## Contributions

Contributions are welcome. If you have improvements or fixes, please open a **pull request**.
