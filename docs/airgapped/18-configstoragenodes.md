---
title: Air-gapped OpenShift Installation
hide:
    - toc
---

## Deploy OpenShift Data Foundation on Storage nodes

This operation is performed to provide OpenShift with Block, Object and File persistent storage. Storage nodes do not consume OpenShift Licences.

1. Create the labels for the Storage nodes

    ```{ .text .copy title="[root@bastion ocp4]"}
    oc label node storage01.ocp4.platformengineers.xyz node-role.kubernetes.io/infra=
    oc label node storage01.ocp4.platformengineers.xyz cluster.ocs.openshift.io/openshift-storage= 
    ```

    ```{ .text .no-copy title="Output"}
    node/storage01.ocp4.platformengineers.xyz labeled
    ```

    ```{ .text .copy title="[root@bastion ocp4]"}
    oc label node storage02.ocp4.platformengineers.xyz node-role.kubernetes.io/infra=
    oc label node storage02.ocp4.platformengineers.xyz cluster.ocs.openshift.io/openshift-storage= 
    ```

    ```{ .text .no-copy title="Output"}
    node/storage02.ocp4.platformengineers.xyz labeled
    ```

    ```{ .text .copy title="[root@bastion ocp4]"}
    oc label node storage03.ocp4.platformengineers.xyz node-role.kubernetes.io/infra=
    oc label node storage03.ocp4.platformengineers.xyz cluster.ocs.openshift.io/openshift-storage= 
    ```

    ```{ .text .no-copy title="Output"}
    node/storage03.ocp4.platformengineers.xyz labeled
    ```

1. Taint the storage nodes to prevent them from receiving other workloads

    ```{ .text .copy title="[root@bastion ocp4]"}
    oc adm taint nodes storage01.ocp4.platformengineers.xyz node.ocs.openshift.io/storage=true:NoSchedule
    ```

    ```{ .text .no-copy title="Output"}
    node/storage01.ocp4.platformengineers.xyz tainted
    ```

    ```{ .text .copy title="[root@bastion ocp4]"}
    oc adm taint nodes storage02.ocp4.platformengineers.xyz node.ocs.openshift.io/storage=true:NoSchedule
    ```

    ```{ .text .no-copy title="Output"}
    node/storage02.ocp4.platformengineers.xyz tainted
    ```

    ```{ .text .copy title="[root@bastion ocp4]"}
    oc adm taint nodes storage03.ocp4.platformengineers.xyz node.ocs.openshift.io/storage=true:NoSchedule
    ```

    ```{ .text .no-copy title="Output"}
    node/storage03.ocp4.platformengineers.xyz tainted
    ```

## Install the Local Storage Operator

Install the Local Storage Operator from the Operator Hub before creating Red Hat OpenShift Data Foundation clusters on local storage devices.

1. Log in to the OpenShift Web Console.
2. Click Operators > OperatorHub.
3. Type local storage in the Filter by keyword​ box to find the Local Storage Operator from the list of operators, and click on it.
4. Set the following options on the Install Operator page:

    * Update channel as stable.
    * Installation mode as A specific namespace on the cluster.
    * Installed Namespace as Operator recommended namespace openshift-local-storage.
    * Update approval as Automatic.

5. Click Install.

## Install OpenShift Data Foundation

The OpenShift web console provides an easy way to install the ODF operator and create a storage cluster.

1. Open the OpenShift web console and log in as user `admin`.

2. Click **Operators > OperatorHub**.

3. Scroll or type `odf` into the Filter by keyword box to find the **OpenShift Data Foundation** Operator.

4. Select the OpenShift Data Foundation operator, click **Install**, leave the values at their default, and click **Install**.

5. After the operator installed a pop-up appears stating a new version of the web console is available, ensure you click **Refresh web console**.

6. Click **Create StorageSystem**.

7. In the Backing storage page, Check *Use Ceph RBD as the default StorageClass* and leave the remaining values at their default and click **Next**.

8. Set the Requested capacity to 0.5 TiB, notice that the infrastructure nodes have been preselected, and click **Next**.

9. In the next two screens leave the values at their default and click **Next**.

10. Review the settings and click **Create StorageSystem**.

11. Detailed progress monitoring can be done on the command line.
    
    ```sh
    oc login -u admin
    ```

    ```sh
    watch oc -n openshift-storage get storagecluster,pods
    ```

    ```{.text .no-copy title="Wait until the StorageCluster reaches phase Ready"}
    NAME                                                 AGE     PHASE   EXTERNAL   CREATED AT             VERSION
    storagecluster.ocs.openshift.io/ocs-storagecluster   6m37s   Ready              2024-11-18T12:42:21Z   4.17.3

    NAME                                                                  READY   STATUS      RESTARTS   AGE
    pod/csi-addons-controller-manager-79589c64b9-7nrnx                    2/2     Running     0          7m22s
    pod/csi-cephfsplugin-25vdt                                            2/2     Running     0          6m36s
    pod/csi-cephfsplugin-599v5                                            2/2     Running     0          6m36s
    pod/csi-cephfsplugin-crkmb                                            2/2     Running     0          6m36s
    pod/csi-cephfsplugin-gzsfw                                            2/2     Running     0          6m36s
    pod/csi-cephfsplugin-provisioner-5d549d97d5-5z8ct                     6/6     Running     0          6m36s
    pod/csi-cephfsplugin-provisioner-5d549d97d5-qgmkd                     6/6     Running     0          6m36s
    pod/csi-cephfsplugin-rbm79                                            2/2     Running     0          6m36s
    pod/csi-rbdplugin-9htkb                                               3/3     Running     0          6m36s
    pod/csi-rbdplugin-b5g7l                                               3/3     Running     0          6m36s
    pod/csi-rbdplugin-j52sh                                               3/3     Running     0          6m36s
    pod/csi-rbdplugin-provisioner-5869c4d666-2mgnq                        6/6     Running     0          6m36s
    pod/csi-rbdplugin-provisioner-5869c4d666-dz85n                        6/6     Running     0          6m36s
    pod/csi-rbdplugin-zcq6q                                               3/3     Running     0          6m36s
    pod/csi-rbdplugin-zwcdd                                               3/3     Running     0          6m36s
    pod/noobaa-core-0                                                     1/1     Running     0          2m4s
    pod/noobaa-db-pg-0                                                    1/1     Running     0          3m40s
    pod/noobaa-endpoint-7684858565-8h2d4                                  1/1     Running     0          2m35s
    pod/noobaa-operator-785bf6967-7jdb8                                   1/1     Running     0          8m5s
    pod/ocs-metrics-exporter-6db44f5fc-88lwn                              1/1     Running     0          3m39s
    pod/ocs-operator-bb969496f-5t9c7                                      1/1     Running     0          7m33s
    pod/odf-console-6d7f89bfcd-cvg2l                                      1/1     Running     0          7m58s
    pod/odf-operator-controller-manager-6ccd96449c-m94mc                  2/2     Running     0          7m58s
    pod/rook-ceph-crashcollector-ocpinstall-ntfsr-infra-0-5bfqj-75vd7ws   1/1     Running     0          5m4s
    pod/rook-ceph-crashcollector-ocpinstall-ntfsr-infra-0-cscfp-58k872l   1/1     Running     0          4m49s
    pod/rook-ceph-crashcollector-ocpinstall-ntfsr-infra-0-p42ml-64tlpnb   1/1     Running     0          5m3s
    pod/rook-ceph-exporter-ocpinstall-ntfsr-infra-0-5bfqj-75fc99752b872   1/1     Running     0          5m4s
    pod/rook-ceph-exporter-ocpinstall-ntfsr-infra-0-cscfp-74c7b944fdvqb   1/1     Running     0          4m49s
    pod/rook-ceph-exporter-ocpinstall-ntfsr-infra-0-p42ml-56c9847b27pw8   1/1     Running     0          5m3s
    pod/rook-ceph-mds-ocs-storagecluster-cephfilesystem-a-698ff486cf478   2/2     Running     0          4m
    pod/rook-ceph-mds-ocs-storagecluster-cephfilesystem-b-6dfc6bf4pprfw   2/2     Running     0          3m57s
    pod/rook-ceph-mgr-a-76cfdff9c5-xf62q                                  3/3     Running     0          5m1s
    pod/rook-ceph-mgr-b-6844cbb666-khcpw                                  3/3     Running     0          5m
    pod/rook-ceph-mon-a-7dbf8d8f47-thx42                                  2/2     Running     0          6m6s
    pod/rook-ceph-mon-b-7bfb497f67-j5rsn                                  2/2     Running     0          5m34s
    pod/rook-ceph-mon-c-779c7c4697-b2lx7                                  2/2     Running     0          5m19s
    pod/rook-ceph-operator-58d57dfcc9-h7wc6                               1/1     Running     0          6m35s
    pod/rook-ceph-osd-0-85f667c594-q6ghs                                  2/2     Running     0          4m23s
    pod/rook-ceph-osd-1-6dbb47996d-nqmbk                                  2/2     Running     0          4m21s
    pod/rook-ceph-osd-2-685cd49949-v9r6r                                  2/2     Running     0          4m18s
    pod/rook-ceph-osd-prepare-09c4822102c3025ef86f32f0690ab78c-p9bw7      0/1     Completed   0          4m38s
    pod/rook-ceph-osd-prepare-0b70eb979aae8c4e011459b9b6e8e76a-vpw8q      0/1     Completed   0          4m39s
    pod/rook-ceph-osd-prepare-40250bca7f0ab640af4d3aadd9aafcac-jz7ss      0/1     Completed   0          4m39s
    pod/rook-ceph-rgw-ocs-storagecluster-cephobjectstore-a-7976995qrs8h   2/2     Running     0          3m43s
    pod/ux-backend-server-84b877b699-mr9wg                                2/2     Running     0          7m32s
    ```

12. Verify that the OpenShift Data Foundation storage classes are available.
    
    ```sh
    oc get sc
    ```

    ```{.text .no-copy title="Example Output"}
    NAME                          PROVISIONER                             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
    ocs-storagecluster-ceph-rbd   openshift-storage.rbd.csi.ceph.com      Delete          Immediate              true                   106s
    ocs-storagecluster-ceph-rgw   openshift-storage.ceph.rook.io/bucket   Delete          Immediate              false                  4m55s
    ocs-storagecluster-cephfs     openshift-storage.cephfs.csi.ceph.com   Delete          Immediate              true                   106s
    openshift-storage.noobaa.io   openshift-storage.noobaa.io/obc         Delete          Immediate              false                  48s
    thin-csi (default)            csi.vsphere.vmware.com                  Delete          WaitForFirstConsumer   true                   43m
    ```

13. Smoke test persistent volume provisioning.

    Create a PersistentVolumeClaim (PVC) for ODF block storage.
        
    ```yaml
    oc create -f - <<EOF
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: test
      namespace: default
    spec:
      accessModes:
        - ReadWriteOnce
      storageClassName: ocs-storagecluster-ceph-rbd
      volumeMode: Filesystem
      resources:
        requests:
          storage: 1Gi
    EOF
    ```
        
    Check if the PVC is bound to a PersistentVolume.
            
    ```sh
    oc get pvc test
    ```

    ```{.text .no-copy title="Example Output"}
    NAME   STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS                  AGE
    test   Bound    pvc-419958c8-1126-4601-ba3f-4f2c14bfb88c   1Gi        RWO            ocs-storagecluster-ceph-rbd   6s
    ```
            
    Delete the test PVC.
            
    ```sh
    oc delete pvc test
    ```
