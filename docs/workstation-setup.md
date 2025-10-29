---
hide:
    - toc
---

## Workstation Setup

=== "Openshift (MacOS/Linux)"

    ## Create accounts

    You'll need these accounts to use the Developer Tools environment.

    - [GitHub account](http://github.com){target="_blank"} (public, not enterprise): Create one if you do not have one already. If you have not logged in for a while, make sure your login is working.

    - [Red Hat Account](https://w3.ibm.com/w3publisher/redhat/nfr){target="_blank"}: Request a Red Hat Partner Subscription. Ensure to follow the instructions closely.

    <!--
    - [O'Reilly Account](https://learning.oreilly.com/home/){target="_blank"}: The account is free and easy to create.
    --->

    ## Run System Check Script

    Run the following command in your terminal to check which tools need to be installed.

    Using `wget`:

    ```
    wget -O - https://cloudbootcamp.dev/scripts/system-check.sh | sh
    ```

    Using `curl`:

    ```
    curl -s https://cloudbootcamp.dev/scripts/system-check.sh | sh
    ```

    After the script is run, make sure to install any missing tools.

    !!! Note
        Ignore the requirement for the Docker CLI, IBM Software Policies prohibit the use of the Docker CLI and encourages the use of Podman CLI instead.

    ## Install CLIs and tools

    The following is a list of desktop tools required to help with installation and development.

    - [Git Client](https://git-scm.com/downloads){target="_blank"}: Needs to be installed in your development operating system, it comes as standard for Mac OS

    - [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cloud-cli-getting-started){target="_blank"}: Required for management of IBM Cloud

    - [Podman Desktop](https://podman-desktop.io/downloads){target="_blank"}: Required for building and running container images.
        - Installed and running on your local machine

    - [Visual Studio Code](https://code.visualstudio.com/download){target="_blank"}: A popular code editor
        - You will be required to edit some files, having a good quality editor is always best practice
        - Enabling [launching VSCode from a terminal](https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line){target="_blank"}

    - [JDK 21](https://developer.ibm.com/languages/java/semeru-runtimes/downloads/){target="_blank"}: *Optional* installed on your local machine
        - Used for SpringBoot content

=== "Openshift (Windows)"

    ## Create accounts (Windows)

    You'll need these accounts to use the Developer Tools environment.

    - [GitHub account](http://github.com){target="_blank"} (public, not enterprise): Create one if you do not have one already. If you have not logged in for a while, make sure your login is working.

    - [Red Hat Account](https://w3.ibm.com/w3publisher/redhat/nfr){target="_blank"}: Request a Red Hat Partner Subscription. Ensure to follow the instructions closely.

    ## Cloud Native VM

    Use the [Cloud Native VM](https://github.com/csantanapr/vagrant-cloud-native#install){target="_blank"} it comes pre-installed with kubernetes and all cloud native CLIs.

    Is highly recommended for Windows users to use this VM.

    ## Install CLIs and tools (Windows)

    The following is a list of desktop tools required to help with installation and development.

    - [Git Client](https://git-scm.com/){target="_blank"}: Needs to be installed in your development operating system

    - [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cloud-cli-getting-started){target="_blank"}: Required for management of IBM Cloud

    - [Podman Desktop](https://podman-desktop.io/){target="_blank"}: Required for building and running container images.
        - Installed and running on your local machine

    - [Visual Studio Code](https://code.visualstudio.com/download){target="_blank"}: A popular code editor
        - You will be required to edit some files, having a good quality editor is always best practice
        - Enabling [launching VSCode from a terminal](https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line){target="_blank"}

    - [JDK 11](https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html){target="_blank"}: *Optional* installed on your local machine
        - Used for SpringBoot content

    <InlineNotification kind="warning">

    **Warning:** Make sure you have Cisco VPN turned off when using CRC.

    </InlineNotification>

=== "Kubernetes (MacOS/Linux)"
    ## Create accounts (MacOS/Linux)

    You'll need these accounts to use the Developer Tools environment.

    - [GitHub account](http://github.com){target="_blank"} (public, not enterprise): Create one if you do not have one already. If you have not logged in for a while, make sure your login is working.

    ## Run System Check Script

    Run the following command in your terminal to check which tools need to be installed.

    Using wget:
    ```
    wget -O - https://cloudbootcamp.dev/scripts/system-check.sh | sh
    ```

    Using curl:
    ```
    curl -s https://cloudbootcamp.dev/scripts/system-check.sh | sh
    ```

    After the script is run, make sure to install any missing tools.

    !!! Note
        Ignore the requirement for the Docker CLI, IBM Software Policies prohibit the use of the Docker CLI and encourages the use of Podman CLI instead.

    ## Install CLIs and tools (MacOS/Linux)

    The following is a list of desktop tools required to help with installation and development.

    - [Git Client](https://git-scm.com/){target="_blank"}: Needs to be installed in your development operating system, it comes as standard for Mac OS

    - [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cloud-cli-getting-started){target="_blank"}: Required for management of IBM Cloud.

    - [Podman Desktop](https://podman-desktop.io/){target="_blank"}: Required for building and running container images.
        - Installed and running on your local machine

    - [Visual Studio Code](https://code.visualstudio.com/download){target="_blank"}: A popular code editor
        - You will be required to edit some files, having a good quality editor is always best practice
        - Enabling [launching VSCode from a terminal](https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line)

    - [JDK 11](https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html){target="_blank"}: *Optional* installed on your local machine
        - Used for SpringBoot content

=== "Kubernetes (Windows)"

    ## Create accounts (Kubernetes (Windows))

    You'll need these accounts to use the Developer Tools environment.

    - [GitHub account](http://github.com){target="_blank"} (public, not enterprise): Create one if you do not have one already. If you have not logged in for a while, make sure your login is working.

    ## Cloud Native VM (Kubernetes (Windows))

    Use the [Cloud Native VM](https://github.com/csantanapr/vagrant-cloud-native#install){target="_blank"} it comes pre-installed with kubernetes and all cloud native CLIs.

    Is highly recommended for Windows users to use this VM.

    ## Install CLIs and tools (Kubernetes (Windows))

    The following is a list of desktop tools required to help with installation and development.

    - [Git Client](https://git-scm.com/){target="_blank"}: Needs to be installed in your development operating system, it comes as standard for Mac OS

    - [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cloud-cli-getting-started){target="_blank"}: Required for management of IBM Cloud

    - [Podman Desktop](https://podman-desktop.io/){target="_blank"}: Required for building and running container images.
        - Installed and running on your local machine

    - [Visual Studio Code](https://code.visualstudio.com/download){target="_blank"}: A popular code editor
        - You will be required to edit some files, having a good quality editor is always best practice
        - Enabling [launching VSCode from a terminal](https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line){target="_blank"}

    - [JDK 11](https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html){target="_blank"}: *Optional* installed on your local machine
        - Used for SpringBoot content

## Environment Setup

=== "OpenShift Local"

    Ensure OpenShift Local is installed. Check out the  [OpenShift Local](https://console.redhat.com/openshift/create/local){target="_blank"} Page.

    - Setup OpenShift Local

        ```bash
        crc setup
        ```

    - Start OpenShift Local

        ```bash
        crc start
        ```

    <InlineNotification kind="warning">
    **Warning:** Make sure you have Cisco VPN turned off when using OpenShift Local.
    </InlineNotification>

=== "MiniKube"

    Ensure Minikube is installed. Check out the [Minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Fx86-64%2Fstable%2Fhomebrew){target="_blank"} Page.

    - Verify your `driver` is set for `podman`

        ```bash
        minikube config set driver podman
        ```

    - Start minikube

        ```bash
        minikube start --driver=podman --container-runtime=cri-o
        ```

    - In case memory is not set, or need to increase set the memory and recreate the VM

        ```bash
        minikube config set memory 4096
        minikube delete
        minikube start --driver=podman --container-runtime=cri-o
        ```

    - Kubernetes should be v1.31+

        ```bash
        kubectl version
        ```

    <InlineNotification kind="warning">
    **Warning:** Make sure you have Cisco VPN turned off when using Minikube.
    </InlineNotification>
