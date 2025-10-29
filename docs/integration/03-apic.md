---
hide:
    - toc
---

# Deploy APIC

Helpful Links:

- Recorded [API Connect Demo](https://ibm.seismic.com/Link/Content/DCMJhGFHMVbpD8QMCfBPmcDjXMCP){target="_blank"}
- API Connect [Sales Kit](https://ibm.seismic.com/Link/Content/DCq968bc9p2qhGCJQ24JHWPGMC83){target="_blank"}
- Client Engineering API Management Playbook **Comming Soon**

## Install Mail Server (mailpit):

As part of API Management, the tooling sends different personae notifications.  Using this simple Mail Server, allows this to happen as part of a Pilot or Demo environment.

Create namespace:

```bash
      oc new-project mailpit
```

Deploy Mail Server:

```bash
scripts/30a-mailpit-deploy-mail-server.sh
```

Confirm the mail server has been deployed successfully before moving to the next step running the following command:
```bash
oc get deployment mailpit -n mailpit -o jsonpath='{.status.conditions[1].status}';echo
```
You should get a response like this:
```
True
```

Create Mail Server Service and Route:
```bash
oc apply -f resources/30b-mailpit-services.yaml
oc apply -f resources/30c-mailpit-route.yaml
```

Get Mail Server UI URL:
```
echo "http://"$(oc get route mailpit-ui -n mailpit -o jsonpath='{.status.ingress[0].host}')
```

Connect to Mail Server by Navigating to the URL and use the credentials to access the UI.

## Install Data Power

As part of APIC Data Power acts as the API Gateway.

1. Install DataPower Catalog Source:
   ```bash
   oc apply -f catalog-sources/${CP4I_VER}/05-datapower-catalog-source.yaml
   ```
   Confirm the catalog source has been deployed successfully before moving to the next step running the following command: 
   ```bash
   oc get catalogsources ibm-datapower-operator-catalog -n openshift-marketplace -o jsonpath='{.status.connectionState.lastObservedState}';echo
   ```
   You should get a response like this:
   ```
   READY
   ```
2. Install DataPower Operator:
   ```bash
   oc apply -f subscriptions/${CP4I_VER}/03-datapower-subscription.yaml 
   ```
   Confirm the operator has been deployed successfully before moving to the next step running the following command:
   ```bash
   SUB_NAME=$(oc get deployment datapower-operator -n openshift-operators --ignore-not-found -o jsonpath='{.metadata.labels.olm\.owner}');if [ ! -z "$SUB_NAME" ]; then oc get csv/$SUB_NAME --ignore-not-found -o jsonpath='{.status.phase}';fi;echo 
   ```
   You should get responses like these for both of them:
   ```
   Succeeded
   ```
## Install APIC Catalog Source and Operator
   
```bash
oc apply -f catalog-sources/${CP4I_VER}/07-api-connect-catalog-source.yaml
```
   
Confirm the catalog source has been deployed successfully before moving to the next step running the following command: 
```bash
oc get catalogsources ibm-apiconnect-catalog -n openshift-marketplace -o jsonpath='{.status.connectionState.lastObservedState}';echo
```
You should get a response like this:
```
READY
```

Install APIC Operator:
```bash
oc apply -f subscriptions/${CP4I_VER}/04-api-connect-subscription.yaml 
```

Confirm the operator has been deployed successfully before moving to the next step running the following command:
```bash
SUB_NAME=$(oc get deployment ibm-apiconnect -n openshift-operators --ignore-not-found -o jsonpath='{.metadata.labels.olm\.owner}');if [ ! -z "$SUB_NAME" ]; then oc get csv/$SUB_NAME --ignore-not-found -o jsonpath='{.status.phase}';fi;echo   
```

You should get responses like these for both of them:
```
Succeeded
```

## Deploy APIC

Deploy APIC instance with some extra features enabled:

```bash
scripts/07d-apic-inst-deploy-instana.sh
```

Confirm the installation completed successfully before moving to the next step running the following commands:
```bash
oc get APIConnectCluster apim-demo -n tools -o jsonpath='{.status.phase}';echo
```
Note this will take almost 30 minutes, so be patient, and at the end you should get a response like this:
```
Ready
```

!!! Tip "APIC is up and running"
   The optional steps below provide some basic configuration for the demo, but at this point you could use the APIC cluster to explore creating, publishing, consuming and managing APIs.  As part of the bootcamp we do not need to perform all of the optional configuration.


## APIC Optional Configuration Steps

### Configure APIC integration with Instana (optional):
```bash
scripts/07e-apic-instana-config.sh
```

Configure the email server in APIC:
```bash
scripts/07f-apic-initial-config.sh
```

Create a Provider Organization for admin user:
```bash
scripts/07g-apic-new-porg-cs.sh
```

### Create an API Provider Organization

Create a Provider Organization for user in local registry (optional):

Set environment variables:
```bash
export USER_NAME=<your-user-name>
export USER_EMAIL=<your-email-address>
export USER_FNAME=<your-first-name>
export USER_LNAME=<your-last-name>
export USER_PWD=<your-personal-password>
```

Create Provide Organization:
```bash
scripts/07h-apic-new-porg-lur.sh
```

### Set API Key for post deployment configuration:

1. Get API Key following instructions listed [here](https://www.ibm.com/docs/en/api-connect/10.0.x?topic=applications-managing-platform-rest-api-keys#taskcapim_mng_apikeys__steps__1){target="_blank"}
2. Set environment variable for API Key:
```
export APIC_API_KEY=<my-apic-api-key>
```

Create secret for Assemblies (optional):
```bash
scripts/07i-apic-secret-cp4i-alt.sh
```
Deploy extra API Gateway (optional):
```bash
scripts/07j-apic-extra-gw-deploy.sh
```
Confirm the instance has been deployed successfully before moving to the next step running the following command:
```bash
oc get gatewaycluster remote-api-gw -n cp4i-dp -o jsonpath='{.status.phase}';echo
```
You should get responses like these:
```
Running
```
