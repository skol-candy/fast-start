---
Title: Lab K8s 8 - Services Solution
hide:
    - toc
---

# Lab K8s 8 - Services Solution

## Solution

```yaml
apiVersion: v1
kind: Service
metadata:
  name: jedi-svc
spec:
  type: NodePort
  selector:
    app: jedi
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: yoda-svc
spec:
  type: ClusterIP
  selector:
    app: yoda
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
```




