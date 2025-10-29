---
Title: Lab K8s 7 - Cron Jobs Solution
hide:
    - toc
---

# Lab K8s 7 - Cron Jobs Solution

## Solution

```
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: pe-bootcamp
spec:
  schedule: "*/2 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: cron-pe-bootcamp
              image: nginx:latest
              command:
                - /bin/sh
                - -c
                - echo Welcome to IBM CE Platform Engineer Bootcamp
          restartPolicy: OnFailure
```

```
kubectl get cronjob xwing-cronjob
```
