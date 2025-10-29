---
Title: Install OpenShift Data Foundation
hide:
  - toc
---

The infrastructure nodes were not created during cluster installation so we are going to add these nodes post installation.

1. List the MachineSets.

   MachineSets are defined in the `openshift-machine-api` namespace.

   ```sh
   oc -n openshift-machine-api get machineset
   ```

   ```{ .text .no-copy title="Example output"}
   NAME                        DESIRED   CURRENT   READY   AVAILABLE   AGE
   ocpinstall-btcjq-worker-0   3         3         3       3           109m
   ```

2. Export the worker MachineSet.

   ```sh
   worker_machineset=$(oc -n openshift-machine-api get machineset -o jsonpath='{.items[0].metadata.name}')
   ```

   ```sh
   oc -n openshift-machine-api get machineset ${worker_machineset} -o json | jq '. | del(
     .metadata.annotations,
     .metadata.uid,
     .metadata.generation,
     .metadata.resourceVersion,
     .metadata.creationTimestamp,
     .status
   )' > infra-machineset.json
   ```

3. Edit `infra-machineset.json`.

   - Add labels to spec.metadata.lables:
     - `cluster.ocs.openshift.io/openshift-storage: ""`
     - `node-role.kubernetes.io/infra: ""`
   - Add taint `node.ocs.openshift.io/storage: "true"` to the spec.
   - Change all values with postfix `-worker-0` to `-infra-0` (3 entries).
   - Change the value of `machine.openshift.io/cluster-api-machine-role` and `machine.openshift.io/cluster-api-machine-type` to `infra`.
   - Change `memoryMiB` to `65536`.
   - Change `numCPUs` to `16`.
   - Change `numCoresPerSocket` to `2`.

   ```{ .json .no-copy title="Reference infra-machineset.json" }
   {
     "apiVersion": "machine.openshift.io/v1beta1",
     "kind": "MachineSet",
     "metadata": {
       "labels": {
         "machine.openshift.io/cluster-api-cluster": "ocpinstall-btcjq"
       },
       "name": "ocpinstall-btcjq-infra-0",
       "namespace": "openshift-machine-api"
     },
     "spec": {
       "replicas": 3,
       "selector": {
         "matchLabels": {
           "machine.openshift.io/cluster-api-cluster": "ocpinstall-btcjq",
           "machine.openshift.io/cluster-api-machineset": "ocpinstall-btcjq-infra-0"
         }
       },
       "template": {
         "metadata": {
           "labels": {
             "machine.openshift.io/cluster-api-cluster": "ocpinstall-btcjq",
             "machine.openshift.io/cluster-api-machine-role": "infra",
             "machine.openshift.io/cluster-api-machine-type": "infra",
             "machine.openshift.io/cluster-api-machineset": "ocpinstall-btcjq-infra-0"
           }
         },
         "spec": {
           "lifecycleHooks": {},
           "metadata": {
             "labels": {
               "cluster.ocs.openshift.io/openshift-storage": "",
               "node-role.kubernetes.io/infra": ""
             }
           },
           "taints": [
             {
               "effect": "NoSchedule",
               "key": "node.ocs.openshift.io/storage",
               "value": "true"
             }
           ],
           "providerSpec": {
             "value": {
               "apiVersion": "machine.openshift.io/v1beta1",
               "credentialsSecret": {
                 "name": "vsphere-cloud-credentials"
               },
               "diskGiB": 120,
               "kind": "VSphereMachineProviderSpec",
               "memoryMiB": 65536,
               "metadata": {
                 "creationTimestamp": null
               },
               "network": {
                 "devices": [
                   {
                     "networkName": "gym-50vmycg18b-yf5tfa4q-segment"
                   }
                 ]
               },
               "numCPUs": 16,
               "numCoresPerSocket": 2,
               "snapshot": "",
               "template": "ocpinstall-btcjq-rhcos-IBMCloud-ocpgym-wdc",
               "userDataSecret": {
                 "name": "worker-user-data"
               },
               "workspace": {
                 "datacenter": "IBMCloud",
                 "datastore": "/IBMCloud/datastore/gym-50vmycg18b-yf5tfa4q-storage",
                 "folder": "/IBMCloud/vm/ocpgym-wdc/gym-50vmycg18b-yf5tfa4q",
                 "resourcePool": "/IBMCloud/host/ocpgym-wdc/Resources/Cluster Resource Pool/Gym Member Resource Pool/gym-50vmycg18b-yf5tfa4q",
                 "server": "ocpgymwdc-vc.techzone.ibm.local"
               }
             }
           }
         }
       }
     }
   }
   ```

4. Create the MachineSet.

   ```sh
   oc apply -f infra-machineset.json
   ```

5. Monitor the nodes.

   ```sh
   watch oc get nodes
   ```

   ```{ .text .no-copy title="Wait until the infrastructure nodes reach status Ready"}
   NAME                              STATUS   ROLES                  AGE     VERSION
   ocpinstall-btcjq-infra-0-2ncmd    Ready    infra,worker           2m47s   v1.30.5
   ocpinstall-btcjq-infra-0-tdxvc    Ready    infra,worker           2m45s   v1.30.5
   ocpinstall-btcjq-infra-0-trwwg    Ready    infra,worker           2m45s   v1.30.5
   ocpinstall-btcjq-master-0         Ready    control-plane,master   123m    v1.30.5
   ocpinstall-btcjq-master-1         Ready    control-plane,master   123m    v1.30.5
   ocpinstall-btcjq-master-2         Ready    control-plane,master   123m    v1.30.5
   ocpinstall-btcjq-worker-0-56vmd   Ready    worker                 110m    v1.30.5
   ocpinstall-btcjq-worker-0-sdtg6   Ready    worker                 110m    v1.30.5
   ocpinstall-btcjq-worker-0-zv829   Ready    worker                 110m    v1.30.5
   ```

6. Install the ODF operator and create a SmallScale (0.5 TiB) StorageSystem.
