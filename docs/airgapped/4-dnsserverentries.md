---
title: Entries in DNS server
hide:
    - toc
---

These are the DNS entries for the DNS servers:

|**Type** |**FQDN hostname**| **IP Address**|
|---------|-----------------|---------------|
|**Bastion**    |bastion.ocp4.platformengineers.xyz      |192.168.252.23|
|               |bastiononline.ocp4.platformengineers.xyz|192.168.252.22|
|**Bootstrap**  |bootstrap.ocp4.platformengineers.xyz    |192.168.252.3|
|**Control Plane**     |controlplane01.ocp4.platformengineers.xyz     |192.168.252.4|
|               |controlplane02.ocp4.platformengineers.xyz     |192.168.252.5|
|               |controlplane03.ocp4.platformengineers.xyz     |192.168.252.6|
|**Infra**      |infra01.ocp4.platformengineers.xyz      |192.168.252.7|
|               |infra02.ocp4.platformengineers.xyz      |192.168.252.8|
|               |infra03.ocp4.platformengineers.xyz      |192.168.252.9|
|**Compute**     |compute01.ocp4.platformengineers.xyz     |192.168.252.10|
|               |compute02.ocp4.platformengineers.xyz     |192.168.252.11|
|               |compute03.ocp4.platformengineers.xyz     |192.168.252.12|
|**Storage**     |storage01.ocp4.platformengineers.xyz     |192.168.252.13|
|               |storage02.ocp4.platformengineers.xyz     |192.168.252.14|
|               |storage03.ocp4.platformengineers.xyz     |192.168.252.15|

And these are the service names:

|**Name** |**FQDN hostname** |**Type** |**IP**|
|---------|------------------|---------|------|
|**VIP API**        |api.ocp4.platformengineers.xyz|A/AAA or CNAME|192.168.252.24|
|**VIP API-INT**    |api-int.ocp4.platformengineers.xyz|A/AAA or CNAME|192.168.252.24|
|**VIP Ingress**       |*.apps.ocp4.platformengineers.xyz|A/AAA or CNAME|192.168.252.25|
