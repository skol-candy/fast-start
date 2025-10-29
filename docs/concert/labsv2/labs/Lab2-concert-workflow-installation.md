# Concert workflow installation

## Objective

Concert workflow is an embedded version of Rapid Infrastructure Automation in IBM Concert and is available as an add-on workflow automation service for on-premises deployments of Concert. 
The add-on embeds workflow definition and automation capabilities so you can define, manage, and automate workflows within the Concert UI.
The objective is to get data from an organisation environments and applications using flows.  

By default a flow is executed in a worker located on IBM Concert host. A notion of remote worker exist in Concert Workflow to enable the ingestion of data in IBM Concert from environments that cannot be reached directly by IBM Concert host. The remote worker is located near from the environment, collect required data and ingest them to IBM Concert using Concert APIs.

In this lab, you will install IBM Concert workflow as an add-on of your concert installation.

## Prerequisite

- IBM Concert must be installed

## Content

- [Concert workflow installation](#concert-workflow-installation)
  - [Objective](#objective)
  - [Prerequisite](#prerequisite)
  - [Content](#content)
  - [Install IBM Concert workflow with concert installed on a VM](#install-ibm-concert-workflow-with-concert-installed-on-a-vm)
    - [Install preprequisites](#install-preprequisites)
    - [Install Concert workflow](#install-concert-workflow)

## Install IBM Concert workflow with concert installed on a VM

Concert workflow installation require k3s and helm.

### Install preprequisites

1. Connect to the VM you have created on Techzone in Lab0

```bash
ssh itzuser@<VM ip address> -p 2223 -i /path/to/concert/sshkey/pem_ibmcloudvsi_download.pem
```

2. install k3s

> Offical documentation [k3s installation](https://www.ibm.com/docs/en/rapid-infra-auto/1.1.x?topic=planning-software-requirements#software_requirements__k3s__title__1)

```bash
cd $HOME
curl -sfL https://get.k3s.io | sudo INSTALL_K3S_VERSION=v1.33.3+k3s1 sh -s - --write-kubeconfig-mode 644 --disable traefik
```

3. Specify Kubernetes configuration file

```bash
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc
source ~/.bashrc
```

4. Insecure access to the internal registry must be enabled and registries.yaml must be defined under /etc/rancher/k3s:

Replace **YOUR_VM_PUBLIC_IP** with the public IP defined in your Techzone reservation.

```bash
sudo vi /etc/rancher/k3s/registries.yaml
```

Insert

```text
configs:
  "YOUR_VM_PUBLIC_IP.nip.io": 
    "tls": 
       insecure_skip_verify: true
```

Restart the Kubernetes service

```bash
sudo systemctl restart k3s
```

5. Install Helm

- Add /usr/local/bin in your path

```bash
echo "export PATH=$PATH:/usr/local/bin" >> ~/.bashrc
source ~/.bashrc
```

- Download and install helm
  
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

### Install Concert workflow

> Official documentation: [Concert Worflow installation](https://www.ibm.com/docs/en/concert/2.0.0?topic=vm-installing-concert-software)

1. Connect to the VM you have created on Techzone in Lab0 and source environment variables

```bash
ssh itzuser@<VM ip address> -p 2223 -i /path/to/concert/sshkey/pem_ibmcloudvsi_download.pem
```

2. Configure the Concert Workflow parameter file

```bash
source $HOME/env.sh
cd $INSTALL_DIR
cp $INSTALL_DIR/etc/sample-params/workflows-quickstart-vm-params.ini $INSTALL_DIR/etc/params.ini
```

3. Edit the params.ini file with the required parameters

Replace **YOUR_VM_PUBLIC_IP** with the public IP defined in your Techzone reservation.

```text
DOCKER_EXE=podman

INSTALL_VM=true
INSTALL_WORKFLOWS=true
# Registry users
REG_USER=cp
IMAGE_REGISTRY_PREFIX=cp.icr.io/cp
HUB_IMAGE_REGISTRY_SUFFIX=/solis-hub
WORKFLOWS_IMAGE_REGISTRY_SUFFIX=/concert         
WORKFLOWS_INSTANCE_ADDRESS=YOUR_VM_PUBLIC_IP.nip.io
```

4. Install Concert Workflow

Replace <user> and <password> by your own values

```bash
${DOCKER_EXE} login ${IBM_REGISTRY} --username=${IBM_REGISTRY_USER} --password=${IBM_REGISTRY_PASSWORD}
$INSTALL_DIR/bin/setup --license_acceptance=y --username=<user> --password=<password> --registry_password=${IBM_REGISTRY_PASSWORD}
```

**IMPORTANT**: Wait until the end of the installation. Be patient, it can take up to 20 minutes. It's time for a coffee break !

1. Check Concert Workflow installation
  
- From a browser, enter the URL of your concert instance (https://YOUR_VM_PUBLIC_IP.nip.io/workflows) and log with your concert username and password.
- You should have now a **Workflows** menu on the left burger meny
- Navigate to **Workflows->Workflows** and check that a page is displayed successfully