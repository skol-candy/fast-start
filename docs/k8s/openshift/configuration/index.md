---
Title: Container Configuration
hide:
    - toc
---
# Container Configuration

## Command and Argument

When you create a Pod, you can define a command and arguments for the containers that run in the Pod.

The command and arguments that you define in the configuration override the default command and arguments provided by the container file.

- Dockerfile vs Kubernetes
- Dockerfile Entrypoint -> k8s command
- Dockerfile CMD -> k8s args

### Ports

When you create a Pod, you can specify the port number the container exposes, as best practice is good to put a `name`, this way a service can specify targetport by name reference.

### Environment Variables

When you create a Pod, you can set environment variables for the containers that run in the Pod. To set environment variables, include the env or envFrom field in the container configuration

A Pod can use environment variables to expose information about itself to Containers running in the Pod. Environment variables can expose Pod fields and Container fields

### Resources

=== "OpenShift & Kubernetes"

    [Container Commands :fontawesome-solid-gear:](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/){ .md-button target="_blank"}

    [Environment Variables :fontawesome-solid-gear:](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/){ .md-button target="_blank"}

    [Pod Exposing :fontawesome-solid-gear:](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/#exposing-pods-to-the-cluster){ .md-button target="_blank"}

### References

```{ .yaml linenums="1" hl_lines="9" title="Simple Command, No Arguments" .copy }
apiVersion: v1
kind: Pod
metadata:
  name: my-cmd-pod
spec:
  containers:
    - name: myapp-container
      image: busybox
      command: ["echo"]
  restartPolicy: Never
```

```{ .yaml linenums="1" hl_lines="9-10" title="Simple Command With Arguments" .copy }
apiVersion: v1
kind: Pod
metadata:
  name: my-arg-pod
spec:
  containers:
    - name: myapp-container
      image: busybox
      command: ["echo"]
      args: ["Hello World"]
  restartPolicy: Never
```

```{ .yaml linenums="1" hl_lines="9-10" title="Expose a Network Port" .copy }
apiVersion: v1
kind: Pod
metadata:
  name: my-port-pod
spec:
  containers:
    - name: myapp-container
      image: bitnami/nginx
      ports:
        - containerPort: 8080
```

```{ .yaml linenums="1" hl_lines="10-14" title="Use Environment Variables as Arguments" .copy }
apiVersion: v1
kind: Pod
metadata:
  name: my-env-pod
spec:
  restartPolicy: Never
  containers:
    - name: c
      image: busybox
      env:
        - name: DEMO_GREETING
          value: "Hello from the environment"
      command: ["echo"]
      args: ["$(DEMO_GREETING)"]
```

```{ .yaml linenums="1" hl_lines="12-29" title="Use Environment Variables AND Name Exposed Port" .copy }
apiVersion: v1
kind: Pod
metadata:
  name: my-inter-pod
  labels:
    app: jedi
spec:
  restartPolicy: Never
  containers:
    - name: myapp
      image: bitnami/nginx
      ports:
        - containerPort: 8080
          name: http
      env:
        - name: MY_NODE_NAME
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName
        - name: MY_POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: MY_POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
      command: ["echo"]
      args: ["$(MY_NODE_NAME) $(MY_POD_NAME) $(MY_POD_IP)"]
```

## Resource Requirements

When you specify a Pod, you can optionally specify how much CPU and memory (RAM) each Container needs. When Containers have resource requests specified, the scheduler can make better decisions about which nodes to place Pods on.

CPU and memory are each a resource type. A resource type has a base unit. CPU is specified in units of cores, and memory is specified in units of bytes.

### Resources

=== "OpenShift & Kubernetes"

    [Compute Resources :fontawesome-solid-screwdriver-wrench:](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container){ .md-button target="_blank"}

    [Memory Management :fontawesome-solid-screwdriver-wrench:](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/){ .md-button target="_blank"}

### References

```{ .yaml linenums="1" hl_lines="11-17" title="Pod Specific Resources" .copy }
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: my-app
      image: bitnami/nginx
      ports:
        - containerPort: 8080
      resources:
        requests:
          memory: "64Mi"
          cpu: "250m"
        limits:
          memory: "128Mi"
          cpu: "500m"
```


```{ .yaml linenums="1" hl_lines="4 6-11" title="Namespaced Defaults Memory" .copy }
apiVersion: v1
kind: LimitRange
metadata:
  name: mem-limit-range
spec:
  limits:
    - default:
        memory: 512Mi
      defaultRequest:
        memory: 256Mi
      type: Container
```

```{ .yaml linenums="1" hl_lines="4 6-11" title="Namespaced Defaults CPU" .copy }
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-limit-range
spec:
  limits:
    - default:
        cpu: 1
      defaultRequest:
        cpu: 0.5
      type: Container
```

## Activities

| Task                  | Description                                            | Link                                                     |
| --------------------- | ------------------------------------------------------ | :------------------------------------------------------- |
| **_Try It Yourself_** |                                                        |                                                          |
| Pod Configuration     | Configure a pod to meet compute resource requirements. | [Pod Configuration](../../pod-config.md) |
