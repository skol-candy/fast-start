---
title: Infrastructure Services
hide:
    - toc
---

In the 'offline' bastion node, the HTTP server, load balancer, image registry, DNS, and OCP deployment utilities will all be configured.

Given that the network lacks a DHCP server and maintains static IP addresses for all machines, we are required to manually assign each machine's IP, DNS, and hostname details upon creation.
