---
title: Configure Infrastructure Nodes
hide:
    - toc
---

This operation is performed to ready the infrastructure nodes for OpenShift infrastructure components. The infrastructure nodes do not consume OpenShift licenses.

1. Create the labels for the infra nodes

    ```{ .text .copy title="[root@bastion ocp4]"}
    oc label node infra01.ocp4.platformengineers.xyz node-role.kubernetes.io/infra=
    ```

    ```{ .text .no-copy title="Output"}
    node/infra01.ocp4.platformengineers.xyz labeled
    ```

    ```{ .text .copy title="[root@bastion ocp4]"}
    oc label node infra02.ocp4.platformengineers.xyz node-role.kubernetes.io/infra=
    ```

    ```{ .text .no-copy title="Output"}
    node/infra02.ocp4.platformengineers.xyz labeled
    ```

    ```{ .text .copy title="[root@bastion ocp4]"}
    oc label node infra03.ocp4.platformengineers.xyz node-role.kubernetes.io/infra=
    ```

    ```{ .text .no-copy title="Output"}
    node/infra03.ocp4.platformengineers.xyz labeled
    ```

1. Taint the infra nodes to prevent them from receiving other workloads

    ```{ .text .copy title="[root@bastion ocp4]"}
    oc adm taint nodes -l node-role.kubernetes.io/infra infra=reserved:NoSchedule infra=reserved:NoExecute
    ```

    ```{ .text .no-copy title="Output"}
    node/infra01.ocp4.platformengineers.xyz tainted
    node/infra02.ocp4.platformengineers.xyz tainted
    node/infra03.ocp4.platformengineers.xyz tainted
    ```
