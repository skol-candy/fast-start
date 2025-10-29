---
title: Create Red Hat CoreOS Custom Image
hide:
    - toc
---

## Configure the CoreOS ISO Maker in the online bastion 

1. Exit the offline bastion:

    ```{ .text .copy title="[root@bastion ~]"}
    exit
    ```

1. Access the online bastion:

    ```{ .text .copy title="[student laptop]"}
    ssh root@192.168.252.22
    ```

1. Change to the route where the CoreOS ISO Maker is

    ```{ .text .copy title="[root@bastiononline ~]"}
    cd /root/Coreos-iso-maker/coreos-iso-maker/
    ```

In the file `group_vars/all.yml` the following configuration is defined:

|Variable	|Definition	|Value|
|-----------|-----------|-----|
|gateway	|default IP router	|192.168.252.1|
|netmask	|default netmask	|255.255.255.0|
|interface	|NIC device name	|ens192|
|dns	|dns server. This can be done as a list. Don't add more than 3	|192.168.252.23|
|webserver_url	|webserver that holds the Ignition file	|bastion.ocp4.platformengineers.xyz|
|webserver_port	|webserver port for the webserver above	|80|
|webserver_ignition_path	|Ignition subpath in http server	|ign|
|install_drive	|drive to install RHCOS on	|sda|
|ocp_version	|Full CoreOS version you are going for	|4.16.3|
|is_checksum	|sha256 checksum of the ISO. Got it from https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.16/4.16.3/sha256sum.txt	|b4b2bbe4462258e9d30cab2f4a9d94b45960bc03ffa578be3400b9cbcac4912c|
|iso_name	|Name of the ISO to download. Makes certain assumptions that should be verified	|rhcos-{{ocp_version }}-x86_64-live.x86_64.iso|
|rhcos_bios	|Name of the BIOS image to boot from. This is how the file is named on your webserver. Make certain assumptions that should be verified	|rhcos-{{ocp_version }}-x86_64-metal.x86_64.raw.gz|
|arch	|The CPU Architecture type. Must be one of x86_64 (default) or ppc64le |x86_64|

1. Open the `group_vars/all.yml` file:

    ```{ .text .copy title="[root@bastiononline core-iso-maker]"}
    vi group_vars/all.yml
    ```

1. Make sure it looks like below:

    !!! tip
        Although you can read `ocp_version` in the file below, it refers to the RedHat CoreOS version you are getting installed (4.16.3). The OpenShift version that will eventually get installed remains 4.16.9 which is the OpentShift install binaries, CLI and container images version we have downloaded previously in this tutorial.

    ```{ .yaml .copy title="all.yml"}
    ---
    # If only one network interface
    gateway: 192.168.252.1
    netmask: 255.255.255.0
    # VMWare default ens192
    # KVM default ens3
    # Libvirt default enp1s0
    # Intel NUC default eno1
    interface: ens192

    dns:
    - 192.168.252.23

    webserver_url: bastion.ocp4.platformengineers.xyz
    webserver_port: 8080
    # Ignition subpath in http server (optionnal, defaults to nothing)
    webserver_ignition_path: /ign
    # Path to download master ignition file will be
    # http://192.168.1.20:8080/ignition/master.ign

    # Drive to install RHCOS
    # Libvirt - can be vda
    install_drive: sda

    # Timeout for selection menu during first boot
    # '-1' for infinite timeout. Default '10'
    boot_timeout: -1

    # Chose the binary architecture
    # x86_64 or ppc64le
    arch: "x86_64"

    ocp_version: 4.16.3
    #iso_checksum: d15bd7ae942573eece34ba9c59e110e360f15608f36e9b83ab9f2372d235bef2
    iso_checksum: b4b2bbe4462258e9d30cab2f4a9d94b45960bc03ffa578be3400b9cbcac4912c
    #iso_checksum_ppc64: ff3ef20a0c4c29022f52ad932278b9040739dc48f4062411b5a3255af863c95e
    iso_name: rhcos-{{ ocp_version }}-x86_64-live.x86_64.iso
    #iso_name_ppc64: rhcos-{{ ocp_version }}-ppc64le-installer.ppc64le.iso
    rhcos_bios: rhcos-{{ ocp_version }}-x86_64-metal.x86_64.raw.gz
    ...
    ```

    !!! tip
        Dont forget to set `boot_timeout: -1` so that you have no time limit when asked for the machine type at boot time

The machines of the OpenShift cluster are defined in the `inventory.yml` file.

1. Open the `inventory.yml` file:

    ```{ .text .copy title="[root@bastiononline core-iso-maker]"}
    vi inventory.yml
    ```

1. Make sure the file looks like below:

    ```{ .yaml .copy title="inventory.yml"}
    --- 
    all:
      children:
        bootstrap:
          hosts: 
            bootstrap.ocp4.platformengineers.xyz:
              dhcp: false
              ipv4: 192.168.252.3
        controlplane:
          hosts:
            controlplane01.ocp4.platformengineers.xyz: 
              dhcp: false
              ipv4: 192.168.252.4
            controlplane02.ocp4.platformengineers.xyz: 
              dhcp: false
              ipv4: 192.168.252.5
            controlplane03.ocp4.platformengineers.xyz: 
              dhcp: false
              ipv4: 192.168.252.6
        compute:
          hosts:
            infra01.ocp4.platformengineers.xyz: 
              dhcp: false
              ipv4: 192.168.252.7
            infra02.ocp4.platformengineers.xyz: 
              dhcp: false
              ipv4: 192.168.252.8
            infra03.ocp4.platformengineers.xyz: 
              dhcp: false
              ipv4: 192.168.252.9
            compute01.ocp4.platformengineers.xyz: 
              dhcp: false
              ipv4: 192.168.252.10                
            compute02.ocp4.platformengineers.xyz: 
              dhcp: false
              ipv4: 192.168.252.11
            compute03.ocp4.platformengineers.xyz: 
              dhcp: false
              ipv4: 192.168.252.12
            storage01.ocp4.platformengineers.xyz: 
              dhcp: false
              ipv4: 192.168.252.13                
            storage02.ocp4.platformengineers.xyz: 
              dhcp: false
              ipv4: 192.168.252.14
            storage03.ocp4.platformengineers.xyz: 
              dhcp: false
              ipv4: 192.168.252.15 
    ...
    ```

1. Copy the RHCOS ISO live image and the metal raw file for the OpenShift version we are going to install to the temporary directory:

    ```{ .text .copy title="[root@bastiononline core-iso-maker]"}
    cp /root/registry/downloads/images/rhcos-4.16.3-x86_64-live.x86_64.iso /tmp
    cp /root/registry/downloads/images/rhcos-4.16.3-x86_64-metal.x86_64.raw.gz /tmp
    ```

1. Run the following Ansible playbook to create the ISO image:

    ```{ .text .copy title="[root@bastiononline core-iso-maker]"}
    ansible-playbook playbook-single.yml
    ```

    ```{ .text .no-copy title="Output"}
    [...]
    PLAY RECAP *********************************************************************************************************************
    bootstrap.ocp4.platformengineers.xyz : ok=4    changed=2    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
    infra01.ocp4.platformengineers.xyz : ok=4    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
    infra02.ocp4.platformengineers.xyz : ok=4    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
    infra03.ocp4.platformengineers.xyz : ok=4    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
    localhost                  : ok=7    changed=4    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
    controlplane01.ocp4.platformengineers.xyz : ok=4    changed=2    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
    controlplane02.ocp4.platformengineers.xyz : ok=4    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
    controlplane03.ocp4.platformengineers.xyz : ok=4    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
    compute01.ocp4.platformengineers.xyz : ok=4    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
    compute02.ocp4.platformengineers.xyz : ok=4    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
    compute03.ocp4.platformengineers.xyz : ok=4    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
    storage01.ocp4.platformengineers.xyz : ok=4    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
    storage02.ocp4.platformengineers.xyz : ok=4    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
    storage03.ocp4.platformengineers.xyz : ok=4    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
    ```

Copy the resulting ISO files to the image directory `/root/registry/downloads/images/` and upload the `rhcos-install-cluster.iso` file to the vCenter datastore to be used as an ISO to install the OpenShift cluster master and worker nodes.

1. List the ISO files in the `/tmp` folder

    ```{ .text .copy title="[root@bastiononline core-iso-maker]"}
    ls -lart /tmp/*iso
    ```

    ```{ .sh .no-copy title="Output"}
    -rw-r--r-- 1 root root 1220542464 Oct 27 11:58 /tmp/rhcos-4.16.3-x86_64-live.x86_64.iso
    -rw-r--r-- 1 root root 1220235264 Oct 27 11:59 /tmp/rhcos-install-cluster.iso
    ```

1. Move original ISO files to their own folder:

    ```{ .text .copy title="[root@bastiononline core-iso-maker]"}
    mkdir /root/registry/downloads/images/orig
    mv /root/registry/downloads/images/rhcos-4.16.3-x86_64-* /root/registry/downloads/images/orig/
    cp /tmp/*.iso /root/registry/downloads/images/
    chmod 777 /tmp/rhcos-install-cluster.iso
    ```

1. SCP the final ISO file into the Guacamole VM.

    !!! tip
        The following command is **executed from within the Guacamole VM**. That is, you need to connect to the vCenter, launch the web console for the Guacamole VM, open a terminal window in there and execute the command below. To upload ISO files, as we did in the section [Guacamole VM](7-guacamolevm.md) at the beginning of the course for uploading the RHEL 8.7 OS ISO file for the online bastion and offline bastion, we must do it from the Guacamole VM because the VPN bandwidth is very limited.

    !!! tip "Extra tip for free ;-)"
        To get the `@` symbol typed on the terminal, because the layout of the keyboard set up in the Guacamole VM might very well be different than your laptops keyboard layout, we strongly recommened you open the browser and google "at symbol". From the results displayed by Google, copy the `@` symbol and paste it in your terminal

    ```{ .text .copy title="[Guacamole VM]"}
    scp root@192.168.252.22:/tmp/rhcos-install-cluster.iso ./
    ```

Once you have copied the ISO file from the online bastion, you must add the file to vCenter into a datastore:

![69](images/airgap-4-12/69.png){: style="max-height:400px"}
