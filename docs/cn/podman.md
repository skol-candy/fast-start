---
Title: Lab CN 2 - Podman Containers
hide:
    - toc
---

# Lab CN 2 - Podman Containers

In this lab, you will learn about how to use podman and how to run applications using podman. This lab will not explicitly give you the commands to progress through these exercises, but will show you a similar expected output.

**It's your goal to create the commands needed (shown as < command > at each step) to complete the lab.**

## Prerequisites

- Create a [Quay account](https://quay.io/){target="_blank"}. This account is needed to push images to a container registry. Follow the [tutorial](https://quay.io/tutorial/){target="_blank"} to get familiar with interacting with Quay
- You need to install [Podman Desktop](https://podman-desktop.io/){target="_blank"} in your environment. Follow the instructions [here](https://podman-desktop.io/docs/installation/macos-install){target="_blank"} to install it on MacOS and [here](https://podman-desktop.io/docs/installation/windows-install){target="_blank"} to install it on Windows.

## Working with podman

Before proceeding, make sure podman is properly installed on your system.

1. Please verify your Podman by looking up the version.

If it is installed, you will see a version number something similar to below.

```bash
$ <command>
Client:       Podman Engine
Version:      5.3.0
API Version:  5.3.0
Go Version:   go1.23.3
Git Commit:   874bf2c301ecf0ba645f1bb45f81966cc755b7da
Built:        Wed Nov 13 03:10:17 2024
OS/Arch:      darwin/amd64

Server:       Podman Engine
Version:      5.2.2
API Version:  5.2.2
Go Version:   go1.22.6
Built:        Wed Aug 21 10:00:00 2024
OS/Arch:      linux/amd64
```

**Running a hello-world container**

Let us start with a `hello-world` container.

2. run a `hello-world` container.

If it is successfully run, you will see something like below.

```bash
$ <command>
Trying to pull quay.io/podman/hello:latest...
Getting image source signatures
Copying blob sha256:81df7ff16254ed9756e27c8de9ceb02a9568228fccadbf080f41cc5eb5118a44
Copying config sha256:5dd467fce50b56951185da365b5feee75409968cbab5767b9b59e325fb2ecbc0
Writing manifest to image destination
!... Hello Podman World ...!

         .--"--.           
       / -     - \         
      / (O)   (O) \        
   ~~~| -=(,Y,)=- |         
    .---. /`  \   |~~      
 ~/  o  o \~~~~.----. ~~   
  | =(X)= |~  / (O (O) \   
   ~~~~~~~  ~| =(Y_)=-  |   
  ~~~~    ~~~|   U      |~~ 

Project:   https://github.com/containers/podman
Website:   https://podman.io
Desktop:   https://podman-desktop.io
Documents: https://docs.podman.io
YouTube:   https://youtube.com/@Podman
X/Twitter: @Podman_io
Mastodon:  @Podman_io@fosstodon.org
```

Since, `hello-world` image is not existing locally, it is pulled from `podman/hello`. But if it is already existing, podman will not pull it every time but rather use the existing one.

This image is pulled from https://quay.io/repository/podman/hello?. Quay.io is a repository used to store container images. Similarly, you can use your own registries to store images.

**Verifying the hello-world image**

1. Now verify if an image is existing in your system locally.

You will then see something like below.

```bash
$ <command>
REPOSITORY                              TAG         IMAGE ID      CREATED       SIZE
quay.io/podman/hello                    latest      5dd467fce50b  6 months ago  787 kB
```

## Get the sample application

To get the sample application, you will need to clone it from github.

```bash
# Clone the sample app
git clone https://github.com/ibm-cloud-architecture/cloudnative_sample_app.git

# Go to the project's root folder
cd cloudnative_sample_app/
```

## Run the application on Podman

> :warning: If you are looking to build this application on Apple Silicon, these instructions **will not work**! Look out for this symbol - :apple: - in the below instructions if you get stuck!

### Build the container image

Let's take look at the Containerfile, sometimes referred to as a Dockerfile before building it.

```sh
FROM maven:3.3-jdk-8 as builder

COPY . .
RUN mvn clean install

FROM openliberty/open-liberty:springBoot2-ubi-min as staging

COPY --chown=1001:0 --from=builder /target/cloudnativesampleapp-1.0-SNAPSHOT.jar /config/app.jar
RUN springBootUtility thin \
    --sourceAppPath=/config/app.jar \
    --targetThinAppPath=/config/dropins/spring/thinClinic.jar \
    --targetLibCachePath=/opt/ol/wlp/usr/shared/resources/lib.index.cache
```

- Using the `FROM` instruction, we provide the name and tag of an image that should be used as our base. This must always be the first instruction in the Containerfile.
- Using `COPY` instruction, we copy new contents from the source filesystem to the container filesystem.
- `RUN` instruction executes the commands.

This Containerfile leverages multi-stage builds, which lets you create multiple stages in your Dockerfile to do certain tasks.

In our case, we have two stages.

- The first one uses `maven:3.3-jdk-8` as its base image to download and build the project and its dependencies using Maven.
- The second stage uses `openliberty/open-liberty:springBoot2-ubi-min` as its base image to run the compiled code from the previous stage.

The advantage of using the multi-stage builds approach is that the resulting image only uses the base image of the last stage. Meaning that in our case, we will only end up with the `openliberty/open-liberty:springBoot2-ubi-min` as our base image, which is much tinier than having an image that has both Maven and the JRE.

By using the multi-stage builds approach when it makes sense to use it, you will end up with much lighter and easier to maintain images, which can save you space on your Container Registry. Also, having tinier images usually means less resource consumption on your worker nodes, which can result cost-savings.

Once, you have the Containerfile ready, the next step is to build it. The `build` command allows you to build a image which you can later run as a container.

1. Build the Containerfile with the `image_name` of `greeting` and give it a `image_tag` of `v1.0.0` and build it using the current context.

You will see something like below:

```
    $ <command>
    Step 1/6 : FROM maven:3.3-jdk-8 as builder
    ---> 9997d8483b2f
    Step 2/6 : COPY . .
    ---> c198e3e54023
    Step 3/6 : RUN mvn clean install
    ---> Running in 24378df7f87b
    [INFO] Scanning for projects...
    .
    .
    .
    [INFO] Installing /target/cloudnativesampleapp-1.0-SNAPSHOT.jar to /root/.m2/repository/projects/cloudnativesampleapp/1.0-SNAPSHOT/cloudnativesampleapp-1.0-SNAPSHOT.jar
    [INFO] Installing /pom.xml to /root/.m2/repository/projects/cloudnativesampleapp/1.0-SNAPSHOT/cloudnativesampleapp-1.0-SNAPSHOT.pom
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 44.619 s
    [INFO] Finished at: 2020-04-06T16:07:04+00:00
    [INFO] Final Memory: 38M/385M
    [INFO] ------------------------------------------------------------------------
    Removing intermediate container 24378df7f87b
    ---> cc5620334e1b
    Step 4/6 : FROM openliberty/open-liberty:springBoot2-ubi-min as staging
    ---> 021530b0b3cb
    Step 5/6 : COPY --chown=1001:0 --from=builder /target/cloudnativesampleapp-1.0-SNAPSHOT.jar /config/app.jar
    ---> dbc81e5f4691
    Step 6/6 : RUN springBootUtility thin     --sourceAppPath=/config/app.jar     --targetThinAppPath=/config/dropins/spring/thinClinic.jar     --targetLibCachePath=/opt/ol/wlp/usr/shared/resources/lib.index.cache
    ---> Running in 8ea80b5863cb
    Creating a thin application from: /config/app.jar
    Library cache: /opt/ol/wlp/usr/shared/resources/lib.index.cache
    Thin application: /config/dropins/spring/thinClinic.jar
    Removing intermediate container 8ea80b5863cb
    ---> a935a129dcb2
    Successfully built a935a129dcb2
    Successfully tagged greeting:v1.0.0
```

---
**:apple: (Apple Silicon only) My build failed!**

If running on M1, you will encounter the following error(s) while building this container image:
```bash
[1/2] STEP 1/3: FROM maven:3.3-jdk-8 AS builder
WARNING: image platform (linux/amd64) does not match the expected platform (linux/arm64)

<output continues...>

[2/2] STEP 1/3: FROM openliberty/open-liberty:springBoot2-ubi-min AS staging
Resolving "openliberty/open-liberty" using unqualified-search registries (/etc/containers/registries.conf.d/999-podman-machine.conf)
Trying to pull docker.io/openliberty/open-liberty:springBoot2-ubi-min...
Error: creating build container: choosing an image from manifest list docker://openliberty/open-liberty:springBoot2-ubi-min: no image found in manifest list for architecture "arm64", variant "v8", OS "linux"
```
In the output above, podman is telling us that the build fails as the base image used by this Containerfile does not support arm64 architectures. 

Try to fix the error yourself. Here are a couple of tips:
1. Base images quickly become outdated and stale. [Try searching `Dockerhub`](https://hub.docker.com/){target="_blank"}
2. If you are unfamiliar with running a Java `.jar` file (lucky you!), have a look at this blog: https://spring.io/guides/gs/spring-boot-docker

If you are **really** stuck, [here](https://github.com/SamChinellato/cloudnative_sample_app){target="_blank"} is repository with an updated Dockerfile.

**Apple Silicon only END**

---


1. Next, verify your newly built image

The output will be as follows.

```bash
$ <command>
REPOSITORY                              TAG                  IMAGE ID      CREATED         SIZE
quay.io/benswinney-ibm/greeting         v1.0.0               7674fa09c091  8 seconds ago   542 MB
quay.io/podman/hello                    latest               5dd467fce50b  6 months ago    787 kB
docker.io/openliberty/open-liberty      springBoot2-ubi-min  021530b0b3cb  5 years ago     486 MB
docker.io/library/maven                 3.3-jdk-8            9997d8483b2f  7 years ago     669 MB
```

### Run the podman container

Now let's try running the podman container. Run it with the following parameters:

1. Expose port `9080`. Run it in the background in detached mode. Give the container the name of `greeting`.

Once done, you will have something like below.

```bash
$ <command>
bc2dc95a6bd1f51a226b291999da9031f4443096c1462cb3fead3df36613b753
```

Also, podman cannot create two containers with the same name. If you try to run the same container having the same name again, you will see something like below.

```bash
$ <command>
podman: Error response from daemon: Conflict. The container name "/greeting" is already in use by container "a74b91789b29af6e7be92b30d0e68eef852bfb24336a44ef1485bb58becbd664". You have to remove (or rename) that container to be able to reuse that name.
See 'podman run --help'.
```

It is a good practice to name your containers. Naming helps you to discover your service easily.

4. List all the running containers.

You will see something like below.

```bash
$ <command>
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                              NAMES
bc2dc95a6bd1        greeting:v1.0.0     "/opt/ol/helpers/run…"   18 minutes ago      Up 18 minutes       0.0.0.0:9080->9080/tcp, 9443/tcp   greeting
```

5. Let's inspect the running container.

By inspecting the container, you can access detailed information about the container. By using this command, you get to know the details about network settings, volumes, configs, state etc.

If we consider our container, it is as follows. You can see lot of information about the `greeting` container.

```json
$ <command>
[
     {
          "Id": "7674fa09c09194abc3641e913b8ef9127658921e01a07cccbd26e74031f30784",
          "Digest": "sha256:ef292f1f1e573e46b140cce57a4da269c231f7bba4352a4c066bc6313edabb7c",
          "RepoTags": [
               "quay.io/benswinney-ibm/greeting:v1.0.0"
          ],
          "RepoDigests": [
               "quay.io/benswinney-ibm/greeting@sha256:ef292f1f1e573e46b140cce57a4da269c231f7bba4352a4c066bc6313edabb7c"
          ],
          "Parent": "08b3dcd861a5b3a854cf9361120f6f68f0608ef855027108c8f67e2b7db06d09",
          "Comment": "Imported from -",
          "Created": "2024-11-25T05:31:04.216084457Z",
          "Config": {
               "User": "1001",
               "ExposedPorts": {
                    "9080/tcp": {},
                    "9443/tcp": {}
               },
               "Env": [
                    "PATH=/opt/ol/wlp/bin:/opt/ol/docker/:/opt/ol/helpers/build:/opt/ibm/java/jre/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                    "container=oci",
                    "JAVA_VERSION=1.8.0_sr5fp40",
                    "JAVA_HOME=/opt/ibm/java/jre",
                    "IBM_JAVA_OPTIONS=-Xshareclasses:name=liberty,nonfatal,cacheDir=/output/.classCache/ -XX:+UseContainerSupport",
                    "LOG_DIR=/logs",
                    "WLP_OUTPUT_DIR=/opt/ol/wlp/output",
                    "WLP_SKIP_MAXPERMSIZE=true",
                    "RANDFILE=/tmp/.rnd"
               ],
        ..........
        ..........
        ..........
    }
]
```

6. Get the logs of the `greeting` container.

It helps you to access the logs of your container. It allows you to debug the container if it fails. It also lets you to know what is happening with your application.

At the end, you will see something like below.

```bash
$ <command>
.   ____          _            __ _ _
/\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
\\/  ___)| |_)| | | | | || (_| |  ) ) ) )
'  |____| .__|_| |_|_| |_\__, | / / / /
=========|_|==============|___/=/_/_/_/
:: Spring Boot ::        (v2.1.7.RELEASE)
2019-08-30 16:57:01.494  INFO 1 --- [ecutor-thread-5] application.SBApplication                : Starting SBApplication on bc2dc95a6bd1 with PID 1 (/opt/ol/wlp/usr/servers/defaultServer/dropins/spring/thinClinic.jar started by default in /opt/ol/wlp/output/defaultServer)
2019-08-30 16:57:01.601  INFO 1 --- [ecutor-thread-5] application.SBApplication                : No active profile set, falling back to default profiles: default
[AUDIT   ] CWWKT0016I: Web application available (default_host): http://bc2dc95a6bd1:9080/
2019-08-30 16:57:09.641  INFO 1 --- [cutor-thread-25] o.s.web.context.ContextLoader            : Root WebApplicationContext: initialization completed in 7672 ms
2019-08-30 16:57:12.279  INFO 1 --- [ecutor-thread-5] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 15 endpoint(s) beneath base path '/actuator'
2019-08-30 16:57:12.974  INFO 1 --- [ecutor-thread-5] o.s.s.concurrent.ThreadPoolTaskExecutor  : Initializing ExecutorService 'applicationTaskExecutor'
2019-08-30 16:57:13.860  INFO 1 --- [ecutor-thread-5] d.s.w.p.DocumentationPluginsBootstrapper : Context refreshed
2019-08-30 16:57:13.961  INFO 1 --- [ecutor-thread-5] d.s.w.p.DocumentationPluginsBootstrapper : Found 1 custom documentation plugin(s)
2019-08-30 16:57:14.020  INFO 1 --- [ecutor-thread-5] s.d.s.w.s.ApiListingReferenceScanner     : Scanning for api listing references
2019-08-30 16:57:14.504  INFO 1 --- [ecutor-thread-5] application.SBApplication                : Started SBApplication in 17.584 seconds (JVM running for 33.368)
[AUDIT   ] CWWKZ0001I: Application thinClinic started in 21.090 seconds.
[AUDIT   ] CWWKF0012I: The server installed the following features: [el-3.0, jsp-2.3, servlet-4.0, springBoot-2.0, ssl-1.0, transportSecurity-1.0, websocket-1.1].
[AUDIT   ] CWWKF0011I: The defaultServer server is ready to run a smarter planet. The defaultServer server started in 33.103 seconds.
```

This shows that the Spring Boot application is successfully started.

### Access the application

- To access the application, open the browser and access http://localhost:9080/greeting?name=John.

--- 
**:apple: (Apple silicon only) My application isn't working!**

If you used the Apple Silicon Dockerfile provided, your application is not running on port 9080. Look at application logs and expose the right port, or...
<details><summary><b>Cheat and get the answer now</b></summary>
Port 8080
</details>


**Apple Silicon only END**

---

You will see something like below.

```bash
{"id":2,"content":"Welcome to Cloudnative bootcamp !!! Hello, John :)"}
```

**Container Image Registry**

Container Image Registry is a place where you can store the container images. They can be public or private registries. They can be hosted by third party as well. In this lab, we are using Quay.

### Pushing an image to a Registry

Let us now push the image to the Quay registry. Before pushing the image to the registry, one needs to login.

7. Login to Quay using your credentials.

Once logged in we need to take the image for the registry.

8. Tag your image for the image registry using the `same name and tag from before`. Be sure to include the host name of the target image registry in the destination tag (e.g. quay.io). _NOTE: the tag command has both the source tag and repository destination tag in it._

9. Now push the image to the registry. This allows you to share images to a registry.

If everything goes fine, you will see something like below.

```bash
$ <command>
The push refers to repository [quay.io/<repository_name>/greeting]
2e4d09cd03a2: Pushed
d862b7819235: Pushed
a9212239031e: Pushed
4be784548734: Pushed
a43c287826a1: Mounted from library/ibmjava
e936f9f1df3e: Mounted from library/ibmjava
92d3f22d44f3: Mounted from library/ibmjava
10e46f329a25: Mounted from library/ibmjava
24ab7de5faec: Mounted from library/ibmjava
1ea5a27b0484: Mounted from library/ibmjava
v1.0.0: digest: sha256:21c2034646a31a18b053546df00d9ce2e0871bafcdf764f872a318a54562e6b4 size: 2415
```

Once the push is successful, your image will be residing in the registry.

### Clean Up

10. Stop the `greeting` container.

11. Remove the container.

12. Remove the image. (_NOTE: You will need the image_id to remove it._)

### Pulling an image from the registry

Sometimes, you may need the images that are residing on your registry. Or you may want to use some public images out there. Then, we need to pull the image from the registry.

13. Pull the image `greeting` from the registry,

If it successfully got pulled, we will see something like below.

```bash
ddcb5f219ce2: Pull complete
e3371bbd24a0: Pull complete
49d2efb3c01b: Pull complete
Digest: sha256:21c2034646a31a18b053546df00d9ce2e0871bafcdf764f872a318a54562e6b4
Status: Downloaded newer image for <repository_name>/greeting:v1.0.0
docker.io/<repository_name>/greeting:v1.0.0
```

## Conclusion

You have successfully completed this lab! Let's take a look at what you learned and did today:

- Learned about the Containerfile.
- Learned about podman images.
- Learned about podman containers.
- Learned about multi-stage podman builds.
- Ran the Greetings service on Podman.

