---
title: Day 2 Operations
hide:
    - toc
---

## Move ingress routing and internal registry loads to infrastructure nodes

1. Move the OpenShift cluster ingress controller to the infra nodes.

    ```{ .text .copy title="[root@bastion ocp4]"}
    oc edit ingresscontroller default -n openshift-ingress-operator
    ```

1. Copy the highlighted lines into your default Ingress Controller specification.

    ```{ .yaml .copy title="deault" hl_lines="25-35"}
    # Please edit the object below. Lines beginning with a '#' will be ignored,
    # and an empty file will abort the edit. If an error occurs while saving this file will be
    # reopened with the relevant failures.
    #
    apiVersion: operator.openshift.io/v1
    kind: IngressController
    metadata:
    creationTimestamp: "2023-09-14T13:30:51Z"
    finalizers:
    - ingresscontroller.operator.openshift.io/finalizer-ingresscontroller
    generation: 2
    name: default
    namespace: openshift-ingress-operator
    resourceVersion: "2658200"
    uid: 40d5648f-98c3-46ac-9223-773e52b65f6a
    spec:
    clientTLS:
        clientCA:
        name: ""
        clientCertificatePolicy: ""
    httpCompression: {}
    httpEmptyRequestsPolicy: Respond
    httpErrorCodePages:
        name: ""
    nodePlacement:
      nodeSelector:
        matchLabels:
          node-role.kubernetes.io/infra: ""
      tolerations:
      - effect: NoSchedule
        key: infra
        value: reserved
      - effect: NoExecute
        key: infra
        value: reserved
    replicas: 2
    tuningOptions:
        reloadInterval: 0s
    [...]
    ```

1. Move the internal OpenShift image registry to the infra nodes

    ```{ .text .copy title="[root@bastion ocp4]"}
    oc patch configs.imageregistry.operator.openshift.io/cluster --type=merge -p '{"spec":{"nodeSelector": {"node-role.kubernetes.io/infra": ""},"tolerations": [{"effect":"NoSchedule","key": "infra","value": "reserved"},{"effect":"NoExecute","key": "infra","value": "reserved"}]}}'
    ```

    ```{ .text .no-copy title="Output"}
    config.imageregistry.operator.openshift.io/cluster patched
    ```


## Create the catalog sources to access the RedHat Marketplace operators

The OpenShift cluster does not have internet access. Therefore the operator catalog for available operators has to be configured to point to the image mirrored to the Quay private image registry installed on the offline bastion.

To do this, we will use the `catalogSource-redhat-operator-index.yaml` file previously created during installation and available in `/root/oc-mirror-workspace/results-XXXXXX`.

Before applying the catalog source, the default catalogs that have been installed with Openshift cluster need to be deactivated:

```{ .text .copy title="[root@bastion ~]"}
oc patch OperatorHub cluster --type json -p '[{"op": "add", "path": "/spec/disableAllDefaultSources", "value": true}]'
```

```{ .text .no-copy title="Output"}
operatorhub.config.openshift.io/cluster patched
```

We should see no operator available in the OperatorHub of our OpenShift cluster:

![55](images/airgap-4-12/55.png){: style="max-height:400px"}

Now, to create that custom catalog source that points to our Quay private image registry, execute the following commands:

```{ .text .copy title="[root@bastion ~]"}
cd /root/oc-mirror-workspace/results-XXXXX/
```

```{ .text .copy title="[root@bastion results-XXXXX]"}
oc apply -f catalogSource-cs-redhat-operator-index.yaml
```

```{ .text .no-copy title="Output"}
catalogsource.operators.coreos.com/redhat-operator-index created
```

Check now if the operators are listed:

![56](images/airgap-4-16/56.png){: style="max-height:900px"}

## Deactivate the cluster update channel

Openshift defines an update channel to search for and install updates. Since this cluster does not have any internet access, it is recommended to turn off the update channel.

Run the following command to modify the update channel and set it to null, leaving the cluster without an update channel.

```{ .text .copy title="[root@bastion transfer-files]"}
oc adm upgrade channel --allow-explicit-channel
```

```{ .text .no-copy title="Output"}
warning: Clearing channel "stable-4.16"; cluster will no longer request available update recommendations.
```
