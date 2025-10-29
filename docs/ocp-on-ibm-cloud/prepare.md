---
Title: Prepare the Installation
hide:
    - toc
---

# Prepare the Installation

1. Using the SSH key log in as user `itzuser`.

2. Install the OpenShift installer.

3. Install the OpenShift command line interface (CLI).

4. Copy your pull secret from the [Red Hat Hybrid Cloud Console](https://console.redhat.com/openshift/install/pull-secret){target="_blank"} and save it in file `~/.pull-secret`.

5. Install the Cloud Credential Operator utility.

    !!! Tip
        To complete the steps documented below to obtain the ```ccoctl``` command. Administrator access to an OpenShift cluster is required.  This command is also available for download from Redhat.  [Download the ```ccoctl```command](https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/) 

    
    Extract the `ccoctl` application.
        
    ```sh
    RELEASE_IMAGE=$(openshift-install version | awk '/release image/ {print $3}')
    ```
    
    ```sh
    CCO_IMAGE=$(oc adm release info --image-for='cloud-credential-operator' ${RELEASE_IMAGE} -a ~/.pull-secret)
    ```
    
    ```sh
    oc image extract ${CCO_IMAGE} --file="/usr/bin/ccoctl" -a ~/.pull-secret
    ```
        
    Ensure the application is executable.
        
    ```sh
    chmod 775 ccoctl
    ```

    Copy it to a directory in `$PATH`.
    
    ```sh
    sudo install ccoctl /usr/local/bin
    ```

    Verify `ccoctl` is executable.
        
    ```sh
    ccoctl ibmcloud -h
    ```
        
    You should see output similar to the following:
        
    ```sh
    Creating/deleting cloud credentials objects for IBM Cloud

    Usage:
        ccoctl ibmcloud [command]

    Available Commands:
        create-service-id Create Service ID
        delete-service-id Delete Service ID
        refresh-keys      Refresh API Keys for the Service ID

    Flags:
        -h, --help   help for ibmcloud

    Use "ccoctl ibmcloud [command] --help" for more information about a command.
    ```

    Clean up.
    
    ```sh
    rm ccoctl
    ```

