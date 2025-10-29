---
Title: Lab K8s 7 - Cron Jobs
hide:
    - toc
---

# Lab K8s 7 - Cron Jobs

## The Problem

Your commander has a simple data process that is run periodically to check status. They would like to stop doing this manually in order to save time, so you have been asked to implement a cron job in the Kubernetes cluster to run this process. 
 - Create a cron job called xwing-cronjob using the `docker.io/nginx:latest` image. 
 - Have the job run every second minute with the following cron expression: `*/2 * * * *`.
 - Using the echo command, echo out `Welcome to IBM CE Platform Engineer Bootcamp`.

## Verification

- Run `kubectl get cronjobs.batch` and `LAST-SCHEDULE` to see last time it ran
- From a bash shell, run the following to see the logs for all jobs:

```sh
jobs=( $(kubectl get jobs --no-headers -o custom-columns=":metadata.name") )
echo -e "Job \t\t\t\t Pod \t\t\t\t\tLog"
for job in "${jobs[@]}"
do
   pod=$(kubectl get pods -l job-name=$job --no-headers -o custom-columns=":metadata.name")
   echo -en "$job \t $pod \t"
   kubectl logs $pod
done
```
