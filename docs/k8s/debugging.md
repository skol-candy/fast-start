---
Title: Lab K8s 4 - Troubleshooting
hide:
    - toc
---

# Lab K8s 4 - Troubleshooting

## The Problem

The application is not t working and we need to find out why. Let's debug the `my-deployment` deployment so that we can get the application to run again.

Here are some tips to help you solve the issues with my-deployment in the project `debug`

- Check the description of `my-deployment`.
- Will the image in the Deployment deploy?
- Get and save the logs of one of the broken `pods`.
- Are the correct `ports` assigned.
- Make sure your `labels` and `selectors` are correct.
- Check to see if the `Probes` are correctly working.
- To fix the deployment, save then modify the yaml file for redeployment.

1. Reset the environment:

    ```bash
    oc project default
    oc delete project default
    ```

2. Setup the environment:

    ```bash
    oc apply -f https://gist.githubusercontent.com/csantanapr/e823b1bfab24186a26ae4f9ec1ff6091/raw/1e2a0cca964c7b54ce3df2fc3fbf33a232511877/debugk8s-bad.yaml
    ```

3. Set the project to `debug`.

    ```bash
    oc project default
    ```

## Validate

1. Use the OpenShift console or the `oc cli` to examine the deployment `my-deployment in the project `debug`

    ```bash
    oc project debug
    oc describe deployment my-deployment
    oc get pods
    oc events <podname>
    ```

2. Use the following commands to investigate.  Use the OpenShift console to verify and organize what you are looking at.

    ```bash
    oc get deployments
    oc describe pod <podname>
    oc explain Pod.spec.containers.resources.requests
    oc explain Pod.spec.containers.livenessProbe
    oc edit deployment
    oc logs
    oc events
    oc get pods --show-labels
    oc get deployment --show-labels
    ```
