---
Title: Lab K8s 9 - Network Policies Solution
hide:
    - toc
---

# Lab K8s 9 - Network Policies Solution

## Solution


```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: my-network-policy
spec:
  podSelector:
    matchLabels:
      app: secure-app
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          allow-access: "true"
```
