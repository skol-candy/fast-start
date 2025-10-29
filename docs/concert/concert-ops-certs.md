# Managing Operations

## Objective

In order to use Operation dimension, an organisation need to ingest its application certificates or environment certificates in IBM Concert using either Concert toolkit or workflows. Then in Concert we can view the list of certificates and their validity status. Then we can create tickets in third-party ticketing system to renew or replace expiring certificates.

In this lab, you will manually use the concert toolkit to upload our micro-services certificates in IBM Concert.

## Prerequisite

- [x] IBM Concert must be installed
- [x] You have run the manual data ingestion

## Certificates Data Ingestion

Certificates can be ingested into Concert following several way:

- Using the built-in Concert Workflow Certificate Ingestion from a kubeadm (in Administration->Integration->Create Ingestion job)

![drawing](../images/certificate_builtin_ingestion_jobs.png){width=400}

- Using the concert-toolkit for application certificates during the CI/CD process

**We will use Concert toolkit to ingest a sample certificate in Concert.**  
Here are the manual steps to follow:

  1. Connect on the machine you have provisioned on Techzone in Lab0

    ```bash
    ssh itzuser@<VM ip address> -p 2223 -i /path/to/concert/sshkey/pem_ibmcloudvsi_download.pem
    umask 022
    ```

  2. Take a look at the certificate template provided by Concert Toolkit

    ```bash
    cd $HOME/concert-bootcamp/SBOMs-ingestion/templates
    vi cert-sbom-values.yaml.template
    ```

    In this file you can see that it is possible to generate certificate SBOMs using 3 ways:

      - Line 22: Providing an URL (we will use this method)
      - Line 26: Reading certificate files
      - Line 33: Providing certificates details manually

    >As you have not deployed the application components in these labs, we use the https://www.ibm.com url to get the certificate. In a real deployment environment, you will replace this URL with your application deployment URLs.
    >

  3. Source the ingestion job environment variables for hr-app component

    ```bash
    cd $HOME/concert-bootcamp/SBOMs-ingestion
    source app-common-variables.variables
    source hr-app.variables
    ```

  4. Create a concert toolkit config file from the certificate template

    ```bash
    envsubst < templates/cert-sbom-values.yaml.template > $HOME/concert-bootcamp/SBOMs-ingestion/concert_data/${COMPONENT_NAME}/cert-sbom-values.yaml
    ```

  5. Generate the certificate SBOM using Concert toolkit

    ```bash
    APP_COMMAND="cert-inventory --cert-config /app/sample/cert-sbom-values.yaml"
    SRC_PATH="$HOME/concert-bootcamp/SBOMs-ingestion/concert_data/${COMPONENT_NAME}"
    OUTPUTDIR="$HOME/concert-bootcamp/SBOMs-ingestion/concert_data/${COMPONENT_NAME}"
    podman run -v "${SRC_PATH}":/app/sample  -v "${OUTPUTDIR}":/toolkit-data --rm ${CONCERT_TOOLKIT_IMAGE} /bin/bash -c "${APP_COMMAND}"
    ```

  6. Patch the sbom generated

    At the time we write this lab (May 2025), there is 1 issue in the sbom generated. Follow this steps to correct it:

    ```bash
    sudo chmod 666 $HOME/concert-bootcamp/SBOMs-ingestion/concert_data/${COMPONENT_NAME}/certificates-hr-app.json
    vi $HOME/concert-bootcamp/SBOMs-ingestion/concert_data/${COMPONENT_NAME}/certificates-hr-app.json
    ```

    - Reduce the number of **dns_names** entries
    ![drawing](../images/certificate_modif3.png){width=600}

    - Save the file (:wq)

  7. Upload the certificate file in Concert using Concert API

    ```bash
    curl -k -X "POST" -H "accept: application/json" -H "InstanceID: ${CONCERT_INSTANCE_ID}" -H "Authorization: C_API_KEY ${CONCERT_APIKEY}" -H "Content-Type: multipart/form-data" -F "data_type=certificate" -F "filename=@${OUTPUTDIR}/certificates-hr-app.json" "https://${CONCERT_HOST}:${CONCERT_PORT}/ingestion/api/v1/upload_files"
    ```

  8. Check your certificate upload in IBM Concert UI

    After logging in your IBM Concert UI, you can see your ingested certificate from the **Operation** dimension.   

    - First, you can check that the upload is successfull by looking at menu **Administration->Event log**. Here you can see the status of all the files ingested

        ![drawing](../images/events_log.png){width=600}

    - Then, you can navigate the the menu **Dimensions->Operation** to see your certificate

        ![drawing](../images/operation_certificate.png){width=600}


## Certificates management

Walkthrough the uploaded certificates:

- Home page - Operations dimension
- Operation Dimension
- Select a certificate
- Renewal if expired
