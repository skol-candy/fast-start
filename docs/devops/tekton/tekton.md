---
Title: Lab CI 1 - Tekton
hide:
    - toc
---

## Prerequisites

- :white_check_mark: Make sure your OpenShift environment is properly setup. Follow the instructions [here](../../index.md#environment-setup)
- :white_check_mark: OpenShift Cluster deployed
- :white_check_mark: ODF and storage configured
- :white_check_mark: Internal registry configured

## SetUp

### Tekton CLI Installation

[Tekton CLI](https://github.com/tektoncd/cli) is command line utility used to interact with the Tekton resources.

Follow the instructions on the tekton CLI github repository https://github.com/tektoncd/cli#installing-tkn

For MacOS for example you can use brew:

```bash 
brew tap tektoncd/tools
brew install tektoncd/tools/tektoncd-cli
```
Verify the Tekton cli
```
tkn version
```
The command should show a result like:
```
Client version: 0.39.1
```
If you already have the `tkn` CLI installed you can upgrade by running:
```
brew upgrade tektoncd/tools/tektoncd-cli
```

### OpenShift Pipelines Operator Installation

Install the OpenShift Pipelines Operator ([You can find some instructions here](https://docs.openshift.com/pipelines/1.17/install_config/installing-pipelines.html))


!!! Note
    Version will vary based on the version of OpenShift you are running.
 
    
***Note***: It will take few mins for the OpenShift Pipelines components to be installed, check the status using the `oc` command.

!!! question "OpenShift Pipelines vs Tekton"
    You may notice we sometimes use Tekton and OpenShift Pipelines interchangeably in this guide. OpenShift Pipelines is a Red-Hat-provided Operator that installs and manages Tekton on OpenShift. All Tekton concepts apply to `OpenShift Pipelines`.
 

## Create Target Namespace

Set an environment variable `NAMESPACE` to `tekton-demo` and create a namespace using that variable.

## Tasks

### Task Creation

- Create the below yaml files:
```yaml
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: java-test
spec:
  params:
      - name: url
        default: https://github.com/ibm-cloud-architecture/cloudnative_sample_app
      - name: revision
        default: master
  steps:
      - name: git-clone
        image: alpine/git
        script: |
          git clone -b $(params.revision) --depth 1 $(params.url) /workspace/source
      - name: test
        image: maven:3.3-jdk-8
        workingdir: /workspace/source
        script: |
          mvn test
          echo "tests passed with rc=$?"
        volumeMounts:
          - name: m2-repository
            mountPath: /root/.m2
  volumes:
      - name: m2-repository
        emptyDir: {}
  workspaces:
    - description: |
        Container build context, like for instance a application source code
        followed by a `Dockerfile`.
      name: source
```

When defining a task, will need to define the following:

#### Parameters  
Allows passing configurable values to the Task.

[Review how to configure `parameters` on the Tekton Documentation](https://tekton.dev/docs/pipelines/tasks/#specifying-parameters)
 
---
#### Workspaces  
Provides shared storage for data between steps or Tasks.

[Review how to configure `workspaces` on the Tekton Documentation](https://tekton.dev/docs/pipelines/workspaces/#using-workspaces-in-tasks)


#### Steps  
Defines the containerized commands executed in the Task. 

[Review how to configure `steps` on the Tekton Documentation](https://tekton.dev/docs/pipelines/tasks/#defining-steps)


Validate you have run the task successfully unsing the tekton cli:

```bash
NAME        AGE
java-test   22 seconds ago
```

> **HINT**: run `tkn task --help`

### TaskRun

A `TaskRun` allows you to instantiate and execute a `Task` on-cluster. A `Task` specifies one or more `Steps` that execute container images and each container image performs a specific piece of build work. A `TaskRun` executes the `Steps` in the `Task` in the order they are specified until all Steps have executed successfully or a failure occurs.

[Review how to configure `TaskRuns` on the Tekton Documentation](https://tekton.dev/docs/pipelines/taskruns/)

In the following section we will run the `build`-app task created in the previous step.


#### TaskRun Creation

The following snippet shows what a Tekton TaskRun YAML looks like:

```yaml
apiVersion: tekton.dev/v1
kind: TaskRun
metadata:
  generateName: java-test-
spec:
  params:
    - name: url
      value: 'https://github.com/ibm-cloud-architecture/cloudnative_sample_app.git'
    - name: revision
      value: master
  serviceAccountName: pipeline
  taskRef:
    kind: Task
    name: java-test
  timeout: 1h0m0s
  workspaces:
    - name: source
      emptyDir: {}
```

* **`generateName`** since the `TaskRun` can be run many times, in order to have unique name across the `TaskRun` ( helpful when checking the TaskRun history) we use this `generateName` instead of name. When Kubernetes sees `generateName` it will generate unique set of characters and suffix the same to build-app-, similar to how pod names are generated.
  
* **`taskRef`** this is used to refer to the `Task` by its name that will be run as part of this `TaskRun`. In this example we use build-app `Task`.

* As described in the earlier section that the `Task` inputs and outputs could be overridden via `TaskRun`.
 
* **`params`** the parameter values that are passed to the task

Run the task from a task run.

> **HINT** - look at the `oc create` command.

We can use the Tekton cli to inspect the created resources.

The `tkn` command should list one TaskRun as shown below:
```bash
NAME                   STARTED        DURATION   STATUS
java-test-9rkkt        1 minute ago   ---        Running(Pending)
```

> **Note** - It will take few seconds for the TaskRun to show status as `Running` as it needs to download the container images.


Check the logs of the Task Run using the `tkn` CLI.

> **Note** - Each task step will be run within a container of its own. **HINT**: `tkn tr logs --help`


Use the `tkn` CLI to ensure the task has run successfully. You should see an output like this:

```bash
NAME                                STARTED          DURATION   STATUS
java-test-9rkkt                     36 minutes ago   33s        Succeeded
```

## Pipelines

### Pipeline Creation

Pipelines allows to start multiple Tasks, in parallel or in a [certain order](https://github.com/tektoncd/pipeline/blob/master/docs/pipelines.md#runafter)

Create an `app-build` Pipeline containing two Tasks:

```yaml
apiVersion: tekton.dev/v1
kind: Pipeline
metadata:
  name: app-build
spec:
  params:
    - name: source_repo
      type: string
    - name: image_registry
      type: string
  tasks:
    - name: java-test
      params:
        - name: url
          value: $(params.source_repo)
        - name: revision
          value: master
      taskRef:
        kind: Task
        name: java-test
      workspaces:
        - name: source
          workspace: source
    - name: buildah-build
      params:
        - name: IMAGE
          value: $(params.image_registry)
        - name: DOCKERFILE
          value: ./Dockerfile
        - name: CONTEXT
          value: .
        - name: STORAGE_DRIVER
          value: vfs
        - name: FORMAT
          value: oci
        - name: BUILD_EXTRA_ARGS
          value: ''
        - name: PUSH_EXTRA_ARGS
          value: ''
        - name: SKIP_PUSH
          value: 'false'
        - name: TLS_VERIFY
          value: 'true'
        - name: VERBOSE
          value: 'false'
      runAfter:
        - java-test
      taskRef:
        params:
          - name: kind
            value: task
          - name: name
            value: buildah
          - name: namespace
            value: openshift-pipelines
        resolver: cluster
      workspaces:
        - name: source
          workspace: source
  workspaces:
    - name: source
```

!!! information
    A `Pipeline` defines a list of `Tasks` to execute in order, while also indicating if any `outputs` should be used as `inputs` of a following `Task` by using the `from` field. Furthermore, a `Pipeline` defines the order of execution of tasks (using the `runAfter` and `from `fields). The same variable substitution you used in `Tasks` is also available in a `Pipeline`.

    As of OpenShift 4.17, you need to use resolvers in order to reference a Task outside of the namespace. [Read more about cluster resolvers here](https://docs.openshift.com/pipelines/1.17/create/remote-pipelines-tasks-resolvers.html)

Use the Tekton cli to inspect the pipeline is created successfully:

```bash
NAME        AGE              LAST RUN   STARTED   DURATION   STATUS
app-build   31 seconds ago   ---        ---       ---        ---
```

### PipelineRun

#### PipelineRun Creation

To execute the Tasks in the `Pipeline`, you must create a `PipelineRun`. Creation of a `PipelineRun` will trigger the creation of `TaskRuns` for each `Task` in your pipeline. Create the following `PipelineRun`:

```yaml
apiVersion: tekton.dev/v1
kind: PipelineRun
metadata:
  generateName: app-build-run-
  labels:
    tekton.dev/pipeline: app-build
spec:
  params:
    - name: source_repo
      value: 'https://github.com/ibm-cloud-architecture/cloudnative_sample_app.git'
    - name: image_registry
      value: 'image-registry.openshift-image-registry.svc:5000/tekton-demo/cloud-native-sample-app:v1.0.0'
  pipelineRef:
    name: app-build
  taskRunTemplate:
    serviceAccountName: pipeline
  timeouts:
    pipeline: 1h0m0s
  workspaces:
    - name: source
      volumeClaimTemplate:
        metadata:
          creationTimestamp: null
        spec:
          accessModes:
            - ReadWriteOnce
          resources:
            requests:
              storage: 1Gi
          volumeMode: Filesystem
          storageClassName: ocs-storagecluster-cephfs
        status: {}
```

**serviceAccount** - it is always recommended to have a service account associated with `PipelineRun`, which can then be used to define fine grained roles. It's important to understand Service Accounts when working with Tekton and other applications. [Take a minute to review service accounts here](https://docs.openshift.com/container-platform/4.17/authentication/using-service-accounts-in-applications.html)

Use the Tekton cli to inspect the created resources, the command should list one PipelineRun as shown below:

```bash
NAME                  STARTED          DURATION   STATUS
app-build-run-2cfbx   1 minutes ago    ---        Running
```

Wait for few minutes for your pipeline to complete all the tasks. If it is successful, you will see something like below:

Use the `tkn` cli to check the pipeline has completed successfully:

```bash
NAME              AGE              LAST RUN                    STARTED         DURATION    STATUS
app-build   33 minutes ago         app-build-run-2cfbx         2 minutes ago   2 minutes   Succeeded
```

If it is successful, check that the `ImageStream` has been created successfully using the `oc` command, you will see something like below:

```bash
NAME                      IMAGE REPOSITORY     TAGS     UPDATED
cloud-native-sample-app   default-route...     v1.0.0   5 minutes ago
```

## Deploy Application

* Create a deployment using the `cloud-native-sample-app` `ImageStream`

Verify if the pods are running using the `oc` CLI:

```bash
NAME                           READY   STATUS    RESTARTS   AGE
cloudnative-77df47cfbc-962vx   1/1     Running   0          10s
```

* Expose the deployment as a service on port **9080** and then expose that service as a route using the `oc` cli.

To test you have completed everything successfully, run the following command:
```bash
export APP_URL="$(oc get route cloudnative --template 'http://{{.spec.host}}')/greeting?name=World"
echo APP_URL=$APP_URL
```

```bash
curl $APP_URL
```
Output should be:
```json
{"id":4,"content":"Welcome to Cloudnative bootcamp !!! Hello, World :)"}
```

## Additional Challenge

!!! danger "Additional Challenge"
    You have now successfully deployed your first application using Tekton! If you still have time to spare, here is an extra challenge. You will have noticed that we deployed the application to the cluster manually. Platform Engineers never like to do anything which can be automated manually! **As an extra challenge**, create an application deployment task and add it to the `app-build` pipeline.