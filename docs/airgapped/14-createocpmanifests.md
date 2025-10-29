---
title: Create OpenShift Manifests and Ignition files 
hide:
    - toc
---

1. Create the OpenShift manifest files

    ```{ .text .copy title="[root@bastion ocp4]"}
    openshift-install create manifests --dir /root/registry/downloads/tools/ocp4
    ```

    ```{ .text .no-copy title="Output"}
    INFO Consuming Install Config from target directory
    INFO Manifests created in: /root/registry/downloads/tools/ocp4/manifests and /root/registry/downloads/tools/ocp4/openshift
    ```

1. In order to create the ignition files, install butane in the bastion node:

    ```{ .text .copy title="[root@bastion ocp4]"}
    cd /root/registry/downloads/tools/
    ```

    ```{ .text .copy title="[root@bastion tools]"}
    chmod u+x butane
    cp butane /usr/local/bin/butane
    butane -V
    ```

    ```{ .text .no-copy title="Output"}
    Butane 0.18.0
    ```

Create two butane files for the master and worker nodes. In these files, you set the chrony configuration for master and worker nodes.

**99-worker-chrony-conf-override.bu**

1. Create the `99-worker-chrony-conf-override.bu` file

    ```{ .text .copy title="[root@bastion tools]"}
    vi 99-worker-chrony-conf-override.bu
    ```

1. Make sure it looks like below

    ```{ .yaml .copy title="99-worker-chrony-conf-override.bu"}
    variant: openshift
    version: 4.16.0
    metadata:
      name: 99-worker-chrony-conf-override
      labels:
        machineconfiguration.openshift.io/role: worker
    storage:
      files:
        - path: /etc/chrony.conf
          mode: 0644
          overwrite: true
          contents:
            inline: |
              # The Machine Config Operator manages this file.
              server controlplane01.ocp4.platformengineers.xyz iburst
              server controlplane02.ocp4.platformengineers.xyz iburst
              server controlplane03.ocp4.platformengineers.xyz iburst

              stratumweight 0
              driftfile /var/lib/chrony/drift
              rtcsync
              makestep 10 3
              bindcmdaddress 127.0.0.1
              bindcmdaddress ::1
              keyfile /etc/chrony.keys
              commandkey 1
              generatecommandkey
              noclientlog
              logchange 0.5
              logdir /var/log/chrony
    ```

**99-master-chrony-conf-override.bu**

1. Create the `99-master-chrony-conf-override.bu` file

    ```{ .text .copy title="[root@bastion tools]"}
    vi 99-master-chrony-conf-override.bu
    ```

1. Make sure it looks like below

    ```{ .yaml .copy title="99-master-chrony-conf-override.bu"}
    variant: openshift
    version: 4.16.0
    metadata:
      name: 99-master-chrony-conf-override
      labels:
        machineconfiguration.openshift.io/role: master
    storage:
      files:
        - path: /etc/chrony.conf
          mode: 0644
          overwrite: true
          contents:
            inline: |
              # Use public servers from the pool.ntp.org project.
              # Please consider joining the pool (https://www.pool.ntp.org/join.html).

              # The Machine Config Operator manages this file
              server controlplane01.ocp4.platformengineers.xyz iburst
              server controlplane02.ocp4.platformengineers.xyz iburst
              server controlplane03.ocp4.platformengineers.xyz iburst

              stratumweight 0
              driftfile /var/lib/chrony/drift
              rtcsync
              makestep 10 3
              bindcmdaddress 127.0.0.1
              bindcmdaddress ::1
              keyfile /etc/chrony.keys
              commandkey 1
              generatecommandkey
              noclientlog
              logchange 0.5
              logdir /var/log/chrony

              # Configure the control plane nodes to serve as local NTP servers
              # for all worker nodes, even if they are not in sync with an
              # upstream NTP server.

              # Allow NTP client access from the local network.
              allow all
              # Serve time even if not synchronized to a time source.
              local stratum 3 orphan
    ```

1. Generate the yaml files with butane:

    ```{ .text .copy title="[root@bastion tools]"}
    butane 99-worker-chrony-conf-override.bu -o 99-worker-chrony-conf-override.yaml
    ```

    ```{ .text .copy title="[root@bastion tools]"}
    butane 99-master-chrony-conf-override.bu -o 99-master-chrony-conf-override.yaml
    ```

1. Copy them to the installation directory:

    ```{ .text .copy title="[root@bastion tools]"}
    cp 99-*.yaml /root/registry/downloads/tools/ocp4/manifests/
    ```

1. Make a copy of the installation directory:

    ```{ .text .copy title="[root@bastion tools]"}
    cp -r ocp4 ocp4_backup
    ```

1. Create the ignition files:

    ```{ .text .copy title="[root@bastion tools]"}
    openshift-install create ignition-configs --dir /root/registry/downloads/tools/ocp4/
    ```

    ```{ .text .no-copy title="Output"}
    INFO Consuming Common Manifests from target directory
    INFO Consuming OpenShift Install (Manifests) from target directory
    INFO Consuming Master Machines from target directory
    INFO Consuming Openshift Manifests from target directory
    INFO Consuming Worker Machines from target directory
    INFO Ignition-Configs created in: /root/registry/downloads/tools/ocp4 and /root/registry/downloads/tools/ocp4/auth
    ```

1. Provide read and execute permissions for other users and groups to the ignition files:

    ```{ .text .copy title="[root@bastion tools]"}
    chmod 755 /root/registry/downloads/tools/ocp4/*.ign
    ```

1. Copy the ignition files to the serving path of the HTTP Server we installed on the [Install the http server in the offline bastion](#26-install-the-http-server-in-the-offline-bastion) section before.

    ```{ .text .copy title="[root@bastion tools]"}
    cp /root/registry/downloads/tools/ocp4/*.ign /var/www/html/ign/
    ll /var/www/html/ign/
    ```

    ```{ .sh .no-copy title="Output"}
    total 288
    -rwxr-xr-x 1 root root 284065 Sep 14 05:19 bootstrap.ign
    -rwxr-xr-x 1 root root   1723 Sep 14 05:19 master.ign
    -rwxr-xr-x 1 root root   1723 Sep 14 05:19 worker.ign
    ```

1. It is recommended to back the directory `ocp4/auth` up, because it contains the certificates and key of the initial user and administrator of OpenShift: the user **kubeadmin**.

    ```{ .text .copy title="[root@bastion tools]"}
    cp -r /root/registry/downloads/tools/ocp4/auth/ /root/registry/downloads/tools/ocp4_auth/
    ```
