---
Title: Lab CN 3 - Running a Container Locally
hide:
    - toc
---

# Lab CN 3 - Running a Container Locally

In this lab we are going to build on what you completed in Lab 2 and deploy the greeting container image on either OpenShift Local or MiniKube (depending on your setup)

## Prerequisites
- Completed Cloud Native Lab 1 and 2
- OpenShift Local or MiniKube installed on your machine
- The Openshift Client CLI (`oc`) or `kubectl` installed on your machine
- Greeting container image pushed to your personal Quay registry.

## Start Your Local Cluster


=== "OpenShift Local"

    1. Refer to the [OpenShift Local docs](https://developers.redhat.com/products/openshift-local/overview) to ensure OpenShift Local is running on your local machine.

    > **:information:** OpenShift local requires 10GB of memory to run. Make sure that you have that amount of memory available on the system as you start the install.

    2. Once `OpenShift Local` has started, follow the instructions printed to the terminal to log in via the cli. Then check the node is running happily:

    ```bash
    oc get nodes
    ```

    Expected output:

    ```bash
    NAME   STATUS   ROLES                         AGE   VERSION
    crc    Ready    control-plane,master,worker   21d   v1.30.7
    ```

=== "MiniKube"

    Refer to the [MiniKube docs](https://minikube.sigs.k8s.io/docs/) to start MiniKube. 

    1. Once MiniKube has started, check the node is running and the right context is set in `kubectl`:

    ```bash
    kubectl get nodes
    ```

    Expected output:
    
    ```bash
    NAME       STATUS   ROLES           AGE   VERSION
    minikube   Ready    control-plane   60s   v1.32.0
    ```



## Run the application as a pod

This lab will not be covering Kubernetes in detail, but we are going to cover a very simple deployment. 

>:information: You can use `oc` and `kubectl` interchangeably for this section of the lab 


1. A pod is the smallest deployable unit in Kubernetes. You can deploy the greeting application from lab 2 with the following command:

```bash
kubectl run greeting --image quay.io/<repository_name>/greeting:<tag>
```

2. Check the pod is up and running:
   
```bash
kubectl get pods
```

Expected output: 

```bash
NAME       READY   STATUS    RESTARTS   AGE
greeting   1/1     Running   0          106s
```

3. You can find more information on the pod using the `describe` command:

```bash
kubectl describe pod greeting
```
Expected ouptut:

```bash
Name:             greeting
Namespace:        default
Priority:         0
Service Account:  default
Node:             minikube/192.168.49.2
Start Time:       Wed, 29 Jan 2025 13:27:27 +1100
Labels:           run=greeting
Annotations:      <none>
Status:           Running
IP:               10.244.0.4
IPs:
  IP:  10.244.0.4
Containers:
  greeting:
    Container ID:   docker://866d0711b4c08b461421f9a22aa9702f9c37c33c3e185a68d806b4158577c094
    Image:          quay.io/samuele_chinellato_ibm/greeting:v0.0.1
    Image ID:       docker-pullable://quay.io/samuele_chinellato_ibm/greeting@sha256:e540f501125ae9030bcadfbc20a7b2d7d18b766112e76fd5b08f94fe7c56798e
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Wed, 29 Jan 2025 13:28:02 +1100
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-8xqq6 (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       True
  ContainersReady             True
  PodScheduled                True
Volumes:
  kube-api-access-8xqq6:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  6m11s  default-scheduler  Successfully assigned default/greeting to minikube
  Normal  Pulling    6m11s  kubelet            Pulling image "quay.io/samuele_chinellato_ibm/greeting:v0.0.1"
  Normal  Pulled     5m37s  kubelet            Successfully pulled image "quay.io/samuele_chinellato_ibm/greeting:v0.0.1" in 33.663s (33.663s including waiting). Image size: 146552052 bytes.
  Normal  Created    5m37s  kubelet            Created container: greeting
  Normal  Started    5m37s  kubelet            Started container greeting
```

4. Once your pod enters a `running` state, run the following command to access the application from your machine:

```bash
kubectl port-forward pod/greeting 9080:9080
```

Expected output:

```
Forwarding from 127.0.0.1:9080 -> 9080
Forwarding from [::1]:9080 -> 9080
```



5. Open http://localhost:9080/greeting?name=world in your browser. You should see a message from your greeting app!


> **:apple: Apple Silicon Only** replace 9080 with 8080 in the above commands

---

This lab concludes the Cloud Native section of the Platform Engineering BootCamp. You are now ready to move on to [Kubernetes and OpenShift](../k8s/openshift/index.md)