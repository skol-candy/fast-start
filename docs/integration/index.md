---
Title: CP4I End-to-End Demo Deployment
hide:
    - toc
---

# Cloud Pak for Integration

Helpful Links:

- Cloud Pak for Integration [Sales Kit](https://ibm.seismic.com/Link/Content/DC3H4ChgBf72q8FChBXT34X3PQcd){target="_blank"}
- [CP4I Overview and Use Case Video](https://ibm.seismic.com/Link/Content/DCc83WqbPCXqdGFJ3pHb7JjJ8Q7j){target="_blank"}

## IBM Cloud Pak for Integration end to end demonstration

This document describes multiple use cases that highlight the multi-style integration patterns needed by an Integration Specialist to implement a digital transformation initiative that showcase the value Cloud Pak for Integration can provide.  

!!! Note "About this Exercise"
    The steps within this section are taken directly from the [IBM Cloud Pak for Integration end to end demonstration](https://github.ibm.com/joel-gomez/cp4i-demo){target="_blank"} repository maintained by @Joel-Gomez.  Additional explanations have been provided to create additional clarity during certain steps.  Refer back to original repository for the latest code and deployment steps.

## The Scenario

In this demo scenario, a customer has a system of record that has used for many years which was designed to work with MQ to process requirements, and now they want to extend the application to expose an API in a secure way as part of their mobile app.

The requirements don't end there, they are also implementing a new CRM system as a Service and they want to keep both systems in sync without having to modify the original system of record.

Additionally, as part of their digital transformation initiative they want to stay closer to their clients and they want to send email notifications when the client is taking certain actions in their mobile app. To support this strategy, the enterprise architecture team wants to implement an event backbone, as part of their event driven architecture.

The following diagram provides a high level view of the scenario:

![CP4I Demo Image 0](images/CP4I_MultiStyle_DemoScenario.png)

In order to implement this demo you will need to deploy an instance of each one of the following components in your OCP Cluster:

- API Connect Cluster
- Event Streams Cluster
- Queue Manager
- App Connect Enterprise Integration Servers

The following diagram provides a high level implementation view of the scenario with the core capabilities:

![CP4I Demo Image 1](images/CP4I_MultiStyle_HighLevelView.png)

To demonstrate the added value capabilities provided by CP4I you will deploy an instance of the following components in your OCP Cluster:

- Platform UI (formerly known as Platform Navigator)
- Automation Foundation Assets (formerly known as Asset Repository)
- Assemblies

## Getting Started 

To use this guide you will need to clone [the CP4I Demo repo](https://github.ibm.com/joel-gomez/cp4i-demo) repo to your workstation alongside with the [cp4i-ace-artifacts repo](https://github.ibm.com/joel-gomez/cp4i-ace-artifacts) that includes the App Connect Integrations.

There are additional required / useful tools for you to configure on your workstation:

- [oc cli](https://docs.openshift.com/container-platform/4.8/cli_reference/openshift_cli/getting-started-cli.html)
- zip
- keytool
- openssl
- [jq](https://stedolan.github.io/jq/)
- [yq](https://github.com/mikefarah/yq)
- [apic cli](https://www.ibm.com/docs/en/api-connect/10.0.x?topic=configuration-installing-toolkit)

!!! Note "Tool Availability"
    Some of the tools will be available after you deploy an instance of the capability you are working on.

To fully perform the App Connect demonstration you will also need to have a SafesForce Developer Account. To perform the integration that uses the Event End Point Management Gateway you will also need the following tools in your workstation:

- [ACE for Developers](https://www.ibm.com/docs/en/app-connect/12.0?topic=enterprise-download-ace-developer-edition-get-started)
- [podman](https://podman.io/getting-started/installation)

!!! Note "MQ Client"
    The demo also enables the configuration to access the Queue Manager from outside the cluster using MQ Explorer, and optionally from an application using the MQI API. If you want to use this part of the demo you will need to have at least the MQ Client installed in your workstation.  This is not included as part of the bootcamp, but certainly can be helpful when working on pilots with your customers.

Lastly, this guide assumes you already have an OCP cluster with the right version and capacity (v4.16.x or v4.17.x and at least 80 vCPUs and 320 GB of memory, for best results it is recommended to have 5 worker nodes 32 vCPUs X 128 GB memory each) up and running on IBM Cloud, either in your own account or via [TechZone](https://techzone.ibm.com/environments). You should already have this cluster provisioned and you should be logged in from the CLI before continuing.  If you are note using your IPI on VMware install from the bootcamp you can find further instructions to provision a cluster in TechZone.

