---
Title: GitOps Overview
hide:
    - toc
---

# GitOps Overview

## DevOps

DevOps is a set of practices, tools, and cultural philosophies that aims to bridge the gap between software development (Dev) and IT operations (Ops). The primary goal of DevOps is to improve the collaboration, communication, and automation of the software development lifecycle, enabling faster, more reliable, and more consistent delivery of high-quality software.

Key principles of DevOps include:

-  **Continuous Integration/Continuous Deployment (CI/CD)**: Automating the software delivery process from code commit to production deployment.
-  **Infrastructure as Code (IaC)**: Managing and provisioning infrastructure using code, enabling version control, automation, and collaboration.
-  **Monitoring and Logging**: Collecting, analyzing, and acting on telemetry data to ensure system health, performance, and security.
-  **Collaboration and Communication**: Encouraging cross-functional teams to work together, share knowledge, and align goals.
-  **Automation**: Automating repetitive tasks to reduce human error, increase efficiency, and free up team resources.
-  **Culture and Mindset**: Fostering a culture of experimentation, learning, and continuous improvement.

## GitOps

GitOps is a practice for automating the configuration and deployment of infrastructure and applications using Git as the single source of truth. It leverages GitOps principles to manage and synchronize the state of OpenShift clusters with the desired configuration defined in Git, ensuring consistency, automation, and collaboration across development, staging, and production environments.

Key GitOps practices include:

-  **Managed OpenShift Clusters**: Using GitOps to manage multiple OpenShift clusters from a single Git repository.
-  **Declarative Configuration**: Using Kubernetes manifests to define resources and their desired state in Git.
-  **Automatic Synchronization**: Automatically syncing the state of OpenShift clusters with the configuration in Git.

## OpenShift Implementation of These Technologies

In OpenShift, Pipelines are implemented as an operator. The OpenShift Pipelines operator manages the creation, update, and deletion of pipelines in Git, and it also handles the integration with OpenShift's built-in CI/CD tools to automate the entire pipeline.  The operator allows teams to define application pipelines in Git, and OpenShift orchestrates the automation of building, testing, and deploying applications based on those pipelines. OpenShift Pipelines uses the opensource Tekton project, to impliment pipelines.


In OpenShift, GitOps is also implemented as an operator. The OpenShift GitOps operator is based on the opensource project ArgoCD.  The operator integrates with OpenShift's built-in infrastructure management tools, such as Kubernetes manifests, Helm charts, and Operators, to automate the deployment and management of applications and infrastructure.

In summary, Pipelines and GitOps are both implemented as operators in OpenShift, enabling teams to automate and manage the CI/CD and infrastructure management processes using Git as the single source of truth and is the foundation for their respective practices.

| Operator Name                                                                                                                                           | Open Source Project | Description                                                                                                              |
|---------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------|--------------------------------------------------------------------------------------------------------------------------|
| [Red Hat OpenShift Pipelines](https://docs.openshift.com/pipelines/1.17/about/about-pipelines.html){ target="_blank" }                                  | tekton 1.17.0       | Tekton primarily focuses on Continiuous Integration (CI) aspect by providing a framework to build and test applications. |
| [Red Hat OpenShift GitOps](https://docs.openshift.com/gitops/1.15/understanding_openshift_gitops/about-redhat-openshift-gitops.html){ target="_blank" } | argoCD 1.15.0       | ArgoCD focuses on Continuous Delivery (CD) by managing application deployments to a cluster based on a Git repository.   |


