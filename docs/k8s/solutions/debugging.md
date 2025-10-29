---
Title: Lab K8s 4 - Troubleshooting Solution
hide:
    - toc
---

# Lab K8s 4 - Troubleshooting Solution

## Solution

1. Use the project `debug`

    ```bash
    oc project debug
    ```

2. Check `STATUS` column for not Ready

    ```
    oc get pods --all-namespaces
    ```

3. Check the description of the deployment

    ```
    oc describe deployment hyper-drive
    ```

4. Save logs for a broken pod
    
    ```
    oc logs <pod name> -n <namespace> > /home/cloud_user/debug/broken-pod-logs.log
    ```

5. In the description you will see the following is wrong:

    - Selector and Label names do not match.
    - The Probe is TCP instead of HTTP Get.
    - The Service Port is 80 instead of 8080.

6. To fix probe, can't `oc edit` will not work. To the deployment it is best to delete and recreate the deployment.

    ```
    oc get deployment <deployment name> -n <namespace> -o yaml --export > hyper-drive.yml
    ```

7. Delete pod
   
    ```
    oc delete deployment <deployment name> -n <namespace>
    ```

8. Can also use `oc replace` or `oc apply` to apply the updated deployment yaml.

    ```
    oc apply -f hyper-drive.yml -n <namespace>
    ```

9. Verify

    ```
    oc get deployment <deployment name> -n <namespace>
    ```
