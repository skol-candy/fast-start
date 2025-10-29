---
Title: Pods
hide:
    - toc
---
# Pods

A Pod is the basic execution unit of a Kubernetes application–the smallest and simplest unit in the Kubernetes object model that you create or deploy. A Pod represents processes running on your Cluster.

A Pod encapsulates an application’s container (or, in some cases, multiple containers), storage resources, a unique network IP, and options that govern how the container(s) should run. A Pod represents a unit of deployment: a single instance of an application in Kubernetes, which might consist of either a single container or a small number of containers that are tightly coupled and that share resources.

## Resources

=== "OpenShift"

    <div class="grid cards" markdown>

      -   :fontawesome-solid-book:{ .lg .middle } __About Pods__

          ---

          Learn more about the basics of _pods_ and how they work.

          [:octicons-arrow-right-24: Getting started](https://docs.openshift.com/container-platform/4.16/nodes/pods/nodes-pods-using.html){ target="_blank"}

      -   :fontawesome-solid-globe:{ .lg .middle } __Cluster Configuration for Pods__

          ---

          Configure your cluster to work for your specific needs.

          [:octicons-arrow-right-24: Learn more](https://docs.openshift.com/container-platform/4.16/nodes/pods/nodes-pods-configuring.html){ target="_blank"}

      -   :fontawesome-solid-up-right-and-down-left-from-center:{ .lg .middle } __Pod Autoscaling__

          ---

          Use a horizontal pod autoscaler (HPA) to specify how OCP should automatically scale up or down your deployment.

          [:octicons-arrow-right-24: Learn more](https://docs.openshift.com/container-platform/4.16/nodes/pods/nodes-pods-autoscaling.html){ target="_blank"}

    </div>

=== "Kubernetes"

    <div class="grid cards" markdown>

      -   :fontawesome-solid-book:{ .lg .middle } __Pod Overview__

          ---

          Learn more about the basics of _pods_ and how they work.

          [:octicons-arrow-right-24: Getting started](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/){ target="_blank"}

      -   :fontawesome-solid-arrows-spin:{ .lg .middle } __Pod Lifecycle__

          ---

          Read about the lifecycle process for pods and what each phase means.

          [:octicons-arrow-right-24: Learn more](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/){ target="_blank"}

      -   :fontawesome-solid-globe:{ .lg .middle } __Pod Usage__

          ---

          How do you use pods? Read about it here.

          [:octicons-arrow-right-24: Learn more](https://kubernetes.io/docs/concepts/workloads/pods/pod/){ target="_blank"}

    </div>

## References

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
    - name: myapp-container
      image: busybox
      command: ["sh", "-c", "echo Hello Kubernetes! && sleep 3600"]
```

=== "OpenShift"

    **Create Pod using yaml file**

    ```sh
    oc apply -f pod.yaml
    ```

    **Get Current Pods in Project**

    ```sh
    oc get pods
    ```

    **Get Pods with their IP and node location**

    ```sh
    oc get pods -o wide
    ```

    **Get Pod's Description**

    ```sh
    oc describe pod myapp-pod
    ```

    **Get the logs**

    ```sh
    oc logs myapp-pod
    ```

    **Delete a Pod**

    ```sh
    oc delete pod myapp-pod
    ```

=== "Kubernetes"

    **Create Pod using yaml file**

    ```sh
    kubectl apply -f pod.yaml
    ```

    **Get Current Pods in Project**

    ```sh
    kubectl get pods
    ```

    **Get Pods with their IP and node location**

    ```sh
    kubectl get pods -o wide
    ```

    **Get Pod's Description**

    ```sh
    kubectl describe pod myapp-pod
    ```

    **Get the logs**

    ```sh
    kubectl logs myapp-pod
    ```

    **Delete a Pod**

    ```sh
    kubectl delete pod myapp-pod
    ```
