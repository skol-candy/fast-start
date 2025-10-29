#!/bin/bash 

echo $EAL 
echo $GITHUB_ORG
echo $YOUR_REPO
echo $GITHUB_USER 
echo $YOUR_TOKEN
echo $YOUR_ARTIFACTORY_TOKEN
echo $CIRRUS_API_USERNAME
echo $CIRRUS_API_TOKEN
echo $CIRRUS_PROJECT_NAME
echo $CIRRUS_PIPELINE
echo $CLASSIFY_REPO

# Check the variables to fit your pattern 
if [[ -z "$EAL" || -z "$GITHUB_ORG" || -z "$YOUR_REPO" || -z "$GITHUB_USER" || -z "$YOUR_TOKEN" || -z "$YOUR_ARTIFACTORY_TOKEN" ||  -z "$CIRRUS_API_USERNAME" || -z "$CIRRUS_API_TOKEN" || -z "$CIRRUS_PROJECT_NAME" || -z "$CIRRUS_PIPELINE" ]];
  then
     echo "Please set the variables ..."
     exit 1
fi


export YOUR_SECRET=https://na.artifactory.swg-devops.com/artifactory/api/pypi/hyc-techzone-team-pypi-local/simple/\;\;$CLASSIFY_REPO\;\;$GITHUB_USER\;\;$YOUR_ARTIFACTORY_TOKEN 
echo $YOUR_SECRET


# Create encrypted Cirrus API Username and Token

ENCRYPTED_VALS=`curl -d "{\"githubAccessToken\":\"$YOUR_TOKEN\",\"plainTexts\":{\"cirrusApiUsername\":\"$CIRRUS_API_USERNAME\",\"cirrusApiPassword\":\"$CIRRUS_API_TOKEN\"}}" -H 'Content-Type: application/json' -X POST https://adopter-service-prod.dal1a.cirrus.ibm.com/v1/${GITHUB_ORG}/${YOUR_REPO}/encrypt_all`
echo $ENCRYPTED_VALS

ENCR_CIRRUS_API_USER=$(echo $ENCRYPTED_VALS | jq -r '.cirrusApiUsername')
ENCR_CIRRUS_API_TOKEN=$(echo $ENCRYPTED_VALS | jq -r '.cirrusApiPassword')
echo Encrypted Cirrus API User: $ENCR_CIRRUS_API_USER
echo Encrypted Cirrus API Token: $ENCR_CIRRUS_API_TOKEN
# Create private dependency encrypted value

PRIVATE_DEPENDENCY_VAL=`curl -d "{\"githubAccessToken\":\"${YOUR_TOKEN}\",\"text\":\"${YOUR_SECRET}\"}" -H 'Content-Type: application/json' -X POST https://adopter-service-prod.dal1a.cirrus.ibm.com/v1/${GITHUB_ORG}/${YOUR_REPO}/encrypt | jq '.cipherText'`
echo $PRIVATE_DEPENDENCY_VAL

# Add the build.yaml file
mv build.yml build.yml.old
cat > build.yml << EOF
apiVersion: automation.cio/v1alpha1
kind: RepositoryConfig
ealImapNumber: $EAL
build:
  strategy: container-release
  pipeline: python-v39-poetry-ui-container-image
  version: v1
  config:
    cirrus-project-name: $CIRRUS_PROJECT_NAME
    cirrus-pipeline-name: $CIRRUS_PIPELINE
    distribution-directory: site
    service-port: '8080'
    cirrus-api-username: $ENCR_CIRRUS_API_USER
    cirrus-api-password: $ENCR_CIRRUS_API_TOKEN
    cirrus-region: us-east1
    deploy-verification-memory-request: "q512mb"
    private-dependencies: $PRIVATE_DEPENDENCY_VAL
release:
  environments:
    - name: test
      cirrus-project-name: $CIRRUS_PROJECT_NAME
      deploy-verification-memory-request: "q512mb"
    - name: pre-production
      cirrus-project-name: $CIRRUS_PROJECT_NAME
      deploy-verification-memory-request: "q512mb"
    - name: production
      cirrus-project-name: $CIRRUS_PROD_PROJECT_NAME
      deploy-verification-memory-request: "q512mb"
      is-production: "true"
    - name: $CIRRUS_PIPELINE
      cirrus-project-name: $CIRRUS_PROD_PROJECT_NAME
      cirrus-region: us-east1
      is-production: "true"
EOF




