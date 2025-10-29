---
Title: Lab CN 1 - Image Registries
hide:
    - toc
---

# Lab CN 1 - Image Registries

A registry is a repository used to store and access container images. Container registries can support container-based application development, often as part of DevOps processes.

!!! Tip "Associate your Quay.io account with your Red Hat account!"
    If you haven't used Quay.io in a while and already have an account, you may need to associate Quay.io and Red Hat logins.  [See this article](https://access.redhat.com/articles/5363231){target="_blank"} for help.

Container registries save developers valuable time in the creation and delivery of cloud-native applications, acting as the intermediary for sharing container images between systems. They essentially act as a place for developers to store container images and share them out via a process of uploading (pushing) to the registry and downloading (pulling) into another system, like a Kubernetes cluster.

[Learn More :fontawesome-solid-globe:](https://www.redhat.com/en/topics/cloud-native-apps/what-is-a-container-registry){ .md-button target="_blank"}

=== "Tutorial"

      Make sure you have Podman Desktop installed and up and running. You may need to first visit [Quay.io](https://quay.io){target="_blank"} and set up a username. Use the Red Hat account you created earlier.

      ``` Bash title="Login to Quay"
      podman login quay.io
      Username: your_username
      Password: your_password
      ```

      First we'll create a container with a single new file based off of the busybox base image: 
      ``` Bash title="Create a new container"
      podman run busybox echo "fun" > newfile
      ```
      The container will immediately terminate, so we'll use the command below to list it:
      ```
      podman ps -a
      ```
      The next step is to commit the container to an image and then tag that image with a relevant name so it can be saved to a repository.

      In the below command you must replace:
      
      - <container_id> with your container id from the previous command
      - <namespace> with a namespace of your choice. For a personal account this will be: name_surname_ibm
      - <repository_name> with a name for the repository

      ``` Bash title="Create a new image"
      podman commit <container_id> quay.io/<namespace>/<repository_name>
      ```

      Now that we've tagged our image with a repository name, we can push the repository to Quay Container Registry:
      ``` Bash title="Push the image to Quay"
      podman push quay.io/<namespace>/<repository_name>
      ```
      Your repository has now been pushed to Quay Container Registry!

      To view your repository, click on the button below:
      
      [Repositories](https://quay.io/repository/){ .md-button target="_blank"}

      