---
title: Load Balancer Configuration
hide:
    - toc
---

We will configure the HAProxy load balancer within the "offline" Bastion node, as follows:

|**Front End** |**Targets** |**Port**|
|---------|------------------|---------|
|**\*.apps.ocp4.platformengineers.xyz**   |infra01.ocp4.platformengineers.xyz |80|
|                               |infra02.ocp4.platformengineers.xyz||
|                               |infra03.ocp4.platformengineers.xyz|| 
|                               |compute01.ocp4.platformengineers.xyz||
|                               |compute02.ocp4.platformengineers.xyz||
|                               |compute03.ocp4.platformengineers.xyz||
|                               |storage01.ocp4.platformengineers.xyz||
|                               |storage02.ocp4.platformengineers.xyz||
|                               |storage03.ocp4.platformengineers.xyz||
|**\*.apps.ocp4.platformengineers.xyz**   |infra01.ocp4.platformengineers.xyz|443|
|                               |infra02.ocp4.platformengineers.xyz||
|                               |infra03.ocp4.platformengineers.xyz||
|                               |compute01.ocp4.platformengineers.xyz||
|                               |compute02.ocp4.platformengineers.xyz||
|                               |compute03.ocp4.platformengineers.xyz||
|                               |storage01.ocp4.platformengineers.xyz||
|                               |storage02.ocp4.platformengineers.xyz||
|                               |storage03.ocp4.platformengineers.xyz||
|**api.ocp4.platformengineers.xyz**      |bootstrap.ocp4.platformengineers.xyz|6443|
|                               |controlplane01.ocp4.platformengineers.xyz||
|                               |controlplane02.ocp4.platformengineers.xyz||
|                               |controlplane03.ocp4.platformengineers.xyz||
|**api-int.ocp4.platformengineers.xyz**  |bootstrap.ocp4.platformengineers.xyz|22623|
|                               |controlplane01.ocp4.platformengineers.xyz||
|                               |controlplane02.ocp4.platformengineers.xyz||
|                               |controlplane03.ocp4.platformengineers.xyz||
