---
Title: Prepare the Installation
hide:
    - toc
---

# Prepare the Installation

Before proceeding with the installation, it is essential to complete some critical setup tasks on the bastion host to ensure a smooth and successful deployment.
To ensure a smooth installation process, it is essential that we take care of a few crucial preparations beforehand. Specifically, we need to set up our environment on the bastion host before we begin the installation.

## Verify DNS records

To guarantee seamless operation of OpenShift Container Platform (OCP), a fully functional DNS server must be present in your environment. Fortunately, our OCP Gymnasium environment has a pre-configured DNS server with populated entries for the virtual IP addresses of both the API and Ingress components. To confirm that DNS is functioning correctly:

1. Log in to the bastion host using a terminal.

2. Verify name resolution by checking both the forward and reverse lookups of the API virtual IP address:
    
    ```sh
    dig +short api.ocpinstall.gym.lan -x 192.168.252.3
    ```
    
    ```{.text .no-copy title="Expected output"}
    192.168.252.3
    api.ocpinstall.gym.lan
    ```

3. Verify the name lookup for the Ingress virtual IP address:
    
    ```sh
    dig +short foo.apps.ocpinstall.gym.lan
    ```
    
    ```{.text .no-copy title="Expected output"}
    192.168.252.4
    ```

## Enabling vCenter CA Certificate Trust

Before proceeding with the installation of an OpenShift Container Platform (OCP) cluster, you need to ensure that your system trusts the root Certificate Authority (CA) of your vCenter. This is crucial because the OCP installation program relies on access to the vCenter's API.

To complete this task, follow these steps:

1. Set the `VCENTER_HOSTNAME` environment variable.
   
    ```sh
    export VCENTER_HOSTNAME="your_vsphere_hostname"
    ```

    Extract `your_vsphere_hostname` from the environment details (`vCenter Console URL`).

2. Download the vCenter root CA certificates.
   
    ```sh
    curl -kL https://${VCENTER_HOSTNAME}/certs/download.zip -o download.zip
    ```
    ``` {.text .no-copy title="Example with your hostname"}
    curl -kL https://ocpgym-vc.techzone.ibm.local/certs/download.zip -o download.zip
    ```

3. Extract the certificates.
   
    ```sh
    unzip download.zip
    ```

4. Add the certificates to the CA trust store.
   
    ```sh
    sudo cp -R certs/lin/* /etc/pki/ca-trust/source/anchors/
    ```

5. Update the CA trust store.
   
    ```sh
    sudo update-ca-trust extract
    ```

6. Clean up.
   
    ```sh
    rm -fr download.zip certs/
    ```

## Installing the OpenShift Installer

The version of the OpenShift installer you download will determine the initial version of your OpenShift cluster.

To complete this task, follow these steps:

1. Set the `OI_VERSION` environment variable
   
    ```sh
    export OI_VERSION="4.18.22"
    ```

2. Download the OpenShift Installer

    ```sh
    curl -Lo openshift-install-linux.tar.gz \
    https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OI_VERSION}/openshift-install-linux.tar.gz
    ```

3. Extract the installer

    ```sh
    tar xf openshift-install-linux.tar.gz openshift-install
    ```

4. Install the OpenShift Installer

    ```sh
    sudo install openshift-install /usr/local/bin
    ```

5. Verify the installer is executable

    ```sh
    openshift-install version
    ```

    ```{.text .no-copy title="Output similar to the following"}
    openshift-install 4.18.22
    built from commit 9094202399a3ac62bbdc22f755c6995545f3089e
    release image quay.io/openshift-release-dev/ocp-release@sha256:16078b671c7f5490a2136f2cd9a694d48bb38af1280ef9e2ae9ce28af075cca5
    release architecture amd64
    ```

6. Clean up

    ```sh
    rm openshift-install-linux.tar.gz openshift-install
    ```

## Installing the OpenShift CLI

The OpenShift CLI is a crucial tool for managing your cluster. To ensure you have the latest version, follow these steps:

1. Set the `OC_VERSION` environment variable
    
    ```sh
    export OC_VERSION="4.18.22"
    ```

2. Download the OpenShift CLI

    ```sh
    curl -Lo openshift-client-linux.tar.gz \
    https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux-amd64-rhel8.tar.gz
    ```

3. Extract the CLI.
    
    ```sh
    tar xf openshift-client-linux.tar.gz oc
    ```

4. Install the OpenShift CLI

    ```sh
    sudo install oc /usr/local/bin
    ```

5. Verify the CLI is executable.
    
    ```sh
    oc version
    ```
    
    ```{.text .no-copy title="Output similar to the following"}
    Client Version: 4.18.22
    Kustomize Version: v5.4.2
    ```
    
6. Clean up.
    
    ```sh
    rm openshift-client-linux.tar.gz oc
    ```

## Generating a Key Pair for Cluster Node SSH Access

During an OpenShift Container Platform installation, you can provide an SSH public key to the installation program. The key is passed to the Red Hat Enterprise Linux CoreOS (RHCOS) nodes through their Ignition config files and is used to authenticate SSH access to the nodes. After the key is passed to the nodes, you can use the key pair to SSH in to the RHCOS nodes as the user core.

If you want to SSH in to your cluster nodes to perform installation debugging or disaster recovery, you must provide the SSH public key during the installation process. The openshift-install gather command also requires the SSH public key to be in place on the cluster nodes.


```sh
ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa
```

```sh {.text .no-copy title="Output similar to the following"}
Generating public/private ed25519 key pair.
Your identification has been saved in /home/admin/.ssh/id_rsa.
Your public key has been saved in /home/admin/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:sOpiEXVXB5TVc0jCUVlW89qcuv/Gb9DhUVs3yf2BAc8 admin@bastion
The key's randomart image is:
+--[ED25519 256]--+
|         o+****=B|
|    . . . ..+o=*O|
|   . ...     E oX|
|  .    o       Bo|
|   .  . S     oo=|
|  .  .        o..|
|   ..        . o |
|  o.          . +|
| . ..        ..+=|
+----[SHA256]-----+
```
