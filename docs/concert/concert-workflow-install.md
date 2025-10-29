# Concert Workflows Installation

## Objective

Concert Workflows is an embedded version of Rapid Infrastructure Automation in IBM Concert and is available as an add-on workflow automation service for on-premises deployments of Concert. 

The add-on embeds workflow definition and automation capabilities so you can define, manage, and automate workflows within the Concert UI.

The objective is to get data from an organization's environments and applications using low-code flows.  

By default, a flow is executed in a worker located on the IBM Concert host. A notion of remote workers exist in Concert Workflow to enable the ingestion of data into IBM Concert from environments that cannot be reached directly by the IBM Concert host. The remote worker is located near the environment, collects the required data, and ingests it into IBM Concert using Concert's APIs.

In this lab, you will install IBM Concert Workflows as an add-on to your Concert installation.

## Prerequisite

- [x] IBM Concert must be installed

## Install IBM Concert Workflows (VM)

Concert Workflows installation requires k3s and helm.

### Install Prerequisites

1. Connect to the VM you reserved on TechZone

```bash
ssh itzuser@<VM ip address> -p 2223 -i /path/to/concert/sshkey/pem_ibmcloudvsi_download.pem
```

2. install k3s

> Offical documentation [k3s installation](https://www.ibm.com/docs/en/rapid-infra-auto/1.1.x?topic=planning-software-requirements#software_requirements__k3s__title__1)

```bash
cd $HOME
curl -sfL https://get.k3s.io | sudo INSTALL_K3S_VERSION=v1.29.2+k3s1 sh -s - --write-kubeconfig-mode 644 --disable traefik
```

3. Install Helm

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
sudo chmod 777 /usr/local/bin/helm
```

1. Specify Kubernetes configuration file

```bash
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc
source ~/.bashrc
```

### Install Concert workflow

> Official documentation: [Concert Worflow installation](https://www.ibm.com/docs/en/concert?topic=workflows-installing-concert-vm)

1. Connect to the VM you have created on Techzone in Lab0 and source environment variables

```bash
ssh itzuser@<VM ip address> -p 2223 -i /path/to/concert/sshkey/pem_ibmcloudvsi_download.pem
```

2. Get concert workflow installation files

```bash
source $HOME/env.sh
cd /mnt/concert
wget https://github.com/IBM/Concert/releases/download/v1.1.0/ibm-concert-std-workflows.tgz
tar xfz ibm-concert-std-workflows.tgz
```

3. Update environment variables

```bash
vi $HOME/env.sh
```

Update the values for the following keys:

- IBM_REG_PASS with your entitlement key (same as CONCERT_REGISTRY_PASSWORD value)
- VM_IP with your VM public IP address (in the format aaa.bbb.ccc.ddd)

Save the file (:wq) and source the $HOME/env.sh file to set environment variables

```bash
source $HOME/env.sh
```

3. Navigate to workflows folder

```bash
cd /mnt/concert/workflows
```

4. Launch concert-workflow installation

```bash
./bin/deploy-k8s --license-acceptance=y \
--instance-address=$VM_IP \
--concert-user=$CONCERT_USER \
--concert-url=$CONCERT_URL \
--c-api-key=$CONCERT_APIKEY
```

**IMPORTANT**: Wait until the end of the installation. Be patient, it can take up to 20 minutes. It's time for a coffee break !

5. Enable (Python function-as-a-service (FaaS) action blocks)

Insecure access to the internal registry must be enabled and registries.yaml must be defined under /etc/rancher/k3s:

```bash
sudo vi /etc/rancher/k3s/registries.yaml
```

Insert

```text
configs:
  "YOUR_VM_IP": 
    "tls": 
       insecure_skip_verify: true
```

Restart the Kubernetes service

```bash
sudo systemctl restart k3s
```

6. Check Concert Workflow installation
  
- From a browser, enter the URL of your concert instance (https://YOUR_VM_IP:12443) and log with your concert username and password.
- You should have now a **Workflows** menu
- Navigate to **Workflows->Manage** and check that a page is displayed successfully
- Navigate to **Administration->Integrations** and then in **Connections** tab
- Check that you have a connection named **CONCERT_WORKFLOWS**