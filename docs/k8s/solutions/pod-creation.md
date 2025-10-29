---
title: Lab K8s 1 - Pod Creation Solution
hide:
    - toc
---

# Lab K8s 1 - Pod Creation Solution

## Solution

1. Create a project named `web`

    ```bash
    oc new-project web
    ```

2. Save the following YAML to a file named `pods.yaml`


    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: nginx
      namespace: web
    spec:
      containers:
      - name: nginx
        image: nginx
        command: ["nginx"]
        args: ["-g", "daemon off;", "-q"]
        ports:
        - containerPort: 80
    ```

3. Apply the YAML created in step 2.

    ```bash
    oc apply -f pod.yaml
    ```
