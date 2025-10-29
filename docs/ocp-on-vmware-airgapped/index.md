---
Title: Deploy Air-Gapped OpenShift Cluster on VMware
hide:
  - toc
---

# Deploy Air-Gapped OpenShift Cluster on VMware

This week, we will install an OpenShift cluster using IPI in an air-gapped environment, also referred to as restricted or disconnected networks. Specifically, this type of environment is defined as follows:

_An air-gapped computer or network is one that has no network interfaces, either wired or wireless, connected to outside networks._

## Objective

Learn how to install an OpenShift cluster in an air-gapped virtualized environment.

## Outcomes

- Install and configure a mirror registry.
- Mirror OpenShift content.
- Install Apache HTTP server.
- Install OpenShift on vSphere using Installer Provisioned Infrastructure (IPI).
- Install Red Hat OpenShift Data Foundation.

## Scenario

Your recently acquired expertise in containerization and OpenShift cluster deployment has caught the attention of your squad manager. You have been assigned the task of installing an OpenShift cluster in an air-gapped environment for a pilot project.

For hosting the mirrored OpenShift content you will install the mirror registry for Red Hat OpenShift. The mirror registry for Red Hat OpenShift is included with the OpenShift subscription and is a small-scale container registry that can be used to mirror the required container images of OpenShift Container Platform in disconnected installations.

The OCP Gymnasium is not air-gapped by default, you need to configure the pfsense firewall/router to fully simulate the air-gapped environment, after the content has been been mirrored.

The cluster requires a total of nine nodes, consisting of three each of control plane, compute, and infrastructure nodes, as specified below.

| Node type      | vCPU | Memory in GiB | Disk size in GB |
| -------------- | :--: | :-----------: | :-------------: |
| control plane  |  4   |      16       |       120       |
| compute        |  4   |      16       |       120       |
| infrastructure |  16  |      64       |       120       |

To fulfill the storage requirements of the applications, installation of OpenShift Data Foundation is necessary.

## Provision the lab environment

Repeat the steps from VMware week.
