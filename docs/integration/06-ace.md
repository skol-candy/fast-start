---
hide:
    - toc
---

# Deploy App Connect 

Helpful Links:

- App Connect [Sales Kit](https://ibm.seismic.com/Link/Content/DCg2mJmTR6gCJG7MqgMGDC4Fb4Hj){target="_blank"}
- API Led Integration with [App Connect Video](https://youtu.be/BpK2Kc7Fg9Q){target="_blank"}
- App Connect [201 Client Presentation](https://ibm.seismic.com/Link/Content/DCXH6qJcW6V4hGQWq8MG6dbcfPhP){target="_blank"}


## Configure the Catalog Source and Operator

Install App Connect Catalog Source:
```bash
oc apply -f catalog-sources/${CP4I_VER}/10-app-connect-catalog-source.yaml 
```
Confirm the catalog source has been deployed successfully before moving to the next step running the following command: 
```bash
oc get catalogsources appconnect-operator-catalogsource -n openshift-marketplace -o jsonpath='{.status.connectionState.lastObservedState}';echo
```
You should get a response like this:
```
READY
```

Install App Connect Operator:
```bash
oc apply -f subscriptions/${CP4I_VER}/07-app-connect-subscription.yaml
```
Confirm the operator has been deployed successfully before moving to the next step running the following command:
```bash
SUB_NAME=$(oc get deployment ibm-appconnect-operator -n openshift-operators --ignore-not-found -o jsonpath='{.metadata.labels.olm\.owner}');if [ ! -z "$SUB_NAME" ]; then oc get csv/$SUB_NAME --ignore-not-found -o jsonpath='{.status.phase}';fi;echo
```
You should get a response like this:
```
Succeeded
```
## Deploy Dashboard Instance

!!! Info "What is the Dashboard?"
      The IBM App Connect Dashboard is a user interface that allows users to deploy BAR files into App Connect containers. It also allows users to perform operations on services, create integration servers, and establish connections to integration servers.

```bash
scripts/09a-ace-dashboard-inst-deploy.sh
```
Confirm the instance has been deployed successfully before moving to the next step running the following command:

```bash
oc get dashboard ace-dashboard -n tools -o jsonpath='{.status.phase}';echo
```
Note this will take few minutes, but at the end you should get a response like this:
```
Ready
```
## Deploy Designer

Deploy Designer Authoring instance with support for Callable Flows

Deploy Switch Server instance:
```bash
scripts/09b-ace-switch-server-inst-deploy.sh
```

Confirm the instance has been deployed successfully before moving to the next step running the following command:
```bash
oc get switchserver ace-switch-server -n tools -o jsonpath='{.status.phase}';echo
```

Note this will take few minutes, but at the end you should get a response like this:
```
Ready
```
Deploy Designer Authoring instance

```bash
scripts/09c-ace-designer-inst-deploy.sh
```
Confirm the instance has been deployed successfully before moving to the next step running the following command:
```bash
oc get designerauthoring ace-designer-ai -n tools -o jsonpath='{.status.phase}';echo
```
Note this will take few minutes, but at the end you should get a response like this:
```
Ready
```

## Create BAR Auth Configuration

!!! Info "What is a BAR?"
            An "app connect BAR" refers to a deployment package file format used within IBM App Connect, where "BAR" stands for "Business Application Archive"; essentially, it's a compressed file containing all the necessary components like integration flows, configurations, and other assets needed to deploy an application within the App Connect platform. 


   ```bash
   scripts/11-ace-config-barauth-github.sh
   ```
   
## Deploy Integrations

1. Create Policy Configuration to integrate with MQ:
      ```bash
      scripts/12a-ace-config-policy-mq.sh
      ```
2. Deploy Integration Runtime instances related to MQ and the API:
      ```bash
      scripts/12c-ace-is-apis-inst-deploy.sh
      ```
      You can check the status using the following command:
      ```bash
      oc get integrationruntimes -n tools
      ```
!!! Info "While you are waiting ..."
      Lets look at a sample ACE integration deployment.  Note where it pulls in the BAR file.  This BAR file provides the configuration for what the instance actually is doing:

      ```{ .yaml linenums="1" hl_lines="28" .no-copy title="11-ace-is-mqapi-dflt-instance.yaml" }
      apiVersion: appconnect.ibm.com/v1beta1
      kind: IntegrationRuntime
      metadata:
      name: jgr-mqapi-dflt
      labels:
      backup.appconnect.ibm.com/component: integrationruntime
      assembly.integration.ibm.com/tools.jgr-demo: 'true'
      spec:
      license:
      accept: true
      license: L-KPRV-AUG9NC
      use: CloudPakForIntegrationNonProduction
      template:
      spec:
            containers:
            - name: runtime
            resources:
                  limits:
                  cpu: 500m
                  memory: 512Mi
                  requests:
                  cpu: 500m
                  memory: 512Mi
      replicas: 1
      version: '13.0'
      barURL: 
      - >-
            https://github.com/gomezrjo/cp4idemo/raw/main/barfiles/jgr-cp4i-mqapi-dflt.bar
      configurations:
      - github-barauth
      - ace-qmgr-demo-policy
      ```

!!! Warning "You are ready to explore App Connect"
      The rest of the configuration steps below are optional, but may be of interest during your exploration of App Connect.  Some of these configurations may provide value during your Pilot deployments.

### Configure Sales Force Connector (Optional)
The Sales Force integration is a very typical example used to learn and demo ACE.  If you followed the prerequisites to create your SF account you can configure that here.
1. Set Environment Variables:  
      ```bash
      export SF_USER=<my-sf-user>
      export SF_PWD=<my-sf-pwd>
      export SF_CLIENT_ID=<my-sf-client-id>
      export SF_CLIENT_SECRET=<my-sf-client-secret>
      export SF_LOGIN_URL=<my-sf-login-url>
      ```
2. Create Sales Force Account Configuration:
      ```bash
      scripts/12b-ace-config-accounts-sf.sh
      ```
3. Set Environment Variable:
      ```bash
      export SF_CONNECTOR=YES
      ```
4. Deploy Integration Runtime instance related to SF:
      ```bash
      scripts/12d-ace-is-sf-inst-deploy.sh
      ```
### Create Configurations related to ES:
```bash
scripts/15a-ace-config-policy-es-scram.sh
scripts/15b-ace-config-setdbparms-es-scram.sh
scripts/15c-ace-config-truststore-es.sh
```
Deploy Integration Runtime instance related to ES:
```bash
scripts/15d-ace-is-es-inst-deploy.sh
```

### Configure Integration with PGSQL DB (Optional)

   1. Create namespace:
      ```bash
      oc create namespace pgsql
      ```
   2. Enable Operator Group in namespace:
      ```bash
      oc apply -f resources/12d-pgsql-operatorgroup.yaml
      ```
   3. Install PGSQL Operator at namespace level:
      ```bash
      oc apply -f resources/12a-pgsql-subscription.yaml
      ```
      Confirm the operator has been deployed successfully before moving to the next step running the following command:
      ```bash
      SUB_NAME=$(oc get deployment pgo -n pgsql --ignore-not-found -o jsonpath='{.metadata.labels.olm\.owner}');if [ ! -z "$SUB_NAME" ]; then oc get csv/$SUB_NAME -n pgsql --ignore-not-found -o jsonpath='{.status.phase}';fi;echo
      ```
      You should get a response like this:
      ```
      Succeeded
      ```
   4. Create configmap with db configuration:
      ```bash
      oc apply -f resources/12b-pgsql-config.yaml -n pgsql
      ```
   5. Create a PGSQL DB instance:
      ```bash
      oc apply -f resources/12c-pgsql-db.yaml -n pgsql
      ```
      Confirm the instance has been deployed successfully before moving to the next step running the following command:
      ```bash
      oc get pods -l "postgres-operator.crunchydata.com/role=master" -n pgsql -o jsonpath='{.items[0].status.conditions[1].status}' 2>/dev/null;echo
      ```
      After a few minutes you should get a response like this:
      ```
      True
      ``` 
   6. Create Configurations related to PGSQL:
      ```bash
      scripts/22a-ace-config-odbc-ini-pgsql.sh
      scripts/22b-ace-config-setdbparms-pgsql.sh
      ```
   7. Set Environment Variable:
      ```bash
      export PGSQL_DB=YES
      ```
### Deploy Integration Runtime Instance to Simulate BackEnd

```bash
scripts/22c-ace-is-be-inst-deploy.sh
```

### Create Configuration for User Defined Policy

```bash
scripts/16-ace-config-policy-udp.sh
```

### Create Configurations related to eMail server

```bash
scripts/17a-ace-config-policy-email.sh
scripts/17b-ace-config-setdbparms-email.sh
```

### Deploy Integration Runtime instance related to ES & eMail
```bash
scripts/18a-ace-is-kafka-inst-deploy.sh
```

## Other OPTIONAL Integration Runtime Examples

Feel free to experiment with additional integration runtime instances below.


### Deploy Integration Runtime instances with fry approach (Optional)

```bash
oc apply -f instances/${CP4I_VER}/18a-ace-is-aceivt-instance-fry.yaml -n tools
oc apply -f instances/${CP4I_VER}/18b-ace-is-aceivt-instance-fry.yaml -n tools
```

### Deploy Integration Runtime instance with bake approach (Optional)

```bash
oc apply -f instances/${CP4I_VER}/19a-ace-is-aceivt-instance-bake.yaml -n tools
```

Confirm the instance has been deployed successfully before moving to the next step running the following command:

```bash
oc get integrationruntimes -n tools
```

You should get a response like this:

```
NAME                        RESOLVEDVERSION   STATUS   REPLICAS   AVAILABLEREPLICAS   URL                                                                                                AGE     CUSTOMIMAGES
jgr-ace-bake-cp4i           12.0.9.0-r3       Ready    2          2                   http://jgr-ace-bake-cp4i-http-tools.apps.6597480c8e1478001153ba0d.cloud.techzone.ibm.com           4d      true
``` 

### Configure HPA for the integration runtime previously deployed (optional)

```bash
oc apply -f resources/09b-ace-hpa-demo.yaml -n tools
```
Confirm HPA has been applied successfully running the following command:
```bash
oc get hpa -n tools | grep ace-is-hpa-demo
```
You should get a response like this:
```bash
ace-is-hpa-demo    IntegrationRuntime/jgr-ace-bake-cp4i   0%/10%    2         5         2          3d23h
```

### Create configuration for Server Config related to MLLP & MQ Request/Reply (optional)

```bash
scripts/21-ace-config-server-config-ach.sh
```

### Deploy Integration Runtime with none HTTP protocol, aka MLLP (optional):

```bash
oc apply -f instances/${CP4I_VER}/common/23-ace-is-ach-hl7-instance.yaml -n tools
```

### Deploy Integration Runtime instances for MQ Request/Reply scenario (optional):

```bash
oc apply -f instances/${CP4I_VER}/27-ace-is-mqreqresp-backend-instance.yaml -n tools
oc apply -f instances/${CP4I_VER}/28-ace-is-mqreqresp-frontend-instance.yaml -n tools
```


