---
Title: Containers
hide:
    - toc
---

# Containers

You wanted to run your application on different computing environments. It may be your laptop, test environment, staging environment or production environment.

- When you run it on these different environments, will your application work reliably?
- What happens if something changes with the underlying software?
- What if the security policies are different? or something else changes?

To solve this problems, we need Containers.

Containers are a standard way to package an application and all its dependencies so that it can be moved between environments and run without change. They work by hiding the differences between applications inside the container so that everything outside the container can be standardized.

For example, Docker created standard way to create images for Linux Containers.

<iframe width="1206" height="678" src="https://www.youtube.com/embed/0qotVMX-J5s" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Presentations

[Container Basics :fontawesome-regular-file-pdf:](./materials/02-Containers-Basics.pdf){ .md-button }

## Why containers ?

- We can run them anywhere.
- Containers are lightweight.
- Isolate your application from others.

<iframe width="640" height="480" src="https://www.youtube.com/embed/muTkqVewJMI" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Different Container Standards

There are many different container standards available today. Some of them are as follows.

**Docker** - The most common standard, made Linux containers usable by the masses.

**Rocket[^1] (rkt)** - An emerging container standard from CoreOS, the company that developed etcd.

**Garden** - The format Cloud Foundry builds using buildpacks.

Among them, Docker was one of the most popular mainstream container software tools.

***Open Container Initiative (OCI)***

A Linux Foundation project developing a governed container standard. Docker and Rocket[^1] are OCI-compliant. But, Garden is not.

## Benefits

- Lightweight
- Scalable
- Efficient
- Portable
- Supports agile development

To know more about Containerization, we have couple of guides. Feel free to check them out.

- [Containerization: A Complete Guide](https://www.ibm.com/cloud/learn/containerization){target="_blank"}
- [Containers: A Complete Guide](https://www.ibm.com/cloud/learn/containers){target="_blank"}

## Docker

Docker is one of the most popular Containerization platforms which allows you to develop, deploy, and run application inside containers.

- It is an open source project.
- Can run it anywhere.

<iframe width="640" height="480" src="https://www.youtube.com/embed/wFNWl-QwPfc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

An installation of Docker includes an engine. This comes with a daemon, REST APIs, and CLI. Users can use CLI to interact with the docker using commands. These commands are sent to the daemon which listens for the Docker Rest APIs which in turn manages images and containers. The engine runs a container by retrieving its image from the local system or registry. A running container starts one or more processes in the Linux kernel.

### Docker Image

A read-only snapshot of a container that is stored in Docker Hub or in private repository. You use an image as a template for building containers.

These images are build from the `Dockerfile`.

**Dockerfile**

- It is a text document that contains all the instructions that are necessary to build a docker image.
- It is written in an easy-to-understand syntax.
- It specifies the operating system.
- It also includes things like environmental variables, ports, file locations etc.

If you want to try building docker images, try this course on [O'Reilly](https://learning.oreilly.com/videos/docker-for-the/9781788991315/) (Interactive Learning Platform){target="_blank"}.

- [Building Container Images](https://learning.oreilly.com/videos/docker-for-the/9781788991315/9781788991315-video4_2/){target="_blank"} -  Estimated Time: 12 minutes.

### Docker Container

The standard unit where the application service is located or transported. It packages up all code and its dependencies so that the application runs quickly and reliably from one computing environment to another.

If you want to try deploying a docker container, try this course on [O'Reilly](https://learning.oreilly.com/videos/docker-for-the/9781788991315/9781788991315-video4_2/#t11m27s){target="_blank"} (Interactive Learning Platform).

### Docker Engine

Docker Engine is a program that creates, ships, and runs application containers. The engine runs on any physical or virtual machine or server locally, in private or public cloud. The client communicates with the engine to run commands.

If you want to learn more about docker engines, try this course on [O'Reilly](https://learning.oreilly.com/videos/docker-for-the/9781788991315/9781788991315-video7_1/){target="_blank"}

### Docker Registry

The registry stores, distributes, and shares container images. It is available in software as a service (SaaS) or in an enterprise to deploy anywhere you that you choose.

**Docker Hub** is a popular registry. It is a registry which allows you to download docker images which are built by different communities. You can also store your own images there. You can check out various images available on docker hub [here](https://hub.docker.com/search?q=&type=image).


<iframe width="640" height="480" src="https://www.youtube.com/embed/CPJLKqvR8II" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

!!! Information "References"

    - [Docker resources](https://www.docker.com/resources){target="_blank"}
    - [Docker tutorial](https://docs.docker.com/get-started/){target="_blank"}
    - [The Evolution of Linux Containers and Their Future](https://dzone.com/articles/evolution-of-linux-containers-future){target="_blank"}
    - [Open Container Initiative (OCI)](https://www.opencontainers.org){target="_blank"}
    - [Cloud Native Computing Foundation (CNCF)](https://www.cncf.io){target="_blank"}
    - [Demystifying the Open Container Initiative (OCI) Specifications](https://blog.docker.com/2017/07/demystifying-open-container-initiative-oci-specifications){target="_blank"}

[^1]: CoreOS and its Rocket technology was acquired by Red Hat.  [Press Release](https://www.redhat.com/en/about/press-releases/red-hat-acquire-coreos-expanding-its-kubernetes-and-containers-leadership), this acquisition facilitated the creation of Red Hat CoreOS which is the Linux operating system that powers Red Hat OpenShift.
