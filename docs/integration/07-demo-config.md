---
Title: Additional Demo Config
hide:
    - toc
---

# Additional Configuration Steps for the CP4I Demo

!!! Warning "Extra Configuration"
      You have completed the bootcamp deployment of CP4I and some components.  The below configuration scripts add Demo components.  Proceed if you would like to explore the Cloud Pak in Action!

## Configure APIC for Demo
</summary>

1. Publish draft assets:
   ```
   scripts/14a-apic-create-apis-draft.sh
   ```
2. Configure Catalogs:
   ```
   scripts/14b-apic-config-catalogs-publish-apis.sh
   ```
3. Create New Consumer Organization:
   ```
   scripts/14c-apic-new-consumer-org.sh
   ```
4. Create Apps and Subscriptions:
   ```
   scripts/14d-apic-create-apps-subscription.sh
   ```
5. Deploy Assembly with managed Integration Runtime and Declarative API Product with Security enabled in Demo Catalog (optional):
      ```
      scripts/23c-assembly-inst-deploy.sh
      ```
6. Get Portal access info:
   ```
   scripts/14f-apic-ptl-access-info.sh
   ```

## Enable Aspera (Optional)
</summary>

1. Install Redis Catalog Source:
   ```
   oc apply -f catalog-sources/${CP4I_VER}/11-redis-catalog-source.yaml
   ```
   Confirm the catalog source has been deployed successfully before moving to the next step running the following command: 
   ```
   oc get catalogsources ibm-cloud-databases-redis-operator-catalog -n openshift-marketplace -o jsonpath='{.status.connectionState.lastObservedState}';echo
   ```
   You should get a response like this:
   ```
   READY
   ```
2. Install Aspera Catalog Source:
   ```
   oc apply -f catalog-sources/${CP4I_VER}/12-aspera-catalog-source.yaml
   ```
   Confirm the catalog source has been deployed successfully before moving to the next step running the following command: 
   ```
   oc get catalogsources aspera-operators -n openshift-marketplace -o jsonpath='{.status.connectionState.lastObservedState}';echo   
   ```
   You should get a response like this:
   ```
   READY
   ```
3. Install Aspera Operator:
   ```
   oc apply -f subscriptions/${CP4I_VER}/08-aspera-hsts-subscription.yaml
   ```
   Confirm the operator has been deployed successfully before moving to the next step running the following command:
   ```
   SUB_NAME=$(oc get deployment ibm-aspera-hsts-operator -n openshift-operators --ignore-not-found -o jsonpath='{.metadata.labels.olm\.owner}');if [ ! -z "$SUB_NAME" ]; then oc get csv/$SUB_NAME --ignore-not-found -o jsonpath='{.status.phase}';fi;echo
   ```
   You should get a response like this:
   ```
   Succeeded
   ```

## Install License Service (Optional): 

1. Install License Service Catalog Source:
   ```
   oc apply -f catalog-sources/${CP4I_VER}/02a-license-service-catalog-source.yaml
   ```
   Confirm the catalog source has been deployed successfully before moving to the next step running the following command: 
   ```
   oc get catalogsources ibm-licensing-catalog -n openshift-marketplace -o jsonpath='{.status.connectionState.lastObservedState}';echo
   ```
   You should get a response like this:
   ```
   READY
   ```
2. Create namespace:
   ```
   oc create namespace ibm-licensing
   ```
3. Enable Operator Group in namespace:
   ```
   oc apply -f resources/00-license-service-operatorgroup.yaml
   ```
4. Install License Service Operator:
   ```
   oc apply -f subscriptions/${CP4I_VER}/00-license-service-subscription.yaml
   ```
   Confirm the operator has been deployed successfully before moving to the next step running the following command:
   ```
   SUB_NAME=$(oc get deployment ibm-licensing-operator -n ibm-licensing --ignore-not-found -o jsonpath='{.metadata.labels.olm\.owner}');if [ ! -z "$SUB_NAME" ]; then oc get csv/$SUB_NAME -n ibm-licensing --ignore-not-found -o jsonpath='{.status.phase}';fi;echo
   ```
   You should get a response like this:
   ```
   Succeeded
   ```
   Once the operator is ready check the instance has been deployed successfully running the following command:
   ```
   oc get IBMLicensing instance -n ibm-licensing --ignore-not-found -o jsonpath='{.status.licensingPods[0].conditions[1].status}';echo
   ```
   You should get a response like this:
   ```
   True
   ```
5. Install License Reporter Catalog Source:
   ```
   oc apply -f catalog-sources/${CP4I_VER}/02b-license-reporter-catalog-source.yaml
   ```
   Confirm the catalog source has been deployed successfully before moving to the next step running the following command: 
   ```
   oc get catalogsources ibm-license-service-reporter-operator-catalog -n openshift-marketplace -o jsonpath='{.status.connectionState.lastObservedState}';echo
   ```
   You should get a response like this:
   ```
   READY
   ```
6. Install License Reporter Operator:
   ```
   oc apply -f subscriptions/${CP4I_VER}/00-license-reporter-subscription.yaml
   ```
   Confirm the operator has been deployed successfully before moving to the next step running the following command:
   ```
   SUB_NAME=$(oc get deployment ibm-license-service-reporter-operator -n ibm-licensing --ignore-not-found -o jsonpath='{.metadata.labels.olm\.owner}');if [ ! -z "$SUB_NAME" ]; then oc get csv/$SUB_NAME -n ibm-licensing --ignore-not-found -o jsonpath='{.status.phase}';fi;echo
   ```
   You should get a response like this:
   ```
   Succeeded
   ```
7. Deploy a License Reporter instance:
   ```
   scripts/25-lic-reporter-inst-deploy.sh
   ```
   Confirm the instance has been deployed successfully before moving to the next step running the following command:
   ```
   oc get IBMLicenseServiceReporter ibm-lsr-instance -n ibm-licensing --ignore-not-found -o jsonpath='{.status.LicenseServiceReporterPods[0].conditions[1].status}';echo
   ```
   After a few minutes you should get a response like this:
   ```
   True
   ``` 
8. Configure Data Source:
   ```
   scripts/04c-license-reporter-data-source-config.sh
   ```
9. Get License Service Reporter console access info:
   ```
   scripts/99-lsr-console-access-info.sh
   ```

## Install Serverless (Optional)

1. Create Kafka Topics and User:
   ```
   oc apply -f resources/90h-instanton-es-resources.yaml -n tools
   ```
2. Install Serverless Operator:
   ```
   oc apply -f resources/90a-serverless-namespace.yaml
   oc apply -f resources/90b-serverless-operatorgroup.yaml
   oc apply -f resources/90c-serverless-subscription.yaml
   ```
   Confirm the subscription has been completed successfully before moving to the next step running the following command:
   ```
   SUB_NAME=$(oc get deployment knative-openshift -n openshift-serverless --ignore-not-found -o jsonpath='{.metadata.labels.olm\.owner}');if [ ! -z "$SUB_NAME" ]; then oc get csv/$SUB_NAME -n openshift-serverless --ignore-not-found -o jsonpath='{.status.phase}';fi;echo
   ```
   You should get a response like this:
   ```
   Succeeded
   ```
3. Enable Knative Serving:
   ```
   oc apply -f resources/90d-knative-serving.yaml
   ```
   Confirm that the Knative Serving resources have been created before moving to the next step running the following command:
   ```
   oc get knativeserving.operator.knative.dev/knative-serving -n knative-serving --template='{{range .status.conditions}}{{printf "%s=%s\n" .type .status}}{{end}}'
   ```
   You should get a response like this:
   ```
   DependenciesInstalled=True
   DeploymentsAvailable=True
   InstallSucceeded=True
   Ready=True
   VersionMigrationEligible=True
   ```
4. Enable Knative Eventing:
   ```
   oc apply -f resources/90e-knative-eventing.yaml
   ```
   Confirm that the Knative Serving resources have been created before moving to the next step running the following command:
   ```
   oc get knativeeventing.operator.knative.dev/knative-eventing -n knative-eventing --template='{{range .status.conditions}}{{printf "%s=%s\n" .type .status}}{{end}}'
   ```
   You should get a response like this:
   ```
   DependenciesInstalled=True
   DeploymentsAvailable=True
   InstallSucceeded=True
   Ready=True
   VersionMigrationEligible=True
   ```
5. Install Knative broker for Apache Kafka:
   ```
   scripts/90a-knative-kafka-config.sh
   ```
   Confirm that the Knative broker for Apache Kafka resources have been created before moving to the next step running the following command:
   ```
   oc get pods -n knative-eventing | grep kafka
   ```
   You should get a response like this:
   ```
   kafka-broker-receiver-7c7f46b44f-brhcp                    2/2     Running     0          6m7s
   kafka-channel-dispatcher-6cd7fc889f-2zbqf                 2/2     Running     0          6m9s
   kafka-channel-receiver-7896f6f5c4-t4gn5                   2/2     Running     0          6m8s
   kafka-controller-7bc9964786-tkkkg                         2/2     Running     0          6m8s
   kafka-controller-post-install-1.34.1-pjt8z                0/1     Completed   0          6m11s
   kafka-sink-receiver-84fb98cbb5-89j9l                      2/2     Running     0          6m7s
   kafka-webhook-eventing-bf985b789-4kwl9                    2/2     Running     0          6m8s
   knative-kafka-storage-version-migrator-1.34.1-cx2v8       0/1     Completed   0          6m11s
   ```
6. Prepare namespace:
   ```
   oc new-project libertysurvey
   oc create serviceaccount instanton-sa
   oc apply -f resources/90f-instanton-scc.yaml
   oc adm policy add-scc-to-user cap-cr-scc -z instanton-sa
   ```
7. Patch Knative Serving:
   ```
   oc patch KnativeServing knative-serving -n knative-serving --type merge --patch-file resources/90g-instanton-knative-serving.yaml
   ```
8. Deploy Knative surveyInput Service:
   ```
   scripts/90b-knative-service-surveyinput-config.sh
   ```
   Check service is up and running before moving to the next step running the following command:
   ```
   kn service list surveyinputservice
   ```
   You should get a response like this:
   ```
   NAME                 URL                                                                                           LATEST                     AGE   CONDITIONS   READY   REASON
   surveyinputservice   https://surveyinputservice-libertysurvey.apps.6774a4edfa91429cbef53522.ocp.techzone.ibm.com   surveyinputservice-00001   19h   3 OK / 3     True 
   ```
9. Deploy Knative surveyAdmin Service:
   1. Set the corresponding environment variable, 
      ```
      export GOOGLE_API_KEY=<google_api_key>
      ```
   2. Execute script:
      ```
      scripts/90c-knative-service-surveyadmin-config.sh
      ```
      Check service is up and running before moving to the next step running the following command:
      ```
      kn service list surveyadminservice
      ```
      You should get a response like this:
      ```
      NAME                 URL                                                                                           LATEST                     AGE   CONDITIONS   READY   REASON
      surveyadminservice   https://surveyadminservice-libertysurvey.apps.6774a4edfa91429cbef53522.ocp.techzone.ibm.com   surveyadminservice-00001   18m   3 OK / 3     True  
      ```
   3. Execute script:
      ```
      scripts/90d-knative-kafkasource-surveyadmin-config.sh
      ```
      Check service is up and running before moving to the next step running the following command:
      ```
      kn source kafka describe geocodetopicsource
      ```
      You should get a response like this:
      ```
      Name:         geocodetopicsource
      Namespace:    libertysurvey
      Annotations:  kubectl.kubernetes.io/last-applied-configuration={"apiVersion":"sources.knative.dev/v1beta1","kind":"KafkaSource","metadata":{"annotations":{},"name":"geocodetopicsource","namespace":"libertysurvey"},"spec":{"bootstrapServers":["es-demo-kafka-bootstrap.tools.svc:9095"],"net":{"sasl":{"enable":true,"password":{"secretKeyRef":{"key":"password","name":"kafkasource-es-demo-auth"}},"type":{"secretKeyRef":{"key":"saslType","name":"kafkasource-es-demo-auth"}},"user":{"secretKeyRef":{"key":"user","name":"kafkasource-es-demo-auth"}}},"tls":{"caCert":{"secretKeyRef":{"key":"ca.crt","name":"kafkasource-es-demo-auth"}},"enable":true}},"sink":{"ref":{"apiVersion":"serving.knative.dev/v1","kind":"Service","name":"surveyadminservice"},"uri":"/api/cloudevents/geocodeComplete"},"topics":["geocodetopic"]}}

      Age:               4m
      BootstrapServers:  es-demo-kafka-bootstrap.tools.svc:9095
      Topics:            geocodetopic
      ConsumerGroup:     knative-kafka-source-1f2fc8a0-6ce5-4fd9-93f1-b6c6538b53fa

      Sink:         
      Name:       surveyadminservice
      Namespace:  libertysurvey
      Resource:   Service (serving.knative.dev/v1)
      URI:        /api/cloudevents/geocodeComplete

      Conditions:  
      OK TYPE                   AGE REASON
      ++ Ready                  17s 
      ++ ConsumerGroup          17s 
      ++ SinkProvided           17s 
      ++ OIDCIdentityCreated     4m authentication-oidc feature disabled ()
      ```
10. Deploy Knative surveyGeocoder Service:
   1. Set the corresponding environment variable, 
      ```
      export GOOGLE_API_KEY=<google_api_key>
      ```
   2. Execute script:
      ```
      scripts/90e-knative-service-surveygeocoder-config.sh
      ```
      Check service is up and running before moving to the next step running the following command:
      ```
      kn service list surveygeocoderservice
      ```
      You should get a response like this:
      ```
      NAME                 URL                                                                                           LATEST                     AGE   CONDITIONS   READY   REASON
      surveyadminservice   https://surveyadminservice-libertysurvey.apps.6774a4edfa91429cbef53522.ocp.techzone.ibm.com   surveyadminservice-00001   18m   3 OK / 3     True  
      ```
   3. Execute script:
      ```
      scripts/90f-knative-kafkasource-surveygeocoder-config.sh
      ```
      Check service is up and running before moving to the next step running the following command:
      ```
      kn source kafka describe locationtopicsource
      ```
      You should get a response like this:
      ```
      Name:         locationtopicsource
      Namespace:    libertysurvey
      Annotations:  kubectl.kubernetes.io/last-applied-configuration={"apiVersion":"sources.knative.dev/v1beta1","kind":"KafkaSource","metadata":{"annotations":{},"name":"locationtopicsource","namespace":"libertysurvey"},"spec":{"bootstrapServers":["es-demo-kafka-bootstrap.tools.svc:9095"],"net":{"sasl":{"enable":true,"password":{"secretKeyRef":{"key":"password","name":"kafkasource-es-demo-auth"}},"type":{"secretKeyRef":{"key":"saslType","name":"kafkasource-es-demo-auth"}},"user":{"secretKeyRef":{"key":"user","name":"kafkasource-es-demo-auth"}}},"tls":{"caCert":{"secretKeyRef":{"key":"ca.crt","name":"kafkasource-es-demo-auth"}},"enable":true}},"sink":{"ref":{"apiVersion":"serving.knative.dev/v1","kind":"Service","name":"surveygeocoderservice"},"uri":"/api/cloudevents/locationInput"},"topics":["locationtopic"]}}

      Age:               8s
      BootstrapServers:  es-demo-kafka-bootstrap.tools.svc:9095
      Topics:            locationtopic
      ConsumerGroup:     knative-kafka-source-37ddc05c-2e60-4eb0-ba6b-78a0f77cdbd0

      Sink:         
      Name:       surveygeocoderservice
      Namespace:  libertysurvey
      Resource:   Service (serving.knative.dev/v1)
      URI:        /api/cloudevents/locationInput

      Conditions:  
      OK TYPE                   AGE REASON
      ++ Ready                   7s 
      ++ ConsumerGroup           7s 
      ++ SinkProvided            7s 
      ++ OIDCIdentityCreated     7s authentication-oidc feature disabled ()
      ```

## Install KEDA (Optional)
</summary>

1. Install KEDA using the deployment YAML files:
      
      Note: At the moment we can not use the Operator **Custom Metrics Autoscaler** provided by RedHat because it is using v2.14 which does not support self-signed certificates, so instead we need to use v2.16 from the [KEDA](https://keda.sh/) community project that already supports self-signed certificates. Once the RedHat Operator supports v2.16 I'll update the instructions.
      ```
      oc apply --server-side -f https://github.com/kedacore/keda/releases/download/v2.16.1/keda-2.16.1.yaml
      ```
      Check deployment is ready before moving to the next step running the following commands:
      ```
      oc get deployment keda-admission -n keda --ignore-not-found -o json | jq -r '.status.conditions[] | select(.type | test("Available")).status'
      ```
      Once you get a response like this run the next command:
      ```
      True
      ```
      Run this command:
      ```
      oc get deployment keda-operator -n keda --ignore-not-found -o json | jq -r '.status.conditions[] | select(.type | test("Available")).status'
      ```
      Once you get a response like this go to the next step:
      ```
      True
      ```
2. Deploy MQ resources:
   ```
   scripts/91a-qmgr-rest-api-pre-config.sh
   scripts/91b-qmgr-rest-api-inst-deploy.sh
   ```
   Confirm the instance has been deployed successfully before moving to the next step running the following command:
   ```
   oc get queuemanager qmgr-rest-api -n tools -o jsonpath='{.status.phase}';echo
   ```
   Note this will take few minutes, but at the end you should get a response like this:
   ```
   Running
   ```
3. Deploy ACE resources:
   ```
   scripts/91c-ace-keda-config-policies.sh
   oc apply -f instances/${CP4I_VER}/common/26-ace-is-mqivt-instance.yaml -n tools
   ```
   Confirm the instance has been deployed successfully before moving to the next step running the following command:
   ```
   oc get integrationruntime jgr-mqivt-keda -n tools -o jsonpath='{.status.phase}';echo
   ```
   Note this will take a moment, but at the end you should get a response like this:
   ```
   Ready
   ```
4. Deploy KEDA resources:
   ```
   scripts/91d-keda-resources-config.sh
   ```
   Confirm the resources have been deployed successfully running the following command:
   ```
   oc get scaledobjects ace-keda-demo --ignore-not-found -n tools -o json | jq -r '.status.conditions[] | select(.type | test("Ready")).status'
   ```
   You should get a response like this:
   ```
   True
   ```
