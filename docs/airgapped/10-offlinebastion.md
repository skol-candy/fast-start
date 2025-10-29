---
title: Configure Offline Bastion
hide:
    - toc
---

## Disable SELINUX in the offline bastion

In order to perform the correct configuration of the Bastion node, it is recommended that the `SELINUX` is deactivated first.

!!! note
    It is not strictly necessary that Linux Security is deactivated in order to install OpenShift. However, it is recommended as it eases the installation. Otherwise, you would need to open several specific ports and add rules to the firewall so that the needed communication is allowed.

1. Access the offline bastion:

    ```{ .text .copy title="[student laptop]"}
    ssh root@192.168.252.23
    ```

1. Open the `/etc/selinux/config` to disable the `SELINUX`

    ```{ .bash .copy title="[root@localhost ~]"}
    vi /etc/selinux/config
    ```

1. Make sure your file looks like below, where the highlighted line has been modified:

    ```{ .properties .no-copy title="/etc/selinux/config" hl_lines="6"}
    # This file controls the state of SELinux on the system.
    # SELINUX= can take one of these three values:
    # enforcing - SELinux security policy is enforced.
    # permissive - SELinux prints warnings instead of enforcing.
    # disabled - No SELinux policy is loaded.
    SELINUX=disabled
    # SELINUXTYPE= can take one of these three values:
    # targeted - Targeted processes are protected,
    # minimum - Modification of targeted policy. Only selected processes are protected.
    # mls - Multi Level Security protection. SELINUXTYPE=targeted
    ```

    Once the change is made, save and exit the file (`esc` and `:wq`) 
    
1. Restart the server for the changes to take effect.

    ```{ .text .copy title="[root@localhost ~]"}
    init 6
    ```

## Disable the firewall in the offline bastion

Also, and since it is an internal network, the firewall of the machine is deactivated

1. Access the offline bastion:

    ```{ .text .copy title="[student laptop]"}
    ssh root@192.168.252.23
    ```

1. Stop the firewall:

    ```{ .text .copy title="[root@localhost ~]"}
    systemctl stop firewalld
    systemctl disable firewalld
    ```

    ```{ .text .no-copy title="Output"}
    Removed /etc/systemd/system/multi-user.target.wants/firewalld.service. 
    Removed /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
    ```

## Configure the hostname for the offline bastion

We need to change the online bastion machine's default hostname as we will be referring to this machine from the DNS, load balancer, etc using a different hostname.

1. Edit the hostname of the machine

    ```{ .text .copy title="[root@localhost ~]"}
    vi /etc/hostname
    ```

    set the hostname to `bastion.ocp4.platformengineers.xyz`

1. Once the change has been made, restart the server for it to take effect.

    ```{ .text .copy title="[root@localhost ~]"}
    init 6
    ```

1. Access the offline bastion again:

    ```{ .text .copy title="[student laptop]"}
    ssh root@192.168.252.23
    ```

1. Check the hostname was successfully modified:

    ```{ .text .copy title="[root@bastion ~]"}
    ping $HOSTNAME
    ```

    You should see similar output as below:

    ```{ .text .no-copy title="Output"}
    PING bastion.ocp4.platformengineers.xyz(bastion.ocp4.platformengineers.xyz (fe80::250:56ff:fe8a:23c2%ens192)) 56 data bytes
    64 bytes from bastion.ocp4.platformengineers.xyz (fe80::250:56ff:fe8a:23c2%ens192): icmp_seq=1 ttl=64 time=0.040 ms
    64 bytes from bastion.ocp4.platformengineers.xyz (fe80::250:56ff:fe8a:23c2%ens192): icmp_seq=2 ttl=64 time=0.055 ms
    64 bytes from bastion.ocp4.platformengineers.xyz (fe80::250:56ff:fe8a:23c2%ens192): icmp_seq=3 ttl=64 time=0.047 ms
    ```

1. Finish the ping command with `ctrl+c`

## Install required Red Hat packages in the offline bastion

For the installation of rpm packages on the offline machine, the RHEL 8.7 OS ISO file that created the VM from will help us. 

Repeat the steps taken on the onlinebastion for creating a offline repository from the RHEL 8.7 ISO

1. Make sure that, in the vCenter, the offline bastion has the CD/DVD drive as connected:

    ![29](images/airgap-4-12/29.png){: style="max-height:100px"}

Once the offline repository is has been created and enabled, the required packages are installed with the **yum** utility.

The following packages have been installed on the online bastion server. Some packages may not be used during the execution of online commands, but they are installed so that the "online" and "offline" bastion settings are as identical as possible.

```{ .text .copy title="[root@bastion ~]"}
yum install -y podman \
                    jq openssl httpd-tools curl wget telnet nfs-utils \
                    httpd.x86_64 \
                    bind bind-utils rsync mkisofs haproxy
```

```{ .text .no-copy title="Output"}
Updating Subscription Management repositories.
Unable to read consumer identity

This system is not registered with an entitlement server. You can use subscription-manager to register.

Red Hat Enterprise Linux 8.7.0 Base                                                                                          40 MB/s | 2.4 MB     00:00    
Red Hat Enterprise Linux 8.7.0 App                                                                                           53 MB/s | 7.8 MB     00:00    
Package openssl-1:1.1.1k-7.el8_6.x86_64 is already installed.
Package curl-7.61.1-25.el8.x86_64 is already installed.
Dependencies resolved.
============================================================================================================================================================
 Package                                   Architecture        Version                                                  Repository                     Size
============================================================================================================================================================
Installing:
 bind                                      x86_64              32:9.11.36-5.el8                                         InstallMediaApps              2.1 M
 bind-utils                                x86_64              32:9.11.36-5.el8                                         InstallMediaApps              452 k
 genisoimage                               x86_64              1.1.11-39.el8                                            InstallMediaApps              316 k
 httpd                                     x86_64              2.4.37-51.module+el8.7.0+16050+02173b8e                  InstallMediaApps              1.4 M
 httpd-tools                               x86_64              2.4.37-51.module+el8.7.0+16050+02173b8e                  InstallMediaApps              109 k
 jq                                        x86_64              1.6-3.el8                                                InstallMediaApps              202 k
 nfs-utils                                 x86_64              1:2.3.3-57.el8                                           InstallMediaBase              515 k
 podman                                    x86_64              3:4.2.0-1.module+el8.7.0+16772+33343656                  InstallMediaApps               12 M
 rsync                                     x86_64              3.1.3-19.el8                                             InstallMediaBase              410 k
 telnet                                    x86_64              1:0.17-76.el8                                            InstallMediaApps               72 k
 wget                                      x86_64              1.19.5-10.el8                                            InstallMediaApps              734 k
...
...
Complete!
```

## Copy downloaded artifacts from online bastion to offline bastion

1. Create a directory for the private image registry in the offline bastion

    ```{ .text .copy title="[root@bastion ~]"}
    mkdir /root/registry
    cd registry/
    ```

1. Create the necessary directories for such private image registry.

    ```{ .text .copy title="[root@bastion registry]"}
    mkdir auth certs data downloads
    cd downloads/
    ```

    ```{ .text .copy title="[root@bastion downloads]"}
    mkdir images tools secrets
    ```

    The folder structure that should have got created should look like this:

    ```{ .test .no-copy title="Directory structure"}
    /root
    `-- registry
        |-- auth
        |-- certs
        |-- data
        `-- downloads
            |-- images
            |-- secrets
            `-- tools
    ```

1. Exit the offline bastion

    ```{ .text .copy title="[root@bastion downloads]"}
    exit
    ```

1. Access the online bastion:

    ```{ .text .copy title="[student laptop]"}
    ssh root@192.168.252.22
    ```

1. Verify that the `.tar` files have been generated.

    ```{ .text .copy title="[root@bastiononline ~]"}
    cd /root/registry/data
    ```

    ```{ .text .copy title="[root@bastiononline data]"}
    ls -hla
    ```

    ```{ .sh .no-copy title="Output"}
    total 61G
    drwxr-xr-x 4 root root 4.0K Sep  8 17:28 .
    drwxr-xr-x 6 root root  110 Sep  8 17:08 ..
    -rw-r--r-- 1 root root 4.0G Sep  8 17:23 mirror_seq1_000000.tar
    -rw-r--r-- 1 root root 3.9G Sep  8 17:23 mirror_seq1_000001.tar
    -rw-r--r-- 1 root root 3.6G Sep  8 17:24 mirror_seq1_000002.tar
    -rw-r--r-- 1 root root 4.0G Sep  8 17:24 mirror_seq1_000003.tar
    -rw-r--r-- 1 root root 4.0G Sep  8 17:24 mirror_seq1_000004.tar
    -rw-r--r-- 1 root root 3.4G Sep  8 17:25 mirror_seq1_000005.tar
    -rw-r--r-- 1 root root 3.7G Sep  8 17:25 mirror_seq1_000006.tar
    -rw-r--r-- 1 root root 3.5G Sep  8 17:25 mirror_seq1_000007.tar
    -rw-r--r-- 1 root root 4.0G Sep  8 17:26 mirror_seq1_000008.tar
    -rw-r--r-- 1 root root 4.0G Sep  8 17:26 mirror_seq1_000009.tar
    -rw-r--r-- 1 root root 4.0G Sep  8 17:26 mirror_seq1_000010.tar
    -rw-r--r-- 1 root root 3.9G Sep  8 17:27 mirror_seq1_000011.tar
    -rw-r--r-- 1 root root 4.0G Sep  8 17:27 mirror_seq1_000012.tar
    -rw-r--r-- 1 root root 3.9G Sep  8 17:27 mirror_seq1_000013.tar
    -rw-r--r-- 1 root root 3.9G Sep  8 17:28 mirror_seq1_000014.tar
    -rw-r--r-- 1 root root 3.8G Sep  8 17:28 mirror_seq1_000015.tar
    drwxr-xr-x 2 root root    6 Sep  8 17:28 oc-mirror-workspace
    drwxr-x--- 2 root root   28 Sep  8 17:28 publish
    ```

2. Copy the tar files to the offline bastion using the scp command as there is currently network connectivity between the online bastion and the offline bastion.
   
    !!! note
    In a customer air-gapped environment, you would likely need to copy the data to the offline bastion via another method, a USB drive for example.

    ```{ .text .copy title="[root@bastiononline data]"}
    scp *.tar root@192.168.252.23:/root/registry/data
    ```

    ```{ .text .no-copy title="Output"}
    mirror_seq1_000000tar   100% 4090MB 167.6MB/s   00:24
    mirror_seq1_000001.tar  100% 3922MB 165.8MB/s   00:23
    mirror_seq1_000002.tar  100% 3673MB 167.1MB/s   00:21
    mirror_seq1_000003.tar  100% 4093MB 168.0MB/s   00:24
    mirror_seq1_000004.tar  100% 4061MB 169.4MB/s   00:23
    mirror_seq1_000005.tar  100% 3391MB 165.0MB/s   00:20
    mirror_seq1_000006.tar  100% 3698MB 128.1MB/s   00:28
    mirror_seq1_000007.tar  100% 3567MB 168.4MB/s   00:21
    mirror_seq1_000008.tar  100% 4083MB 124.5MB/s   00:32
    mirror_seq1_000009.tar  100% 3893MB 165.2MB/s   00:23
    mirror_seq1_000010.tar  100% 4086MB 158.6MB/s   00:25
    mirror_seq1_000011.tar  100% 3894MB 165.3MB/s   00:23
    mirror_seq1_000012.tar  100% 3871MB 137.9MB/s   00:28
    mirror_seq1_000013.tar  100% 3895MB 162.9MB/s   00:23
    mirror_seq1_000014.tar  100% 3913MB 156.7MB/s   00:24
    mirror_seq1_000015.tar  100% 4094MB 133.8MB/s   00:30
    mirror_seq1_000016.tar  100% 4094MB 133.8MB/s   00:30
    ```

3. Copy the remaining components downloaded in the online bastion (client oc, installer, images, image registry, butane...) to the offline bastion 

    ```{ .text .copy title="[root@bastiononline data]"}
    scp -r /root/registry/downloads/* root@192.168.252.23:/root/registry/downloads/
    ```

    ```{ .text .no-copy title="Output"}
    rhcos-4.16.3-x86_64-metal.x86_64.raw.gz                  100% 1208MB 391.3MB/s   00:03    
    rhcos-4.16.3-x86_64-live.x86_64.iso                      100% 1164MB 188.5MB/s   00:06    
    pull-secret.txt                                          100% 2759     1.3MB/s   00:00    
    pull-secret.json                                         100% 2875     1.4MB/s   00:00    
    mirror-registry-amd64.tar.gz                             100%  579MB 407.7MB/s   00:01    
    image-archive.tar                                        100% 1388MB 139.8MB/s   00:09    
    execution-environment.tar                                100%  302MB 383.2MB/s   00:00    
    mirror-registry                                          100% 9595KB 295.8MB/s   00:00    
    sqlite3.tar                                              100%  108MB 193.5MB/s   00:00    
    butane                                                   100% 7881KB 218.3MB/s   00:00    
    openshift-client-linux-amd64-rhel8-4.16.9.tar.gz         100%   64MB 497.5MB/s   00:00    
    oc                                                       100%  152MB 373.1MB/s   00:00    
    kubectl                                                  100%  152MB 665.6MB/s   00:00    
    openshift-install-linux-4.16.9.tar.gz                    100%  487MB 497.8MB/s   00:00    
    README.md                                                100%  706   395.9KB/s   00:00    
    openshift-install                                        100%  675MB 191.8MB/s   00:03    
    oc-mirror.tar.gz                                         100%   64MB 525.6MB/s   00:00    
    oc-mirror                                                100%  158MB 386.7MB/s   00:00    
    .oc-mirror.log                                           100%    0     0.0KB/s   00:00
    ```

4. Exit the online bastion

    ```{ .text .copy title="[root@bastiononline data]"}
    exit
    ```

5. Access the offline bastion:

    ```{ .text .copy title="[student laptop]"}
    ssh root@192.168.252.23
    ```

6. Copy the binaries into `/usr/bin` or `/usr/local/bin` in the same way as it was done for the online bastion

    ```{ .text .copy title="[root@bastion ~]"}
    cd /root/registry/downloads/tools
    ```

    ```{ .text .copy title="[root@bastion tools]"}
    ls -lart
    ```

    ```{ .sh .no-copy title="Output"}
    total 4245772
    drwxr-xr-x 5 root root         48 Oct 25 14:08 ..
    -rw-r--r-- 1 root root  607056480 Oct 25 15:43 mirror-registry-amd64.tar.gz
    -rw-r--r-- 1 root root 1454929920 Oct 25 15:44 image-archive.tar
    -rw-r--r-- 1 root root  316753920 Oct 25 15:44 execution-environment.tar
    -rwxr-xr-x 1 root root    9824888 Oct 25 15:44 mirror-registry
    -rw-r--r-- 1 root root  113418240 Oct 25 15:44 sqlite3.tar
    -rw-r--r-- 1 root root    8070568 Oct 25 15:44 butane
    -rw-r--r-- 1 root root   66705673 Oct 25 15:44 openshift-client-linux-amd64-rhel8-4.16.9.tar.gz
    -rwxr-xr-x 1 root root  159905720 Oct 25 15:44 oc
    -rwxr-xr-x 1 root root  159905720 Oct 25 15:44 kubectl
    -rw-r--r-- 1 root root  510253136 Oct 25 15:44 openshift-install-linux-4.16.9.tar.gz
    -rw-r--r-- 1 root root        706 Oct 25 15:44 README.md
    -rwxr-xr-x 1 root root  707731456 Oct 25 15:44 openshift-install
    -rw-r--r-- 1 root root   67385243 Oct 25 15:44 oc-mirror.tar.gz
    -rwxr-x--x 1 root root  165699280 Oct 25 15:44 oc-mirror
    -rw------- 1 root root          0 Oct 25 15:44 .oc-mirror.log
    drwxr-xr-x 2 root root       4096 Oct 25 15:44 .
    ```

    ```{ .text .copy title="[root@bastion tools]"}
    cp /root/registry/downloads/tools/oc /usr/bin/oc
    cp /root/registry/downloads/tools/openshift-install /usr/bin/openshift-install
    cp /root/registry/downloads/tools/oc-mirror /usr/local/bin/oc-mirror
    ```

## Create the private image registry in the offline bastion

The images to be used during the installation of OpenShift are to be supplied from the bastion. To do this, a local registry must be configured as follows:

1. Run the `mirror-registry install` command

    ```{ .text .copy title="[root@bastion downloads]"}
    cd /root/registry/downloads/tools
    ```

    ```{ .text .copy title="[root@bastion tools]"}
    ./mirror-registry install --quayRoot /root/registry \
                              --quayHostname bastion.ocp4.platformengineers.xyz \
                              --initPassword passw0rd
    ```

    !!! warning "Important"
        On a client installation, please specify a different password in agreement with the client. If the `--initPassword` is not specified during the Quay private image registry install command, a random password is generated.
        
        **IMPORTANT:** If you let the install process generate a random password, please **DO WRITE IT DOWN** as it can not be retrieved again.

    ```{ .text .no-copy title="Output" hl_lines="18"}
    __   __
    /  \ /  \     ______   _    _     __   __   __
    / /\ / /\ \   /  __  \ | |  | |   /  \  \ \ / /
    / /  / /  \ \  | |  | | | |  | |  / /\ \  \   /
    \ \  \ \  / /  | |__| | | |__| | / ____ \  | |
    \ \/ \ \/ /   \_  ___/  \____/ /_/    \_\ |_|
    \__/ \__/      \ \__
                    \___\ by Red Hat
    Build, Store, and Distribute your Containers

    INFO[2023-11-06 17:01:33] Install has begun  
    ...
    ...
    PLAY RECAP *************************************************************************************************************************************************
    root@bastion.ocp4.platformengineers.xyz : ok=50   changed=30   unreachable=0    failed=0    skipped=17   rescued=0    ignored=0   

    INFO[2023-11-06 17:04:14] Quay installed successfully, config data is stored in /root/registry 
    INFO[2023-11-06 17:04:14] Quay is available at https://bastion.ocp4.platformengineers.xyz:8443 with credentials (init, passw0rd) 
    ```

1. If you let the Quay's private image registry install process generate a random password for the `init` user, log such password    

    ```{ .text .no-copy title="Output" hl_lines="2"}
    INFO[2023-09-11 18:31:13] Quay installed successfully, config data is stored in /root/registry
    INFO[2023-09-11 18:31:13] Quay is available at https://bastion.ocp4.platformengineers.xyz:8443 with credentials (init, cw9q3GC10aPQMiunkSZ6Ag7r52H8h4ve)
    ```

    !!! warning
        Take note of this user and password because you will need to use it when you create the `install-config.yaml` file on next steps.

1. Add the `init` user as a Quay super user on the following Quay private image registry configuration file within the `SUPER_USERS` section

    ```{ .text .copy title="[root@bastion tools]"}
    vi /root/registry/quay-config/config.yaml
    ```

    ```{ .yaml .no-copy title="Output" hl_lines="4"}
    ...
    SUPER_USERS:
    - admin
    - init
    ...
    ```

1. Restart the offline bastion node.

    ```{ .text .copy title="[root@bastion tools]"}
    init 6
    ```
!!! danger "Important"
    - The private image registry sets Quay to use the autogenerated TLS certificates to enable SSL connectivity by default. These certificates have a validity of **365 days** and **will expire after 1 year** after which they need to be rotated. The rotation procedure is not done automatically by Quay, it needs to be done manually, otherwise x509 errors will be present during pushes and pulls to/from the registry.
    
    - You can find the instructions to rotate the certificates [**here**](https://access.redhat.com/solutions/6980268).

    - Newly created certificate will need to be added to all OpenShift clusters that pull images from this private image registry instance. This will ensure certificate trust. You can find the link to add certficiates to OpenShift [**here**](https://docs.openshift.com/container-platform/4.15/cicd/builds/setting-up-trusted-ca.html)

## Publish the downloaded images to the offline bastion Image Registry

The downloaded images must be published in the Quay private image registry installed on the previous section. 

1. Access the offline bastion again:

    ```{ .text .copy title="[student laptop]"}
    ssh root@192.168.252.23
    ```

1. Execute the following command to set the image registry certificate as a trusted certificate by the system:

    ```{ .text .copy title="[root@bastion ~]"}
    cp /root/registry/quay-rootCA/rootCA.pem /usr/share/pki/ca-trust-source/anchors/
    update-ca-trust
    ```

1. Log into the private image registry:

    !!! warning
        Remember to use the user (`init`) and password (`passw0rd` if you used the command outlined in this training material) you installed the Quay private image registry with during its installation proccess. 

    ```{ .text .copy title="[root@bastion ~]"}
    podman login bastion.ocp4.platformengineers.xyz:8443
    ```

    ```{ .text .no-copy title="Output"}
    Login Succeeded!
    ```

1. Launch the image mirror process to load the previously downloaded images, now in `.tar` files, into the Quay private image registry:

    !!! info
        This process can take around 30 mins

    !!! tip
        You should not need the `--dest-skip-tls` flag in the command below if you set your container image private registry CA as a trusted CA in the steps above. We've added it to avoid issues during workshops.

    ```{ .text .copy title="[root@bastion ~]"}
    oc mirror --from=/root/registry/data docker://bastion.ocp4.csm-spgi.acme.es:8443 --dest-skip-tls
    ```

    ```{ .text .no-copy title="Output"}
    [...]
    Wrote release signatures to oc-mirror-workspace/results-1694473158
    Rendering catalog image "bastion.ocp4.platformengineers.xyz:8443/redhat/redhat-operator-index:v4.12" with file-based catalog
    Writing image mapping to oc-mirror-workspace/results-1694473158/mapping.txt
    Writing CatalogSource manifests to oc-mirror-workspace/results-1694473158
    Writing ICSP manifests to oc-mirror-workspace/results-1694473158
    ```

1. You can check the result of the image mirror process by pointing your browser to:

    https://192.168.252.23:8443

    ![68](images/airgap-4-12/68.png){: style="max-height:800px"}

1. Check that the `catalogSource-redhat-operator-index.yaml` and `imageContentSourcePolicy.yaml` files have been generated in the `/root/oc-mirror-workspace/results-XXXXXX` directory.

    ```{ .text .copy title="[root@bastion ~]"}
    ls -lart ~/oc-mirror-workspace/results-XXXXXX/
    ```

    ```{ .sh .no-copy title="Output"}
    total 96
    drwxr-xr-x 2 root root     6 Sep 11 18:59 charts
    drwxr-xr-x 2 root root    98 Sep 11 19:25 release-signatures
    drwxr-xr-x 4 root root    47 Sep 11 19:25 ..
    -rw-r--r-- 1 root root 87467 Sep 11 19:25 mapping.txt
    -rwxr-xr-x 1 root root   241 Sep 11 19:25 catalogSource-redhat-operator-index.yaml
    -rwxr-xr-x 1 root root  1741 Sep 11 19:25 imageContentSourcePolicy.yaml
    drwxr-xr-x 4 root root   150 Sep 11 19:25 .
    ```

!!! note
    The contents of the `imageContentSourcePolicy.yaml` must be written down for use when creating the `install-config.yaml` file later in the chapter [Create the install-config.yaml file](#30-create-the-install-configyaml-file).

    The contents of the `catalogSource-redhat-operator-index.yaml` file must be used when creating the RedHat Marketplace later in the chapter [Create the catalog sources to access RedHat Marketplace operators](#34-create-the-catalog-sources-to-access-the-redhat-marketplace-operators).

## Configuring DNS service in offline bastion

1. The DNS service configuration file is located in the `/etc` directory. To start, copy `named.conf` to a backup file:

    ```{ .text .copy title="[root@bastion ~]"}
    cp /etc/named.conf /etc/named.conf.bak
    ```

1. Open the `named.conf` file.
    
    ```{ .text .copy title="[root@bastion ~]"}
    vi /etc/named.conf
    ```

1. Edit the file to look like the one shown below 

    ```{ .nginx .copy title="named.conf" hl_lines="61 66"}
    //
    // named.conf
    //
    // Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
    // server as a caching only nameserver (as a localhost DNS resolver only).
    //
    // See /usr/share/doc/bind*/sample/ for example named configuration files.
    //

    options {
    #   listen-on port 53 { 127.0.0.1; };
    #   listen-on-v6 port 53 { ::1; };
        directory   "/var/named";
        dump-file   "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        secroots-file   "/var/named/data/named.secroots";
        recursing-file  "/var/named/data/named.recursing";
        allow-query     { any;};

        /*
        - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion.
        - If you are building a RECURSIVE (caching) DNS server, you need to enable
        recursion.
        - If your recursive DNS server has a public IP address, you MUST enable access
        control to limit queries to your legitimate users. Failing to do so will
        cause your server to become part of large scale DNS amplification
        attacks. Implementing BCP38 within your network would greatly
        reduce such attack surface
        */
        recursion yes;

        dnssec-enable yes;
    #   dnssec-validation yes;

        managed-keys-directory "/var/named/dynamic";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";
    #    forwarders { 192.168.252.1;};
        /* https://fedoraproject.org/wiki/Changes/CryptoPolicy */
        include "/etc/crypto-policies/back-ends/bind.config";
    };

    logging {
            channel default_debug {
                    file "data/named.run";
                    severity dynamic;
            };
    };

    zone "." IN {
        type hint;
        file "named.ca";
    };

    include "/etc/named.rfc1912.zones";
    include "/etc/named.root.key";
    zone "acme.es" {
        type master;
        file "platformengineers.xyz.db";
        allow-update { none; };
    };
    zone "252.168.192.in-addr.arpa" IN {
        type master;
        file "platformengineers.xyz.reverse.db";
        allow-update { none; };
    };
    ```

1. Create the `platformengineers.xyz.db` file in `/var/named` for name resolution.

    ```{ .text .copy title="[root@bastion ~]"}
    vi /var/named/platformengineers.xyz.db
    ```

    ```{ .zone .copy title="platformengineers.xyz.db"}
    $TTL 1D
    @ IN SOA bastion.ocp4.platformengineers.xyz. root.ocp4.platformengineers.xyz. (
    2019022409 ; serial
    3h ; refresh
    15 ; retry
    1w ; expire
    3h ; minimum
    )
           IN NS bastion.ocp4.platformengineers.xyz.
    api.ocp4.platformengineers.xyz. IN A 192.168.252.24
    api-int.ocp4.platformengineers.xyz. IN A 192.168.252.24
    *.apps.ocp4.platformengineers.xyz. IN A 192.168.252.25
    bootstrap.ocp4.platformengineers.xyz. IN A 192.168.252.3
    bastion.ocp4.platformengineers.xyz. IN A 192.168.252.23
    controlplane01.ocp4.platformengineers.xyz. IN A 192.168.252.4
    controlplane02.ocp4.platformengineers.xyz. IN A 192.168.252.5
    controlplane03.ocp4.platformengineers.xyz. IN A 192.168.252.6
    infra01.ocp4.platformengineers.xyz. IN A 192.168.252.7
    infra02.ocp4.platformengineers.xyz. IN A 192.168.252.8
    infra03.ocp4.platformengineers.xyz. IN A 192.168.252.9
    compute01.ocp4.platformengineers.xyz. IN A 192.168.252.10
    compute02.ocp4.platformengineers.xyz. IN A 192.168.252.11
    compute03.ocp4.platformengineers.xyz. IN A 192.168.252.12
    storage01.ocp4.platformengineers.xyz. IN A 192.168.252.13
    storage02.ocp4.platformengineers.xyz. IN A 192.168.252.14
    storage03.ocp4.platformengineers.xyz. IN A 192.168.252.15
    ```

1. Create `platformengineers.xyz.reverse.db` file in `/var/named` for reverse name resolution:

    ```{ .text .copy title="[root@bastion ~]"}
    vi /var/named/platformengineers.xyz.reverse.db
    ```

    ```{ .zone .copy title="platformengineers.xyz.reverse.db"}
    $TTL 1D
    @ IN SOA bastion.ocp4.platformengineers.xyz. root.ocp4.platformengineers.xyz. (
    2019022409 ; serial
    3h ; refresh
    15 ; retry
    1w ; expire
    3h ; minimum
    )
    252.168.192.in-addr.arpa. IN NS bastion.ocp4.platformengineers.xyz.
    23 IN PTR bastion.ocp4.platformengineers.xyz.
    3 IN PTR bootstrap.ocp4.platformengineers.xyz.
    4 IN PTR controlplane01.ocp4.platformengineers.xyz.
    5 IN PTR controlplane02.ocp4.platformengineers.xyz.
    6 IN PTR controlplane03.ocp4.platformengineers.xyz.
    7 IN PTR infra01.ocp4.platformengineers.xyz.
    8 IN PTR infra02.ocp4.platformengineers.xyz.
    9 IN PTR infra03.ocp4.platformengineers.xyz.
    10 IN PTR compute01.ocp4.platformengineers.xyz.
    11 IN PTR compute02.ocp4.platformengineers.xyz.
    12 IN PTR compute03.ocp4.platformengineers.xyz.
    13 IN PTR storage01.ocp4.platformengineers.xyz.
    14 IN PTR storage02.ocp4.platformengineers.xyz.
    15 IN PTR storage03.ocp4.platformengineers.xyz.
    ```

1. Enable the DNS service: 

    ```{ .text .copy title="[root@bastion ~]"}
    systemctl enable named
    ```

    ```{ .text .no-copy title="Output"}
    Created symlink /etc/systemd/system/multi-user.target.wants/named.service → /usr/lib/systemd/system/named.service.
    ```

1. Start the DNS service:

    ```{ .text .copy title="[root@bastion ~]"}
    systemctl start named
    ```

## Set up HAProxy in the offline bastion

The following link provides an example of the HAProxy provided by RedHat as a reference:

https://access.redhat.com/articles/5127211 

1. Open the HAProxy configuration file:

    ```{ .text .copy title="[root@bastion ~]"}
    vi /etc/haproxy/haproxy.cfg
    ```

1. Make sure the HAProxy configuration file looks like below:

    ```{ .nginx .copy title="haproxy.cfg"}
    #---------------------------------------------------------------------
    # Global settings
    #---------------------------------------------------------------------
    global
    log 127.0.0.1 local2
    chroot /var/lib/haproxy
    pidfile /var/run/haproxy.pid
    maxconn 4000
    user haproxy
    group haproxy
    daemon
    # turn on stats unix socket
    stats socket /var/lib/haproxy/stats
    # utilize system-wide crypto-policies
    #ssl-default-bind-ciphers PROFILE=SYSTEM
    #ssl-default-server-ciphers PROFILE=SYSTEM
    #---------------------------------------------------------------------
    # common defaults that all the 'listen' and 'backend' sections will
    # use if not designated in their block
    #---------------------------------------------------------------------
    defaults
    mode tcp
    log global
    #option httplog
    option dontlognull
    option http-server-close
    option forwardfor except 127.0.0.0/8
    option redispatch
    retries 3
    timeout http-request 10s
    timeout queue 1m
    timeout connect 10s
    timeout client 5m
    timeout server 5m
    timeout http-keep-alive 10s
    timeout check 10s
    maxconn 3000
    #---------------------------------------------------------------------
    # balancing for RHOCP Kubernetes API Server
    #---------------------------------------------------------------------
    frontend k8s_api
    bind *:6443
    #mode tcp
    default_backend k8s_api_backend
    backend k8s_api_backend
    #balance roundrobin
    balance source
    #mode tcp
    server bootstrap.ocp4.platformengineers.xyz 192.168.252.3:6443 check
    server controlplane01.ocp4.platformengineers.xyz 192.168.252.4:6443 check
    server controlplane02.ocp4.platformengineers.xyz 192.168.252.5:6443 check
    server controlplane03.ocp4.platformengineers.xyz 192.168.252.6:6443 check
    # ---------------------------------------------------------------------
    # balancing for RHOCP Machine Config Server
    # ---------------------------------------------------------------------
    frontend machine_config
    bind *:22623
    #mode tcp
    default_backend machine_config_backend
    backend machine_config_backend
    #balance roundrobin
    balance source
    #mode tcp
    server bootstrap.ocp4.platformengineers.xyz 192.168.252.3:22623 check
    server controlplane01.ocp4.platformengineers.xyz 192.168.252.4:22623 check
    server controlplane02.ocp4.platformengineers.xyz 192.168.252.5:22623 check
    server controlplane03.ocp4.platformengineers.xyz 192.168.252.6:22623 check
    # --------------------------------------------------------------------
    # balancing for RHOCP Ingress Insecure Port
    # ---------------------------------------------------------------------
    frontend ingress_insecure
    bind *:80
    #mode tcp
    default_backend ingress_insecure_backend
    backend ingress_insecure_backend
    #balance roundrobin
    balance source
    #mode tcp
    server infra01.ocp4.platformengineers.xyz 192.168.252.7:80 check
    server infra02.ocp4.platformengineers.xyz 192.168.252.8:80 check
    server infra03.ocp4.platformengineers.xyz 192.168.252.9:80 check
    server compute01.ocp4.platformengineers.xyz 192.168.252.10:80 check
    server compute02.ocp4.platformengineers.xyz 192.168.252.11:80 check
    server compute03.ocp4.platformengineers.xyz 192.168.252.12:80 check
    server storage01.ocp4.platformengineers.xyz 192.168.252.13:80 check
    server storage02.ocp4.platformengineers.xyz 192.168.252.14:80 check
    server storage03.ocp4.platformengineers.xyz 192.168.252.15:80 check

    # ---------------------------------------------------------------------
    # balancing for RHOCP Ingress Secure Port
    # ---------------------------------------------------------------------
    frontend ingress_secure
    bind *:443
    #mode tcp
    default_backend ingress_secure_backend
    backend ingress_secure_backend
    #balance roundrobin
    balance source
    #mode tcp
    server infra01.ocp4.platformengineers.xyz 192.168.252.7:443 check
    server infra02.ocp4.platformengineers.xyz 192.168.252.8:443 check
    server infra03.ocp4.platformengineers.xyz 192.168.252.9:443 check
    server compute01.ocp4.platformengineers.xyz 192.168.252.10:443 check
    server compute02.ocp4.platformengineers.xyz 192.168.252.11:443 check
    server compute03.ocp4.platformengineers.xyz 192.168.252.12:443 check
    server storage01.ocp4.platformengineers.xyz 192.168.252.13:80 check
    server storage02.ocp4.platformengineers.xyz 192.168.252.14:80 check
    server storage03.ocp4.platformengineers.xyz 192.168.252.15:80 check
    

    # ---------------------------------------------------------------------
    # Exposing HAProxy Statistic Page
    # ---------------------------------------------------------------------
    #listen stats
    #bind :32700
    #stats enable
    #stats uri /
    #stats hide-version
    #stats auth admin:RedH@t322
    ```

1. Check the configuration file:

    ```{ .text .copy title="[root@bastion ~]"}
    haproxy -c -f /etc/haproxy/haproxy.cfg
    ```

    ```{ .text .no-copy title="Output"}
    Configuration file is valid
    ```

1. Enable the service:

    ```{ .text .copy title="[root@bastion ~]"}
    systemctl enable haproxy
    ```

    ```{ .text .no-copy title="Output"}
    Created symlink /etc/systemd/system/multi-user.target.wants/haproxy.service → /usr/lib/systemd/system/haproxy.service.
    ```

1. Start the service:

    ```{ .text .copy title="[root@bastion ~]"}
    systemctl start haproxy
    ```

## Install the HTTP server in the offline bastion

For the provisioning of the ignition files to configure the OpenShift cluster nodes, an HTTP server is required. In this installation, that server resides in the offline bastion. In order to install an Apache HTTPD web server, follow the steps below.

1. Check the http package is installed:

    ```{ .text .copy title="[root@bastion ~]"}
    yum list installed | grep http
    ```

    ```{ .text .no-copy title="Output"}
    httpd.x86_64     2.4.37-56.module+el8.8.0+19808+379766d6.7     @rhel-8-for-x86_64-appstream-rpms
    ```

1. Configure the httpd server to boot on port `8080` by configuring the file in the path `/etc/httpd/conf/httpd.conf` and changing the default port `80` to `8080`.

    ```{ .text .copy title="[root@bastion ~]"}
    vi /etc/httpd/conf/httpd.conf
    ```

    ```{ .conf .no-copy title="Output" hl_lines="4"}
    [...]
    #
    #Listen 12.34.56.78:80
    Listen 8080

    #
    [...]
    ```

1. Start the service:

    ```{ .text .copy title="[root@bastion ~]"}
    systemctl enable httpd
    ```

    ```{ .text .no-copy title="Output"}
    Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
    ```

    ```{ .text .copy title="[root@bastion ~]"}
    systemctl start httpd
    ```

1. Create the following directory to host the images and the ignition files: 

    ```{ .text .copy title="[root@bastion ~]"}
    mkdir /var/www/html/ign
    ```

## Generate an SSH key in the offline bastion

In order to be able to log on to the OpenShift cluster nodes from the bastion server using SSH after the installation has been done, a public ssh key needs to be added to the file `install-config.yaml`.

1. Generate an SSH key

    ```{ .text .copy title="[root@bastion ~]"}
    ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519
    ```

    ```{ .text .no-copy title="Output"}
    Generating public/private ed25519 key pair.
    Your identification has been saved in /root/.ssh/id_ed25519.
    Your public key has been saved in /root/.ssh/id_ed25519.pub.
    The key fingerprint is:
    SHA256:bldGYez9jXDnXs+6luiy7dDnEFVIoKqVtJpTyaMg/wU root@bastion.ocp4.platformengineers.xyz
    The key's randomart image is:
    +--[ED25519 256]--+
    |           .+o...|
    |           o.... |
    |        . .....  |
    |       o = .o.o .|
    |  . . E S   +o =.|
    |   o . X . + .. =|
    |    . * + o o..+o|
    |     . + ..o.+o +|
    |      .   .=+.+o |
    +----[SHA256]-----+
    ```


1. Display the public key:

    ```{ .text .copy title="[root@bastion ~]"}
    cat /root/.ssh/id_ed25519.pub
    ```

    ```{ .text .no-copy title="Output"}
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIET7OJRP4wD7ibIvcQxA9/9B80qUp0IPog0M9E7zofED root@bastion.ocp4.platformengineers.xyz
    ```

1. Start the SSH agent

    ```{ .text .copy title="[root@bastion ~]"}
    eval "$(ssh-agent -s)"
    ```

    ```{ .text .no-copy title="Output"}
    Agent pid 7233
    ```

1. Add the key to the SSH agent

    ```{ .text .copy title="[root@bastion ~]"}
    ssh-add ~/.ssh/id_ed25519
    ```

    ```{ .text .no-copy title="Output"}
    Identity added: /root/.ssh/id_ed25519 (root@bastion.ocp4.platformengineers.xyz)
    ```
