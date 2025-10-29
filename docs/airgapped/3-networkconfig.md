---
title: Network Configuration
hide:
    - toc
---

The following table contains the network configuration where the cluster will be installed:

| **Configuration** | **Option** |
|---------------|--------|
|**Subnet name**        |ocp4.platformengineers.xyz|
|**IP address space**   |**192.168.252.0/24**|

The following table contains the OCP network configuration:

| **Option**                        |                       |
|-----------------------------------|-----------------------|
|**Network: External**              ||
|IP address space                   |**192.168.252.0/24**|
|Assigned IP address range          |192.168.252.1-192.168.252.254|
|Number of available IP addresses   |254|
|**Network: Cluster**               ||
|IP address space                   |**9.248.0.0/14**|
|IP address range                   |9.248.0.1-9.248.255.254|
|Subnet prefix                      |24|
|Number of available IP addresses   |262.142|
|Number of IP addresses per node    |254|
|Maximum number of nodes            |1024|
|**Network: Service**               ||
|IP address space                   |**10.248.0.0/16**|
|IP address range                   |10.248.0.1-10.248.255.254|
|Number of available IP addresses   |65.534|
