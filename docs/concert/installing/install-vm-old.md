# Installing IBM Concert > VM Install

## Documentation

The following guide is derived from the [IBM Concert Documentation](https://www.ibm.com/docs/en/concert?topic=concert-deploying-virtual-machine-vm).  Please refer to the official IBM documentation for the latest up-to-date materials.

## Lab Environments

### Sizing

The recommended size for your Linux VM is a 16 CPU, 32GB RAM with 512GB for storage.

### TechZone Reservation

Use a RHEL9 VM on IBM Cloud.  This lab has been written and tested on the following TechZone Certified Base Image in the [IBM Cloud Environment](https://techzone.ibm.com/collection/tech-zone-certified-base-images/journey-ibm-cloud-environments).  Select this environment from this collection.

[![alt text](image-4.png)](https://techzone.ibm.com/my/reservations/create/62ab7e6c79c3250017398d8b)

In the reservation details, pick your Preferred Geography, and use the `8 vCPU | 32 GiB` VM Profile.  Altough this is does not meet the minimum requirements for a customer VM deployment, it will suffice for the purposes of this training exercise.

![alt text](image-7.png)

???+ warning "Bring Your Own VM"

    You can also bring your own Linux VM from your on-prem or cloud environment.  Ensure access to port 12443 is allowed to VM.  This lab exercise is based on RHEL9 VMs provisioned by the TechZone environment above, there may be changes that need to be accounted for when using other environments, but that is outside of the scope of this guide.

When your reservation is ready, you will receive an email from TechZone with a link to your reservation

![alt text](image-5.png)

On the reservation details, take note of the public IP address of your RHEL9 vm, as well as download the SSH key with the button provided

![alt text](image-6.png)

## Obtain IBM Entitlement Key

To obtain your IBM entitlement API key perform the following steps:

Log in to [Container software library on My IBM](https://myibm.ibm.com/products-services/containerlibrary) with the IBMid and password that are associated with the entitled software.
On the Entitlement keys tab, select Copy to copy the entitlement key to clipboard.

## Install Prerequirements

SSH into the IBM Concert VM with the public IP and SSH key obtained from the TechZone reservation details.  You'll need to change permissions on the SSH key first before you SSH.

???+ note "SSH"

    ```bash
    chmod 600 ~/Downloads/pem_ibmcloudvsi_download.pem
    ssh -i ~/Downloads/pem_ibmcloudvsi_download.pem -p 2223 itzuser@<PUBLIC IP>
    ```

!!! warning
    The installation steps need to be run on the Linux VM that will act as your IBM Concert server.  See the [Before you being](https://www.ibm.com/docs/en/concert?topic=vm-installing-concert#installing_on_vm__title__2) section in the IBM Concert documentation for VM requirements

### Prepare VM disk

To prepare the 500Gb disk, execute the following commands. Note: if you run into any issues, it may be helpful to execute the commands one at a time.

???+ note "Code"

    ```bash
    sudo -i
    lsblk
    mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/vdd
    blkid | grep /dev/vdd
    ```

Copy the UUID value output and store it in a safe place.

???+ note "Code"

    ```bash
    mkdir -p /mnt/concert
    cp /etc/fstab /etc/fstab.orig
    vi /etc/fstab
    ```

Insert this line at the end of the file: 

???+ note "Code"

    ```bash
    UUID=YOUR_UUID /mnt/concert ext4 discard,defaults,nofail 0 0
    ```

Replace YOUR_UUID by the one listed by the **blkid | grep /dev/vdd** command       
Save the file and continue with following commands:

???+ note "Code"

    ```bash
    mount -a
    systemctl daemon-reload
    lsblk
    chmod 777 /mnt/concert
    ```

???+ note "Required Utilities"

    === "podman "

        Docker Desktop is no longer allowed for IBM workstations, so we will use podman. Refer to the [Podman Install Instructions](https://podman-desktop.io/docs/installation) if you havent installed podman in your workstation.  The podman and docker commands are interchangeable throughout this guide.

    === "git"

        You can obtain the git CLI following the official [Git Documentation](https://github.com/git-guides/install-git#install-git-on-linux).


    === "wget"

        `wget` should be installed by default on your Linux system.  If its not, follow the install instructions on the official [GNU Wget](https://www.gnu.org/software/wget/) website.


    === "jq"

        `jq` should be installed by default on your Linux system.  If its not, follow the install instructions on the official [jq](https://jqlang.github.io/jq/download/) website.

    
    This lab is based on a RHEL9 VM in TechZone, to install all prereqs at once there, you can run the following command
    
    ```bash
    sudo dnf install -y podman git wget jq
    ```

## Provision watsonx.ai on TechZone

> Note: Concert require model ibm/granite-3-2-8b-instruct on watsonx.ai, so watsonx.ai must be provision in US
> 
### Watsonx.ai Provisioning

1. Navigate to [watsonx.ai on IBM Techzone](https://techzone.ibm.com/my/reservations/create/64b8490a564e190017b8f4eb)

2. Make a reservation for IBM watsonx.ai and choose **AMERICAS** as preferred geography (at the time we write this lab, only this region has the model used by IBM Concert inferences)

3. When the reservation is ready, you should receive a mail from **IBM Cloud** to join an account in IBM Cloud.

4. Open the mail, click the **join now** link and follow the instructions.

    ![drawing](../images/watsonxai-reservation.png){width=400}

5. When you have the IBM Cloud first screen, verify that you have the good account selected on the top bar

    ![drawing](../images/watsonx_accountid.png)

> Note: The IBM Cloud account selected should match the Cloud Account specified in the IBM TechZone reservation.
>
![drawing](../images/ibm-cloud-account-check.png){width=700}

### Create a watsonx project and get project ID

1. Select watsonx to from the burger menu on the left

    ![drawing](../images/select_watsonx.png){width=400}

2. Click **Launch** in the watsonx.ai tile

    ![drawing](../images/watsonxai_launch.png){width=400}

3. Scroll down in the page that appear and click **Create a sandbox project** in the Projects tile

    ![drawing](../images/watsonxai_create_project.png){width=700}

4. Select the sandbox that have been created (you may need to refresh the page)

    ![drawing](../images/watsonx_sandbox.png){width=700}

5. In **Manage** tab, copy the "Project ID" and store it in a safe place

    ![drawing](../images/watsonxai_get_projectid.png){width=700}

### Get API Key and service ID information

- From your techzone reservation screen, retrieve the APIKey and the service ID and store them in a safe place

    ![drawing](../images/watsonxai_reservation_details.png){width=600}

### API key - import the Service ID as part of the project

1. From your watsonx screen, in the **manage** tab, select **Access control** in the left menu

    ![drawing](../images/watsonxai_apikey1.png)

2. Click the **Add Collaborators** button and select **Add Access Group**.

    ![drawing](../images/watsonxai_apikey2.png)

3. Enter your Access Group name. The access Group Name is the IBM Cloud Service ID on your TechZone reservation page.

    ![drawing](../images/watsonxai_apikey3.png)

4. Select your group, give it admin right and click **Add** button

    ![drawing](../images/watsonxai_apikey4.png)

## Installing IBM Concert

!!! warning
    The installation steps need to be run on the Linux VM that will act as your IBM Concert server.  See the [Before you being](https://www.ibm.com/docs/en/concert?topic=vm-installing-concert#installing_on_vm__title__2) section in the IBM Concert documentation for VM requirements

### Download installation artifacts

???+ Code

    ```bash
    LATEST_TAG=$(curl --silent https://api.github.com/repos/IBM/Concert/releases/latest | jq -r .tag_name)
    wget https://github.com/IBM/Concert/releases/download/${LATEST_TAG}/ibm-concert-std.tgz
    tar -xf ibm-concert-std.tgz
    ```

### Set up environment variables

???+ Code

    ```bash
    export DOCKER_EXE=podman
    export CONCERT_REGISTRY=cp.icr.io/cp/concert
    export CONCERT_REGISTRY_USER=cp
    export CONCERT_REGISTRY_PASSWORD="eyJh..."  # (1)!
    ```

    1. Your IBM Entitlement Key

### Log in to the IBM Container Registry

??? note "Notes on Airgap Environments"

    If you're deploying on an AirGap environment, you will first need to mirror the images to your private container image registry.  You will need to [install skopeo](https://github.com/containers/skopeo/blob/main/install.md) on a workstation with access to both cp.icr.io and to the private image registry where images will be mirrored.


    ```bash
    export CONCERT_PUBLIC_REGISTRY=cp.icr.io/cp/concert
    export CONCERT_PUBLIC_REGISTRY_USER=cp
    export CONCERT_PUBLIC_REGISTRY_PASSWORD="eyJh..."  ## Your IBM Entitlement Key
    export CONCERT_REGISTRY=<YOUR PRIVATE REGISTRY>
    export CONCERT_REGISTRY_USER=<YOUR PRIVATE REGISTRY USERNAME>
    export CONCERT_REGISTRY_PASSWORD=<YOUR PRIVATE REGISTRY PASSWORD>
    export BUILD_VERSION=$(cat ibm-concert-std/etc/build_version)

    skopeo login ${CONCERT_PUBLIC_REGISTRY} -u ${CONCERT_PUBLIC_REGISTRY_USER} -p ${CONCERT_PUBLIC_REGISTRY_PASSWORD}
    skopeo login ${CONCERT_REGISTRY} -u ${CONCERT_REGISTRY_USER} -p ${CONCERT_REGISTRY_PASSWORD}
    IMAGES=(
        ibm-roja-sra
        ibm-roja-portal-gw
        roja-ui
        rojacore
        ibm-roja-compliance
        ibm-roja-pipeline
        ibm-roja-ingestion
        ibm-roja-py-utils
        ibm-roja-postgres
        ibm-roja-minio
    )
    for image in "${IMAGES[@]}"; do
        skopeo copy \
            docker://${CONCERT_PUBLIC_REGISTRY}/${image}:${BUILD_VERSION} \
            docker://${CONCERT_REGISTRY}/${image}:${BUILD_VERSION}
    done

    ```

    Once the images are mirrored, you can proceed with the installation steps.

???+ Code

    ```bash
    ${DOCKER_EXE} login ${CONCERT_REGISTRY} \
        --username=${CONCERT_REGISTRY_USER} --password=${CONCERT_REGISTRY_PASSWORD}
    ```

### Install IBM Concert

???+ code

    ```bash
    ibm-concert-std/bin/setup --license_acceptance=y \
        --registry=${CONCERT_REGISTRY} --runtime=${DOCKER_EXE} \
        --username=ibmconcert --password
    ```

If you don't specify a password with `--password=<somepassword>` the installation process will prompt you for one.

???+ success "output"

    ```{.bash .no-copy}
    $ ibm-concert-std/bin/setup --license_acceptance=y \
        --registry=${CONCERT_REGISTRY} --runtime=${DOCKER_EXE} \
        --username=ibmconcert --password
    Enter Password:
    ```

### Validate IBM Concert Install

Validate the IBM Concert install with the ibm-concert/bin/status script.  Ensure all services are `running`.

???+ code

    ```bash
    ibm-concert-std/bin/status
    ```

???+ success "output"

    ```{.bash .no-copy}
    $ ibm-concert-std/bin/status
    ibm-roja-minio : running
    ibm-roja-postgres : running
    ibm-roja-py-utils : running
    ibm-roja-ingestion : running
    ibm-roja-pipeline : running
    ibm-roja-compliance : running
    ibm-roja-portal-gw : running
    ibm-roja-core : running
    ibm-roja-ui : running
    ibm-roja-mgmt : running
    ibm-roja-sra : running

    URL:  https://your.server:12443
    ```

### Updating SSL Certificate on IBM Concert

The customer has installed a piece of vendor software that exposes a https service. IBM Concert generates a self-signed certificate and serves that.

When connecting from a client, like a browser:

- self-signed certs by unknown issuers will trigger warnings in the browser and even after you accept it, it will continue to mark it as "connection not secure"
- in certain browser side UI situations, caching to local storage is not done when untrusted connections are in use. Hence that also leads to performance problems.

As per security policies, most customers will not permit the use of such self-signed certs - but rather require certs that are signed by an official CA or by their own internal CA.
For example, w3.ibm.com cert is issued/signed by Digicert (an official CA), but many other internal IBM sites serve certs issued by "IBM INTERNAL INTERMEDIATE CA".

- our browsers and command lines trust the internal issues and external issuers - and hence permit access to such websites.

Certificates are issued to a specific host/domain. For example, if a customer installs Concert in a machine called "my-vm-03.us.example.com", then the certificate must match that host/domain name. Typically it is a "wildcard" cert issued to the domain - such as us.example.com.

- these certificate-key pair must be generated by a CA that is trusted by the clients, including browsers.
- these certificates are renewed and generally maintained by the customer, because only their CA can issue/sign such certs in the first place.

To replace the self-signed certificate for IBM Concert, place a copy of the certificate and private key in the `ibm-concert-std/localstorage/volumes/infra/tls/external-tls/` folder and restart the `ibm-roja-portal-gw` service.  In this example, we are creating a self-signed certificate key pair.  For deployments on customer's systems, obtain real certificates signed by your customer's CA for their environment.

???+ code

    ```bash
    OUT=ibm-concert-std/localstorage/volumes/infra/tls/external-tls
    sudo openssl req -newkey rsa:2048 -noenc -keyout $OUT/tls.key -out $OUT/tls.csr \
        -subj "/C=US/ST=North Carolina/L=Raleigh/O=IBM/OU=WW CS/CN=server.example"
    sudo openssl x509 -signkey $OUT/tls.key -in $OUT/tls.csr -req -days 365 -out $OUT/tls.crt
    sudo chmod 644 $OUT/tls*
    ./ibm-concert-std/bin/start_service ibm-roja-portal-gw
    ```
![alt text](image-3.png)

### Log in to IBM Concert

Log in to IBM Concert using `https://<VM_PUBLIC_IP>:12443` as your URL and the credentials from the previous steps.

### If running podman

On some linux distributions, when you log out of your shell, podman pods are destroyed.  You can persist them with the following command:

???+ code

    ```bash
    loginctl enable-linger $USER
    ```
