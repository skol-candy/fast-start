# Intro to Concert Workflows

For this lab exercise, we will install Concert Workflows into an existing Concert deployment (VM deployment) and run our first basic workflow. For the latest documentation on how to achieve this process, consult the [IBM Concert documentation on Concert Workflows add-on](https://www.ibm.com/docs/en/concert?topic=concert-workflows-add).

## Objective

Concert Workflows is an embedded version of Rapid Infrastructure Automation in IBM Concert and is available as an add-on workflow automation service for on-premises deployments of Concert. 

The add-on embeds workflow definition and automation capabilities so you can define, manage, and automate workflows within the Concert UI.

The objective is to get data from an organization's environments and applications using low-code flows.  

By default, a flow is executed in a worker located on the IBM Concert host. A notion of remote workers exist in Concert Workflow to enable the ingestion of data into IBM Concert from environments that cannot be reached directly by the IBM Concert host. The remote worker is located near the environment, collects the required data, and ingests it into IBM Concert using Concert's APIs.

In this lab, you will install IBM Concert Workflows as an add-on to your Concert installation.

## Prerequisite

- [x] IBM Concert must be installed

## Installing Concert Workflows Prerequisites


Concert Workflows run as a containerized application in a Kubernetes cluster. As such, you will need to install a standalone K3s cluster and Helm on the VM where you installed IBM Concert.

!!! warning "Environment"
    These instructions have been tested from the Concert VM. Below is the command to SSH into the VM that was used in the previous labs.

    ```bash
    ssh -i ~/Downloads/pem_ibmcloudvsi_download.pem -p 2223 itzuser@<PUBLIC IP>
    ```
    Some changes may be required if you want to follow from another machine.

### Installing Rancher K3s

Install K3s from the command line.  You will need to disable its default ingress controller (traefik), so that port 443 is not in use.  SSH to your concert VM and execute the following commands:

???+ note "Installing Rancher K3s"

    ```bash
    cd $HOME
    curl -sfL https://get.k3s.io | sudo INSTALL_K3S_VERSION=v1.29.2+k3s1 sh -s - --write-kubeconfig-mode 644 --disable traefik
    ```

### Install Helm

???+ note "Add /usr/local/bin in your path"

    ```bash
    echo "export PATH=$PATH:/usr/local/bin" >> ~/.bashrc
    source ~/.bashrc
    ```

???+ note "install Helm"

    ```bash
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    sudo chmod 755 /usr/local/bin/helm
    ```

???+ success "output"

    ```{.bash .no-copy}
    $ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    $ chmod 700 get_helm.sh
    $ ./get_helm.sh
    ./get_helm.sh: line 138: /usr/local/bin/helm: Permission denied
    Helm v3.17.0 is available. Changing from version .
    Downloading https://get.helm.sh/helm-v3.17.0-linux-amd64.tar.gz
    Verifying checksum... Done.
    Preparing to install helm into /usr/local/bin
    helm installed into /usr/local/bin/helm
    $ sudo chmod 755 /usr/local/bin/helm
    ```

???+ note "Specify Kubernetes configuration file"

    ```bash
    echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc
    source ~/.bashrc
    ```


## Installing Concert Workflows on a VM

Download the IBM Concert Workflows installer and authenticate to the IBM Entitlement Registry.

!!! warning "Prerequisite"
    You will need an Entitlement key to install Workflows. This will be the same key that you fetched during the install. [Fetch your key or create one here](https://myibm.ibm.com/products-services/containerlibrary){:target="_blank"}.


Source your environment variables and change directory to your install folder:

```bash
source $HOME/env.sh
cd /mnt/concert
```
???+ note "Downloading Installer"

    ```bash
    wget https://github.com/IBM/Concert/releases/download/v1.1.0/ibm-concert-std-workflows.tgz
    tar xfz ibm-concert-std-workflows.tgz
    ```

???+ success "output"

    ```{.bash .nocopy}
    $ wget https://github.com/IBM/Concert/releases/download/v1.1.0/ibm-concert-std-workflows.tgz
    --2025-01-29 14:39:44--  https://github.com/IBM/Concert/releases/download/v1.1.0/ibm-concert-std-workflows.tgz
    Resolving github.com (github.com)... 140.82.112.4
    Connecting to github.com (github.com)|140.82.112.4|:443... connected.
    HTTP request sent, awaiting response... 302 Found
    Location: https://objects.githubusercontent.com/github-production-release-asset-2e65be/815253674/d37113aa-93c4-4635-850a-6d478b44bb77?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20250129%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250129T143945Z&X-Amz-Expires=300&X-Amz-Signature=88b0e3843a4642a3249d744526bfbb580d50f551240dcd148aded92c384305a6&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3Dibm-concert-std-workflows.tgz&response-content-type=application%2Foctet-stream [following]
    --2025-01-29 14:39:45--  https://objects.githubusercontent.com/github-production-release-asset-2e65be/815253674/d37113aa-93c4-4635-850a-6d478b44bb77?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20250129%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250129T143945Z&X-Amz-Expires=300&X-Amz-Signature=88b0e3843a4642a3249d744526bfbb580d50f551240dcd148aded92c384305a6&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3Dibm-concert-std-workflows.tgz&response-content-type=application%2Foctet-stream
    Resolving objects.githubusercontent.com (objects.githubusercontent.com)... 185.199.110.133, 185.199.111.133, 185.199.108.133, ...
    Connecting to objects.githubusercontent.com (objects.githubusercontent.com)|185.199.110.133|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 40468 (40K) [application/octet-stream]
    Saving to: ‘ibm-concert-std-workflows.tgz’

    ibm-concert-std-workflows.tgz           100%[===============================================================================>]  39.52K  --.-KB/s    in 0.001s

    2025-01-29 14:39:45 (41.7 MB/s) - ‘ibm-concert-std-workflows.tgz’ saved [40468/40468]

    $ tar xfz ibm-concert-std-workflows.tgz
    ```

???+ note "Update environment variables"

    ```bash
    vi $HOME/env.sh
    ```

Update the values for the following keys:

- IBM_REG_PASS with your entitlement key (same as CONCERT_REGISTRY_PASSWORD value)
- VM_IP with your VM public IP address (in the format aaa.bbb.ccc.ddd)

???+ note "Save the file (:wq) and source the $HOME/env.sh file to set environment variables"

    ```bash
    source $HOME/env.sh
    ```

???+ note "Navigate to workflows folder"

    ```bash
    cd /mnt/concert/workflows
    ```

???+ note "Launch Workflows installation"

    ```bash
    ./bin/deploy-k8s --license-acceptance=y \
    --instance-address=$VM_IP \
    --concert-user=$CONCERT_USER \
    --concert-url=$CONCERT_URL \
    --c-api-key=$CONCERT_APIKEY
    ```

**IMPORTANT**: Wait until the end of the installation. Be patient, it can take up to 20 minutes. It's time for a coffee break!

???+ code "Enable (Python function-as-a-service (FaaS) action blocks)"

    Insecure access to the internal registry must be enabled and registries.yaml must be defined under /etc/rancher/k3s:

    ```bash
    sudo vi /etc/rancher/k3s/registries.yaml
    ```

    Insert these lines into the registries.yaml

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

???+ success "Check Concert Workflows installation"
  
    - [ ] From a browser, enter the URL of your Concert instance (https://YOUR_VM_IP:12443) and log with your Concert username and password.
    - [ ] You should have now a **Workflows** menu
    - [ ] Navigate to **Workflows->Manage** and check that a page is displayed successfully
    - [ ] Navigate to **Administration->Integrations** and then in **Connections** tab
    - [ ] Check that you have a connection named **CONCERT_WORKFLOWS**


## Creating your first Workflow

Back in your browser, refresh the Concert home page. You should now see a Workflow tab at the top of your Concert instance. Select `Manage`:

![Concert Workflows](./images/concert-manage-workflows.png)

Select `Create Workflow`, give your workflow a name, and click `Select Template`. Set the template to `HTTP Template`:

![HTTP Template](./images/concert-http-template.png)

Create your workflow and run it using the `Run` button. You should see the workflow make a request to `example.com`!

!!! success "Workflow Lab Complete"
    Congratulations, you have successfully completed the Workflow install lab.
    
# Acknowledgements

This lab was based on: https://pages.github.ibm.com/cs-tel-ibm-concert/training/module3/concert-workflows/#installing-concert-workflows-on-a-vm and https://github.ibm.com/concert-bootcamp/ibm-concert-lab-guide/blob/main/labs/Lab2-concert-workflow-installation.md
