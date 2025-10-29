#!/bin/bash

#Creat deploy manifests for test, pre-prod, prod 
echo $CIRRUS_PIPELINE

# Check the variables to fit your pattern 
if [[ -z "$CIRRUS_PIPELINE" ]];
  then
     echo "Please set the variables ..."
     exit 1
fi

echo "Deleting existing manifests.."
rm deploy/pre-production/*.yaml
rm deploy/production/*.yaml
rm deploy/test/*.yaml 

echo pre-prod application

cat > deploy/pre-production/application.yaml << EOF
apiVersion: cirrus.ibm.com/v1alpha1
kind: Application
metadata:
  name: ${CIRRUS_PIPELINE}-pre-prod 
  livenessProbe:
    httpGet:
      path: /
    periodSeconds: 30
    timeoutSeconds: 30
  readinessProbe:
    httpGet:
      path: /
    periodSeconds: 30
    timeoutSeconds: 30
  replicas: 1
  quota: q512mb
EOF

echo pre-prod route

cat > deploy/pre-production/route.yaml << EOF
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: ${CIRRUS_PIPELINE}-pre-prod
EOF

echo prod application
cat > deploy/production/application.yaml << EOF
apiVersion: cirrus.ibm.com/v1alpha1
kind: Application
metadata:
  name: ${CIRRUS_PIPELINE}-prod 
  livenessProbe:
    httpGet:
      path: /
    periodSeconds: 30
    timeoutSeconds: 30
  readinessProbe:
    httpGet:
      path: /
    periodSeconds: 30
    timeoutSeconds: 30
  replicas: 1
  quota: q512mb
EOF

echo prod route
cat > deploy/production/route.yaml << EOF
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: ${CIRRUS_PIPELINE}-prod
EOF

echo test application

cat > deploy/test/application.yaml << EOF
apiVersion: cirrus.ibm.com/v1alpha1
kind: Application
metadata:
  name: ${CIRRUS_PIPELINE}-test 
  livenessProbe:
    httpGet:
      path: /
    periodSeconds: 30
    timeoutSeconds: 30
  readinessProbe:
    httpGet:
      path: /
    periodSeconds: 30
    timeoutSeconds: 30
  replicas: 1
  quota: q512mb
EOF

echo test route

cat > deploy/test/route.yaml << EOS
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: ${CIRRUS_PIPELINE}-test
EOS
