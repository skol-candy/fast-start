---
hide:
    - toc
---

# Event Automation

Helpful Links:

- Event Automation [Demo Video](https://ibm.seismic.com/Link/Content/DC2TPdFG6bb3M87XXTh3DMP2M8BP){target="_blank"}
- Event Automation [Sales Kit](https://ibm.seismic.com/Link/Content/DC7gPV7jbcWJ682HW3JGCmCJJWJj)
- Client Engineering Event Automation Playbook **Coming Soon**

## Deploy Event Streams

Install Event Streams Catalog Source:
```bash
oc apply -f catalog-sources/${CP4I_VER}/08-event-streams-catalog-source.yaml
```

Confirm the catalog source has been deployed successfully before moving to the next step running the following command: 
```bash
oc get catalogsources ibm-eventstreams-catalog -n openshift-marketplace -o jsonpath='{.status.connectionState.lastObservedState}';echo
```

You should get a response like this:
```
READY
```

Install Event Streams Operator:
```bash
oc apply -f subscriptions/${CP4I_VER}/05-event-streams-subscription.yaml
```

Confirm the operator has been deployed successfully before moving to the next step running the following command:
```bash
SUB_NAME=$(oc get deployment eventstreams-cluster-operator -n openshift-operators --ignore-not-found -o jsonpath='{.metadata.labels.olm\.owner}');if [ ! -z "$SUB_NAME" ]; then oc get csv/$SUB_NAME --ignore-not-found -o jsonpath='{.status.phase}';fi;echo 
```

You should get a response like this:
```
Succeeded
```

Deploy Event Streams instance:
```
scripts/08a-event-streams-inst-deploy.sh
```

!!! Info "What deployment decisions were just made?"
      If you dig through the script you will see that ES is instantiated using the `05-event-streams-instance.yaml` see below with some of the decisions highlighted.  You can use these instance `yaml` examples to deploy your own copies via command line or from the UI in the future.

      ```{ .yaml linenums="1" hl_lines="23 61-70 80-82" .no-copy title="05-event-streams-instance.yaml" }
      apiVersion: eventstreams.ibm.com/v1beta2
      kind: EventStreams
      metadata:
      name: es-demo
      labels:
            backup.eventstreams.ibm.com/component: eventstreams
            assembly.integration.ibm.com/tools.jgr-demo: 'true'
      spec:
      version: latest
      license:
         accept: true
         license: L-JTPV-KYG8TF
         use: CloudPakForIntegrationNonProduction
      adminApi: {}
      adminUI:
         authentication:
            - type: integrationKeycloak
      apicurioRegistry: {}
      collector: {}
      restProducer: {}
      strimziOverrides:
         kafka:
            replicas: 3
            authorization:
            type: simple
            config:
            inter.broker.protocol.version: '3.8'
            log.cleaner.threads: 6
            num.io.threads: 24
            num.network.threads: 9
            num.replica.fetchers: 3
            offsets.topic.replication.factor: 3
            default.replication.factor: 3
            min.insync.replicas: 2
            listeners:
            - name: authsslsvc
               port: 9095
               type: internal
               tls: true
               authentication:
                  type: scram-sha-512
            - name: external
               port: 9094
               type: route
               tls: true
               authentication:
                  type: scram-sha-512
            - name: tls
               port: 9093
               type: internal
               tls: true
               authentication:
                  type: tls
            metricsConfig:
            type: jmxPrometheusExporter
            valueFrom:
               configMapKeyRef:
                  key: kafka-metrics-config.yaml
                  name: minimal-prod-metrics-config
            resources:
            requests:
               memory: 128Mi
               cpu: 100m
            limits:
               memory: 2048Mi
               cpu: 1000m
            storage:
            type: persistent-claim
            size: 4Gi
            class: ${OCP_BLOCK_STORAGE}
         zookeeper:
            replicas: 3
            metricsConfig:
            type: jmxPrometheusExporter
            valueFrom:
               configMapKeyRef:
                  key: zookeeper-metrics-config.yaml
                  name: minimal-prod-metrics-config
            storage:
            type: persistent-claim
            size: 2Gi
            class: ${OCP_BLOCK_STORAGE}
         entityOperator:
            topicOperator: {}
            userOperator: {}
      ```


Confirm the instance has been deployed successfully before moving to the next step running the following command:
```bash
oc get eventstreams es-demo -n tools -o jsonpath='{.status.phase}';echo
```

Note this will take few minutes, so be patient, and at some point you may see some errors, but at the end you should get a response like this:
```
Ready
```
## Event Streams Additional Configuration

Create topics and users:
```bash
oc apply -f resources/02a-es-initial-config-jgr-topics.yaml -n tools
oc apply -f resources/02a-es-initial-config-jgr-users.yaml -n tools
oc apply -f resources/02a-es-initial-config-ea-topics.yaml -n tools
oc apply -f resources/02a-es-initial-config-watsonx-topics.yaml -n tools
```

Enable Kafka Connect base:
```bash
scripts/08c-event-streams-kafka-connect-config.sh
```

Confirm the instance has been deployed successfully before moving to the next step running the following command:
```bash
oc get kafkaconnects jgr-connect-cluster -n tools -o jsonpath='{.status.conditions[0].type}';echo
```
Note this will take few minutes, but at the end you should get a response like this:
```
Ready
```

### Enable Kafka Connect for WatsonX (Optional):
```bash
scripts/08f-event-streams-kafka-connect-watsonx-config.sh
```
Confirm the instance has been deployed successfully before moving to the next step running the following command:
```bash
oc get kafkaconnects watsonx-demo-sources -n tools -o jsonpath='{.status.conditions[0].type}';echo
```
   
Note this will take few minutes, but at the end you should get a response like this:
```
Ready
```
### Enable Kafka Bridge (Optional)

!!! Info "What is Kafka Bridge?"
      A "Kafka Bridge" is a component that allows applications to interact with a Kafka cluster using standard HTTP requests instead of the native Kafka protocol, essentially providing a web API interface to manage producers and consumers within a Kafka cluster without needing to understand the complex Kafka protocol directly; this is typically implemented through a RESTful API, enabling applications that can only speak HTTP to send and receive messages from Kafka topics.  See also Strimzi ...

```bash
scripts/08d-event-streams-kafka-bridge-config.sh
```

Confirm the instance has been deployed successfully running the following command:
```bash
oc get kafkabridge jgr-es-demo-bridge -n tools -o jsonpath='{.status.conditions[0].type}';echo
```

You should get a response like this:
```
Ready
```

### Enable Kafka Connector Base
```bash
scripts/08e-event-streams-kafka-connector-datagen-config.sh
```
Confirm the instances has been deployed successfully before moving to the next step running the following command:
```bash
oc get kafkaconnector -n tools
```
Note this will take few minutes, but at the end you should get a response like this:
```
NAME                 CLUSTER               CONNECTOR CLASS                                                         MAX TASKS   READY
kafka-datagen        jgr-connect-cluster   com.ibm.eventautomation.demos.loosehangerjeans.DatagenSourceConnector   1           True
kafka-datagen-avro   jgr-connect-cluster   com.ibm.eventautomation.demos.loosehangerjeans.DatagenSourceConnector   1           True
kafka-datagen-reg    jgr-connect-cluster   com.ibm.eventautomation.demos.loosehangerjeans.DatagenSourceConnector   1           True
```

## Additional Kafka Connectors / Integrations (Optional)

Enable Kafka Connector Weather for WatsonX (optional):
   1. Set environment variable:
      ```bash
      export OPEN_WEATHER_API_KEY=<your-open-weather-api-key>
      ```
   2. Run script:
      ```bash
      scripts/08g-event-streams-kafka-connector-weather-config.sh
      ```

Enable Kafka Connector Weather for WatsonX (optional):
   1. Set environment variable:
      ```bash
      export ALPHA_VANTAGE_API_KEY=<your-alpha-vantage-api-key>
      ```
   2. Run script:
      ```bash
      scripts/08h-event-streams-kafka-connector-stock-prices-config.sh
      ```

Enable APIC Analytics offloading to Kafka Topic (optional):
   ```bash
   scripts/07k-apic-analytic-offload-config.sh
   ```

Enable APIC to work with EA for WatsonX (optional):
   1. Run script:
      ```bash
      scripts/07l-apic-gw-config-ea-watsonx.sh
      ```
   2. Set environment variable:
      ```bash
      export EA_WATSONX=YES
      ```

## Deploy Event Endpoint Management - EEM (Optional): 

!!! Info "What is Event Endpoint Management?"
      Kafka Event Endpoint Management is a feature that allows organizations to control and manage access to Kafka topics within their event-driven architecture, essentially acting as a centralized portal where developers can discover available event streams and request access to them, providing a self-service method to consume data from different Kafka clusters without needing direct cluster configuration access.

To deploy EEM see the [cp4i-demo source repo README](https://github.ibm.com/joel-gomez/cp4i-demo/blob/main/README.md){target="_blank"}

## Deploy Event Processing (Optional): 

1. Install Apache Flink Catalog Source:
   ```bash
   oc apply -f catalog-sources/${CP4I_VER}/14-ea-flink-catalog-source.yaml
   ```
   Confirm the catalog source has been deployed successfully before moving to the next step running the following command: 
   ```bash
   oc get catalogsources ibm-eventautomation-flink-catalog -n openshift-marketplace -o jsonpath='{.status.connectionState.lastObservedState}';echo
   ```
   You should get a response like this:
   ```
   READY
   ```
2. Install Apache Flink Operator:
   ```bash
   oc apply -f subscriptions/${CP4I_VER}/10-ea-flink-subscription.yaml
   ```
   Confirm the operator has been deployed successfully before moving to the next step running the following command:
   ```bash
   SUB_NAME=$(oc get deployment flink-kubernetes-operator -n openshift-operators --ignore-not-found -o jsonpath='{.metadata.labels.olm\.owner}');if [ ! -z "$SUB_NAME" ]; then oc get csv/$SUB_NAME --ignore-not-found -o jsonpath='{.status.phase}';fi;echo
   ```
   You should get a response like this:
   ```
   Succeeded
   ```
3. Prepare TrustStore for Event Automation:
   ```bash
   scripts/20d-ea-truststore-config.sh
   ```
4. Deploy Apache Flink instance:
   ```bash
   oc apply -f instances/${CP4I_VER}/21-ea-flink-instance.yaml -n tools
   ```
   Confirm the instance has been deployed successfully before moving to the next step running the following command:
   ```bash
   oc get flinkdeployment ea-flink-demo -n tools -o jsonpath='{.status.jobManagerDeploymentStatus}';echo
   ```
   You should get a response like this:
   ```
   READY
   ``` 
5. Install Event Processing Catalog Source:
   ```bash
   oc apply -f catalog-sources/${CP4I_VER}/15-event-processing-catalog-source.yaml
   ```
   Confirm the catalog source has been deployed successfully before moving to the next step running the following command: 
   ```bash
   oc get catalogsources ibm-eventprocessing-catalog -n openshift-marketplace -o jsonpath='{.status.connectionState.lastObservedState}';echo
   ```
   You should get a response like this:
   ```
   READY
   ```
6. Install Event Processing Operator:
   ```bash
   oc apply -f subscriptions/${CP4I_VER}/11-event-processing-subscription.yaml
   ```
   Confirm the operator has been deployed successfully before moving to the next step running the following command:
   ```bash
   SUB_NAME=$(oc get deployment ibm-ep-operator -n openshift-operators --ignore-not-found -o jsonpath='{.metadata.labels.olm\.owner}');if [ ! -z "$SUB_NAME" ]; then oc get csv/$SUB_NAME --ignore-not-found -o jsonpath='{.status.phase}';fi;echo
   ```
   You should get a response like this:
   ```
   Succeeded
   ```
It is assumed you will use local security for this exercise.  

7. Deploy Event Processing instance:
   ```bash
   scripts/20b-ea-ep-inst-deploy.sh
   ```
   Confirm the instance has been deployed successfully before moving to the next step running the following command:
   ```bash
   oc get eventprocessing ep-demo -n tools -o jsonpath='{.status.phase}';echo
   ```
   You should get a response like this:
   ```
   Running
   ``` 
8. Configure Event Processing security:      
   1. Execute the corresponding script:
      ```bash
      scripts/20b-ea-ep-config-sec.sh
      ```
   2. If you enabled integration with KeyCloak then add the EP user role to *integration admin* to grant access, otherwise go to the next step.
9. Install PGSQL Operator (if you didn't do it as part of ACE, otherwise go to the next step):
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
      ```
      SUB_NAME=$(oc get deployment pgo -n pgsql --ignore-not-found -o jsonpath='{.metadata.labels.olm\.owner}');if [ ! -z "$SUB_NAME" ]; then oc get csv/$SUB_NAME -n pgsql --ignore-not-found -o jsonpath='{.status.phase}';fi;echo
      ```
      You should get a response like this:
      ```
      Succeeded
      ```
10. Deploy a PGSQL DB instance (if you didn't do it as part of ACE, otherwise go to the next step):
   1. Create configmap with db configuration:
      ```bash
      oc apply -f resources/12b-pgsql-config.yaml -n pgsql
      ```
   2. Create a PGSQL DB instance:
      ```
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
11. Get information to access EA instances:
      ```bash
      scripts/20c-ea-access-info.sh
      ```

