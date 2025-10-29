---
Title: Lab K8s 3 - Probes Solution
hide:
    - toc
---

# Lab K8s 3 - Probes Solution

## Solution 

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    test: liveness
  name: liveness-example
spec:
  containers:
  - name: liveness
    image: docker.io/busybox
    args:
    - /bin/sh
    - -c
    - touch /tmp/healthz; sleep 40; rm -f /tmp/healthz; sleep 700
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/healthz
      initialDelaySeconds: 6
      periodSeconds: 6
```
