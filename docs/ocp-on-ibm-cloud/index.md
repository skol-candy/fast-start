---
Title: OpenShift on IBM Cloud (IPI)
hide:
    - toc
---

#  OpenShift on IBM Cloud (IPI)

This exercise is designed to prepare you for installing a self-managed OpenShift cluster on IBM Cloud Infrastructure, leveraging the Installer Provisioned Infrastructure (IPI) tool. As an alternative to managed OpenShift offerings from hyperscalers such as Red Hat OpenShift Kubernetes Service (ROKS), AWS Red Hat OpenShift Service on AWS (ROSA), and Microsoft Azure Red Hat OpenShift (ARO), this guide focuses on the installation process for a self-managed OpenShift cluster.

Managed OpenShift offerings from hyperscalers provide a simplified experience for deploying OpenShift clusters. However, these services require you to use their specific command-line interfaces and web consoles to install and manage clusters. In contrast, this exercise will guide you through the installation of a self-managed OpenShift cluster using IPI.

Before proceeding with the installation process, it is essential to understand the common concepts and services used in hyperscalers:

- **Region:** A geographic location where a cloud provider offers its services, typically consisting of one or more data centers.
- **Virtual Private Cloud (VPC):** A logical isolation of resources within the cloud, providing a secure environment for your applications.
- **Availability Zone:** Isolated or separated data center(s) located within specific regions, offering high availability and scalability.
- **Security Group:** A virtual firewall that controls incoming and outgoing traffic to and from instances within the VPC, ensuring security and access control.
- **Application Load Balancer:** A type of load balancer designed to handle HTTP and HTTPS traffic, distributing workloads across multiple instances.
- **Application Gateway:** A device or system that connects two different networks or systems together, enabling data exchange between them.
- **Object Storage:** A type of cloud storage that stores data as objects, providing a cost-effective, scalable, and highly available solution.

## Outcomes

Upon completing this exercise, you will have the ability to:

- Install a self-managed OpenShift cluster on IBM Cloud using IPI.
- Backup the etcd database to IBM Cloud Object Storage.

## Scenario

To demonstrate the installation process, we will create a five-node OpenShift cluster with three control plane nodes and two compute nodes, each meeting the specified requirements:

| Node type	     | vCPU | Memory in GiB | Disk size in GB |
| :------------- | :--: | :-----------: | :-------------: |
| Control Plane  | 4 | 16 | 100 |
| Compute        | 8 | 32 | 100 |

The Cloud Credential Operator is required for this installation. If you would like to learn more about the Cloud Credential Operator, please refer to the [Cloud Credential Operator](https://docs.openshift.com/container-platform/4.17/authentication/managing_cloud_provider_credentials/about-cloud-credential-operator.html){target="_blank"} documentation.

## Provision the lab environment

1. Navigate to the [OpenShift Installation Cohort](https://techzone.ibm.com/collection/openshift-installation-cohort){target="_blank"} collection in TechZone.

2. Reserve the "Virtual Server on VPC" environment.

Once you have completed these steps, you will be ready to proceed with installing your self-managed OpenShift cluster using IPI.
