---
Title: Lab K8s 2 - Manage Multiple Containers Solution
hide:
    - toc
---

# Lab K8s 2 - Manage Multiple Containers Solution

## Solution

1. Create a project named web if it does not already exist. 

    ```bash
    oc new-project web
    ```

2. Create a YAML file `vader-service-ambassador-config` that contains the following data.

    ```yaml
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: vader-service-ambassador-config
    data:
      haproxy.cfg: |-
        global
            daemon
            maxconn 256
    
        defaults
            mode http
            timeout connect 5000ms
            timeout client 50000ms
            timeout server 50000ms
    
        listen http-in
            bind *:80
            server server1 127.0.0.1:8989 maxconn 32
    ```

2. Create a YAML File `vader-service` that contains the following data.

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: vader-service
    spec:
      containers:
      - name: millennium-falcon
        image: quay.io/don_bailey_ibm/millennium-falcon:v1.0.0
      - name: haproxy-ambassador
        image: haproxy:1.7
        ports:
        - containerPort: 80
        volumeMounts:
        - name: config-volume
          mountPath: /usr/local/etc/haproxy
      volumes:
      - name: config-volume
        configMap:
          name: vader-service-ambassador-config
    ``` 

3. Create a file `busybox.yaml` that contains the following data.

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: busybox
    spec:
      containers:
      - name: myapp-container
        image: radial/busyboxplus:curl
        command: ['sh', '-c', 'while true; do sleep 3600; done']
    ```

4. Apply all of the YAML files to a cluster.

    ```bash
    oc apply -f vader-service-ambassador-config.yaml
    oc apply -f vader-service.yaml
    oc apply -f busybox.yaml
    ```

5. Verify that the containers are up, running and the expect result is output.

    - For OpenShift

        ```bash
        oc exec busybox -- curl $(oc get pod vader-service -o=jsonpath='{.status.podIP}'):80
        ```

    - For K8s

        ```bash
        kubectl exec busybox -- curl $(kubectl get pod vader-service -o=jsonpath='{.status.podIP}'):80
        ```
