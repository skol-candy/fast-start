# Intro to Concert Workflows

For this lab exercise, we will install Concert Workflows into an existing Concert deployment (VM deployment) and run our first basic workflow. For the latest documentation on how to achieve this process, consult the [IBM Concert documentation on Concert Workflows add-on](https://www.ibm.com/docs/en/concert?topic=concert-workflows-add).


## Installing Concert Workflows


Concert Workflows run as a containerized application in a Kubernetes cluster. As such, you will need to install a standalone K3s cluster on the VM where you installed IBM Concert.

!!! warning "Environment"
    These instructions have been tested from the Concert VM. [Review how to connect to it in the SBOM lab](./concert/installing/install-vm.md/#install-prerequirements) Some changes may be required if you want to follow from another machine.
    

## Installing Rancher K3s

Install K3s from the command line.  You will need to disable its default ingress controller (traefik), so that port 443 is not in use.  SSH to your concert VM and execute the following commands:

???+ note "Installing Rancher K3s"

    ```bash
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik" sh -s - --write-kubeconfig-mode 644
    export KUBECONFIG=/etc/rancher/k3s/k3s.yaml 
    kubectl get nodes
    ```
???+ success "output"

    ```{.bash .no-copy}
    $ curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik" sh -s - --write-kubeconfig-mode 644
    [INFO]  Finding release for channel stable
    [INFO]  Using v1.31.4+k3s1 as release
    [INFO]  Downloading hash https://github.com/k3s-io/k3s/releases/download/v1.31.4+k3s1/sha256sum-amd64.txt
    [INFO]  Downloading binary https://github.com/k3s-io/k3s/releases/download/v1.31.4+k3s1/k3s
    [INFO]  Verifying binary download
    [INFO]  Installing k3s to /usr/local/bin/k3s
    [INFO]  Finding available k3s-selinux versions
    Updating Subscription Management repositories.
    Rancher K3s Common (stable)                                                                                                     7.3 kB/s | 1.5 kB     00:00
    Red Hat Enterprise Linux 9 for x86_64 - Supplementary (RPMs)                                                                     82 kB/s | 3.7 kB     00:00
    Red Hat Enterprise Linux 9 for x86_64 - AppStream (RPMs)                                                                        104 kB/s | 4.5 kB     00:00
    Red Hat Enterprise Linux 9 for x86_64 - AppStream - Extended Update Support (RPMs)                                               75 kB/s | 4.5 kB     00:00
    Red Hat Enterprise Linux 9 for x86_64 - BaseOS - Extended Update Support (RPMs)                                                 104 kB/s | 4.1 kB     00:00
    Red Hat Enterprise Linux 9 for x86_64 - Supplementary - Extended Update Support (RPMs)                                           72 kB/s | 3.7 kB     00:00
    Red Hat Enterprise Linux 9 for x86_64 - BaseOS (RPMs)                                                                            96 kB/s | 4.1 kB     00:00
    Dependencies resolved.
    ================================================================================================================================================================
    Package                             Architecture             Version                              Repository                                              Size
    ================================================================================================================================================================
    Installing:
    k3s-selinux                         noarch                   1.6-1.el9                            rancher-k3s-common-stable                               22 k
    Installing dependencies:
    container-selinux                   noarch                   3:2.229.0-1.el9_2                    rhel-9-for-x86_64-appstream-eus-rpms                    55 k

    Transaction Summary
    ================================================================================================================================================================
    Install  2 Packages

    Total download size: 77 k
    Installed size: 162 k
    Downloading Packages:
    (1/2): container-selinux-2.229.0-1.el9_2.noarch.rpm                                                                             657 kB/s |  55 kB     00:00
    (2/2): k3s-selinux-1.6-1.el9.noarch.rpm                                                                                         180 kB/s |  22 kB     00:00
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------
    Total                                                                                                                           626 kB/s |  77 kB     00:00
    Rancher K3s Common (stable)                                                                                                      38 kB/s | 2.4 kB     00:00
    Importing GPG key 0xE257814A:
    Userid     : "Rancher (CI) <ci@rancher.com>"
    Fingerprint: C8CF F216 4551 26E9 B9C9 18BE 925E A29A E257 814A
    From       : https://rpm.rancher.io/public.key
    Key imported successfully
    Running transaction check
    Transaction check succeeded.
    Running transaction test
    Transaction test succeeded.
    Running transaction
      Preparing        :                                                                                                                                        1/1
      Running scriptlet: container-selinux-3:2.229.0-1.el9_2.noarch                                                                                             1/2
      Installing       : container-selinux-3:2.229.0-1.el9_2.noarch                                                                                             1/2
      Running scriptlet: container-selinux-3:2.229.0-1.el9_2.noarch                                                                                             1/2
      Running scriptlet: k3s-selinux-1.6-1.el9.noarch                                                                                                           2/2
      Installing       : k3s-selinux-1.6-1.el9.noarch                                                                                                           2/2
      Running scriptlet: k3s-selinux-1.6-1.el9.noarch                                                                                                           2/2
      Running scriptlet: container-selinux-3:2.229.0-1.el9_2.noarch                                                                                             2/2
      Running scriptlet: k3s-selinux-1.6-1.el9.noarch                                                                                                           2/2
      Verifying        : k3s-selinux-1.6-1.el9.noarch                                                                                                           1/2
      Verifying        : container-selinux-3:2.229.0-1.el9_2.noarch                                                                                             2/2
    Installed products updated.

    Installed:
      container-selinux-3:2.229.0-1.el9_2.noarch                                            k3s-selinux-1.6-1.el9.noarch

    Complete!
    [INFO]  Creating /usr/local/bin/kubectl symlink to k3s
    [INFO]  Creating /usr/local/bin/crictl symlink to k3s
    [INFO]  Creating /usr/local/bin/ctr symlink to k3s
    [INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
    [INFO]  Creating uninstall script /usr/local/bin/k3s-uninstall.sh
    [INFO]  env: Creating environment file /etc/systemd/system/k3s.service.env
    [INFO]  systemd: Creating service file /etc/systemd/system/k3s.service
    [INFO]  systemd: Enabling k3s unit
    Created symlink /etc/systemd/system/multi-user.target.wants/k3s.service → /etc/systemd/system/k3s.service.
    [INFO]  Host iptables-save/iptables-restore tools not found
    [INFO]  Host ip6tables-save/ip6tables-restore tools not found
    [INFO]  systemd: Starting k3s
    $ export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
    $ kubectl get nodes
    NAME                         STATUS   ROLES                  AGE   VERSION
    itzvsi-1100007b1r-c9nslidq   Ready    control-plane,master   15s   v1.31.4+k3s1
    ```

## Installing Concert Workflows on a VM

Download the IBM Concert Workflows installer and authenticate to the IBM Entitlement Registry.

!!! warning "Prerequisite"
    You will need an Entitlement key to install Workflows. [Fetch your key or create one here](https://myibm.ibm.com/products-services/containerlibrary){:target="_blank"}.


Create a workspace for the lab:

```bash
mkdir -p ~/workflow-lab && \
cd  ~/workflow-lab
```
???+ note "Downloading installer"

    ```bash
    export DOCKER_EXE=podman
    export CONCERT_REGISTRY=cp.icr.io/cp/concert
    export CONCERT_REGISTRY_USER=cp
    export CONCERT_REGISTRY_PASSWORD="eyJh..." # (1)!
    wget https://github.com/IBM/Concert/releases/download/v1.0.5.1/ibm-concert-std-workflows.tgz
    tar xfz ibm-concert-std-workflows.tgz
    ${DOCKER_EXE} login ${CONCERT_REGISTRY} --username=${CONCERT_REGISTRY_USER} --password=${CONCERT_REGISTRY_PASSWORD}
    ```

    1. Your IBM Entitlement Key

???+ success "output"

    ```{.bash .nocopy}
    $ export DOCKER_EXE=podman
    $ export CONCERT_REGISTRY=cp.icr.io/cp/concert
    $ export CONCERT_REGISTRY_USER=cp
    $ export CONCERT_REGISTRY_PASSWORD=[REDACTED]
    $ wget https://github.com/IBM/Concert/releases/download/v1.0.4.1/ibm-concert-std-workflows.tgz
    --2025-01-29 14:39:44--  https://github.com/IBM/Concert/releases/download/v1.0.4.1/ibm-concert-std-workflows.tgz
    Resolving github.com (github.com)... 140.82.112.4
    Connecting to github.com (github.com)|140.82.112.4|:443... connected.
    HTTP request sent, awaiting response... 302 Found
    Location: https://objects.githubusercontent.com/github-production-release-asset-2e65be/815253674/d37113aa-93c4-4635-850a-6d478b44bb77?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20250129%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250129T143945Z&X-Amz-Expires=300&X-Amz-Signature=88b0e3843a4642a3249d744526bfbb580d50f551240dcd148aded92c384305a6&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3Dibm-concert-std-workflows.tgz&response-content-type=application%2Foctet-stream [following]
    --2025-01-29 14:39:45--  https://objects.githubusercontent.com/github-production-release-asset-2e65be/815253674/d37113aa-93c4-4635-850a-6d478b44bb77?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20250129%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250129T143945Z&X-Amz-Expires=300&X-Amz-Signature=88b0e3843a4642a3249d744526bfbb580d50f551240dcd148aded92c384305a6&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3Dibm-concert-std-workflows.tgz&response-content-type=application%2Foctet-stream
    Resolving objects.githubusercontent.com (objects.githubusercontent.com)... 185.199.110.133, 185.199.111.133, 185.199.108.133, ...
    Connecting to objects.githubusercontent.com (objects.githubusercontent.com)|185.199.110.133|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 40468 (40K) [application/octet-stream]
    Saving to: ‘ibm-concert-std-workflows.tgz’

    ibm-concert-std-workflows.tgz           100%[===============================================================================>]  39.52K  --.-KB/s    in 0.001s

    2025-01-29 14:39:45 (41.7 MB/s) - ‘ibm-concert-std-workflows.tgz’ saved [40468/40468]

    $ tar xfz ibm-concert-std-workflows.tgz
    $ ${DOCKER_EXE} login ${CONCERT_REGISTRY} --username=${CONCERT_REGISTRY_USER} --password=${CONCERT_REGISTRY_PASSWORD}
    Login Succeeded!
    ```

Obtain the CONCERT_HUB_KEY for your IBM Concert instance.  You will need the URL for your concert instance (eg: `https://YOUR_VM_PUBLIC_IP:12443`) and a Concert API Key.  To obtain your Concert API Key:

* Log on to your IBM Concert VM instance, and click on your user avatar on the top right corner, and click on API Key:

![Fetch API Key](./images/concert-api-key.png)

* Click `Generate API key`, Note down your API key, you will not see it again!

* Run the following to fetch your Concert API Key:

???+ note "get concert hub key"

    ```bash
    export CONCERT_URL="https://YOUR_VM_PUBLIC_IP:12443"
    export CONCERT_API_KEY="a..." # (1)!
    ./workflows/bin/tethering/get_concert_info.sh --concert-url=${CONCERT_URL} --c-api-key=${CONCERT_API_KEY}
    ```

???+ success "output"

    ```{.bash .no-copy}
    $ export CONCERT_URL="https://52.116.134.155:12443"
    $ export CONCERT_API_KEY=[REDACTED]
    $ ./workflows/bin/tethering/get_concert_info.sh --concert-url=${CONCERT_URL} --c-api-key=${CONCERT_API_KEY}
    Parsing option: '--concert-url', value: 'https://52.116.134.155:12443'
    Parsing option: '--c-api-key', value: '[REDACTED]'
    ----------
    APIKEY is XXXX_KEY
    ----------
    PARAMETERS
    APIKEY: ([XXXXXXXXXXXXXXXXXX])
    get_info
    GOT VALUE CONCERT_HUB_KEY "XXXXXXXXXXXXXXX"
    GOT VALUE CONCERT_HUB_URL "https://ibm-roja-portal-gw-svc.roja.svc:12443"
    GOT VALUE WORKFLOW_APIKEY "XXXXXXXXXXXXX"
    ```

* Export the concert hub key from the output of this command:

```bash
export CONCERT_HUB_KEY="<from-output>"
```
Modify `workflows/bin/concert-workflows-values.yaml` with the following changes:

- Update the `imageRegistry` parameter to `cp.icr.io/cp/concert`
- Update the `rna.instance.address` parameter to `https://YOUR_VM_PUBLIC_IP` (do not include port 12443)
- Update the `rna.instance.CONCERT_HUB_URL` parameter to `https://YOUR_VM_PUBLIC_IP:12443`
- Update the `rna.instance.CONCERT_HUB_KEY` parameter to the CONCERT_HUB_KEY obtained above.

The file should look like this

???+ success "concert-workflows-values.yaml"

    ```{.yaml .no-copy}
    imageRegistry:  "cp.icr.io/cp/concert"
    imagePullSecretName: ibm-entitlement-key
    rna:
      instance:
        address: 'https://52.118.189.193'
        installation_mode: concert
        CONCERT_HUB_URL: "https://52.118.189.193:12443"
        CONCERT_HUB_KEY: "77c2..."
      faas:
        faas_namespace: "faas"
        python:
          pip_registry: "https://pypi.org/pypi"
          pip_ignore_ssl_errors: true
    ```

Create a namespace in your k3s cluster.

???+ note "Installing Concert Workflows on a VM"

    ```bash
    export CW_NAMESPACE=concert
    kubectl create ns ${CW_NAMESPACE}
    ```

???+ success "output"

    ```{.bash .no-copy}
    $ export CW_NAMESPACE=concert
    $ kubectl create ns ${CW_NAMESPACE}
    namespace/concert created
    ```

Create a secret called ibm-entitlement-key in the same namespace. For example:

???+ note "ibm-entitlement-key secret"

    ```bash
    kubectl create secret docker-registry ibm-entitlement-key \
      --docker-server=cp.icr.io \
      --docker-username=${CONCERT_REGISTRY_USER} \
      --docker-password=${CONCERT_REGISTRY_PASSWORD} \
      --namespace="${CW_NAMESPACE}"
    ```

???+ success "output"

    ```{.bash .no-copy}
    $ kubectl create secret docker-registry ibm-entitlement-key \
      --docker-server=cp.icr.io \
      --docker-username=${CONCERT_REGISTRY_USER} \
      --docker-password=${CONCERT_REGISTRY_PASSWORD} \
      --namespace="${CW_NAMESPACE}"
    secret/ibm-entitlement-key created
    ```

The Concert Workflow installer relies on Helm. Install it on the VM:

???+ note "install Helm"

    ```bash
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    sudo chmod 755 /usr/local/bin/helm
    ```

???+ success "output"

    ```{.bash .no-copy}
    $ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    $ chmod 700 get_helm.sh
    $ ./get_helm.sh
    ./get_helm.sh: line 138: /usr/local/bin/helm: Permission denied
    Helm v3.17.0 is available. Changing from version .
    Downloading https://get.helm.sh/helm-v3.17.0-linux-amd64.tar.gz
    Verifying checksum... Done.
    Preparing to install helm into /usr/local/bin
    helm installed into /usr/local/bin/helm
    $ sudo chmod 755 /usr/local/bin/helm
    ```


Install Concert Workspaces with the following command.  The process takes around 10-15 minutes:

???+ note "install Concert Workspaces"

    ```bash
    ./workflows/bin/setup --namespace="${CW_NAMESPACE}"
    ```

???+ success "output"

    ```{.bash .no-copy}
    $ ./workflows/bin/setup --namespace="${CW_NAMESPACE}"
    [...]
    Thu Mar 27 03:45:20 UTC 2025 =========== ...
    Thu Mar 27 03:45:23 UTC 2025 =========== ...
    Thu Mar 27 03:45:27 UTC 2025 =========== ...
    Thu Mar 27 03:45:27 UTC 2025 =========== 'COMPLETED' IBM Concert Workflows installation
    Thu Mar 27 03:45:27 UTC 2025 =========== INFO: IBM Concert Workflows 1.1.5 core installation is successful.
    Thu Mar 27 03:45:27 UTC 2025 =========== 'COMPLETED' IBM Concert Workflows installation
    Thu Mar 27 03:45:27 UTC 2025 =========== 'STARTED' IBM Concert Workflows registration
    ```

!!! bug

    Due to some automation issues with the installer, allow 5-10 minutes after the above command is completed to avoid failure in the next steps.

To validate the install, check the status of the pods with `kubectl get pods -n "${CW_NAMESPACE}"`. Ensure sure all containers in all pods are `Running` or `Completed`:

```bash
kubectl get pods -n ${CW_NAMESPACE}
```

???+ success "output"
    ```{.bash .no-copy}
    NAME                                                    READY   STATUS      RESTARTS        AGE
    rna-core-addon-ansible-7d74494644-th9tx                 1/1     Running     0               9m44s
    rna-core-addon-faas-f46f9db87-ljl8c                     1/1     Running     0               9m43s
    rna-core-addon-mqws-86474c4dc4-n66qm                    1/1     Running     0               9m44s
    rna-core-addon-napalm-78cf7f6944-s2jmm                  1/1     Running     0               9m44s
    rna-core-addon-pdf-f5f4bd7c9-pqvwm                      1/1     Running     0               9m43s
    rna-core-addon-textfsm-6f47c8959d-ndpmr                 1/1     Running     0               9m42s
    rna-core-addon-themes-85748bfdc4-xnxhn                  1/1     Running     0               9m43s
    rna-core-configure-admin-job-kaalikbj-j95t5             0/1     Completed   0               9m44s
    rna-core-configure-ui-themes-job-cet85fru-s8z2x         0/1     Completed   0               9m44s
    rna-core-install-integrations-job-bqt8innt-lqjf6        0/1     Completed   0               9m44s
    rna-core-mysqldb-0                                      1/1     Running     0               9m44s
    rna-core-object-storage-0                               1/1     Running     0               9m44s
    rna-core-pliant-api-dc7f55555-4nl4q                     2/2     Running     1 (9m24s ago)   9m42s
    rna-core-pliant-api-dc7f55555-pf2tl                     2/2     Running     1 (9m25s ago)   9m42s
    rna-core-pliant-app-gateway-6d4f65fc79-l6snm            1/1     Running     5 (8m4s ago)    9m42s
    rna-core-pliant-compiler-69dc77cdf7-g8s8x               1/1     Running     0               9m44s
    rna-core-pliant-db-migration-c4877b8c8-9csbg            1/1     Running     1 (9m22s ago)   9m44s
    rna-core-pliant-flow-converter-5996cd4d9f-jqzzt         1/1     Running     1 (9m41s ago)   9m44s
    rna-core-pliant-front-747ff9b84c-7xlhs                  1/1     Running     0               9m44s
    rna-core-pliant-front-747ff9b84c-j6fm4                  1/1     Running     0               9m44s
    rna-core-pliant-image-registry-0                        1/1     Running     0               9m44s
    rna-core-pliant-kv-store-5775cf8757-w4td6               1/1     Running     0               9m43s
    rna-core-pliant-proxy-6bfc44f9b6-z9fbc                  1/1     Running     0               9m44s
    rna-core-pliant-scheduler-84897d8975-8rcvv              1/1     Running     5 (7m52s ago)   9m42s
    rna-core-pliant-stats-0                                 1/1     Running     1 (9m38s ago)   9m44s
    rna-core-pliant-worker-f4f95d6b6-pwmrx                  1/1     Running     6 (4m30s ago)   9m44s
    rna-core-pliant-worker-f4f95d6b6-tfw46                  1/1     Running     6 (4m42s ago)   9m44s
    rna-core-pliant-worker-nodejs-config-6c4f6cb568-262c8   1/1     Running     0               9m43s
    rna-core-rabbitmq-0                                     1/1     Running     0               9m44s
    ```

#### Register Concert Workflows with Concert

To register Concert Workflows as an add-on to your Concert instance, follow this process

??? note "register workflows"

    ```bash
    export CONCERT_HUB_URL=https://YOUR_VM_PUBLIC_IP:12443
    export CONCERT_HUB_KEY=[GET FROM STEPS ABOVE]
    export EXTNS_DIR=$PWD/workflows/extns/
    export ADDON_NAME=concert_workflows
    export EXT_URL=https://YOUR_PRIVATE_VM_IP # (1)!
    ./workflows/bin/tethering/tether-to-hub.sh \
      --concert-hub-url="$CONCERT_HUB_URL" \
      --concert-hub-key="$CONCERT_HUB_KEY" \
      --extn-dir="$EXTNS_DIR" \
      --provider="$ADDON_NAME" \
      --external-url="$EXT_URL"
    ```
    
    1. This will show as 'Private IP' in your Techzone reservation

???+ success "output"

    ```{.bash .no-copy}
    $ export CONCERT_HUB_URL=https://52.116.134.155:12443
    $ export CONCERT_HUB_KEY=c843513c9380f101d6aee6e2
    $ export EXTNS_DIR=$PWD/workflows/extns/
    $ export ADDON_NAME=concert_workflows
    $ export EXT_URL=https://52.116.134.155
    $ ./workflows/bin/tethering/tether-to-hub.sh \
          --concert-hub-url="$CONCERT_HUB_URL" \
          --concert-hub-key="$CONCERT_HUB_KEY" \
          --extn-dir="$EXTNS_DIR" \
          --provider="$ADDON_NAME" \
          --external-url="$EXT_URL"
    Parsing option: '--concert-hub-url', value: 'https://52.116.134.155:12443'
    Parsing option: '--concert-hub-key', value: 'c843513c9380f101d6aee6e2'
    Parsing option: '--extn-dir', value: '/home/itzuser/workflows/extns/'
    Parsing option: '--provider', value: 'concert_workflows'
    Parsing option: '--external-url', value: 'https://52.116.134.155'
    target_ns (optional) empty
    ----------
    ENV VARS
    CONCERT_HUB_URL https://52.116.134.155:12443
    CONCERT_HUB_KEY c843513c9380f101d6aee6e2
    ----------
    PARAMETERS
    CONCERT_HUB_URL: (https://52.116.134.155:12443)
    CONCERT_HUB_KEY: (c843513c9380f101d6aee6e2)
    EXNT_DIR: (/home/itzuser/workflows/extns/)
    PROVIDER: (concert_workflows)
    TARGET_NS: ()
    EXTERNAL_URL: (https://52.116.134.155)
    /home/itzuser/workflows/bin/tethering
    Different NS or Cluster. Need to add ConfigMap app-cfg-cm.
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
    100  230k  100  230k    0     0  4700k      0 --:--:-- --:--:-- --:--:-- 4700k
    GOT VALUE ROJA_AUTH "native"
    GOT VALUE ROJA_CONTEXT "sw_dev"
    GOT VALUE CONCERT_HUB_URL https://52.116.134.155
    ===> APPLY Config Maps app-cfg-cm
    configmap/app-cfg-cm serverside-applied
    GOT VALUE CONCERT_HUB_KEY "c843513c9380f101d6aee6e2"
    ===> APPLY Secret app-cfg-secret
    secret/app-cfg-secret serverside-applied
    GOT VALUE tls.key "-----BEGIN PRIVATE KEY-----\n
    GOT VALUE tls.crt "-----BEGIN CERTIFICATE-----\n
    GOT VALUE /tmp/tls_ca_bundle.pem "-----BEGIN CERTIFICATE-----\n
    ===> APPLY Secret app-cfg-internal-tls
    secret/app-cfg-internal-tls serverside-applied
    Parsing option: '--extn-dir', value: '/home/itzuser/workflows/extns/'
    Parsing option: '--provider', value: 'concert_workflows'
    Parsing option: '--external-url', value: 'https://52.116.134.155'
    target_ns (optional) empty
    ----------
    ENV VARS
    CONCERT_HUB_URL https://52.116.134.155:12443
    CONCERT_HUB_KEY c843513c9380f101d6aee6e2
    ----------
    PARAMETERS
    EXTN_DIR: (/home/itzuser/workflows/extns/)
    PROVIDER: (concert_workflows)
    TARGET_NS: ()
    EXTERNAL_URL: (https://52.116.134.155)
    Check for mandatory fields ...

    Parsing: /home/itzuser/workflows/extns/workflows.extn.jsonpost_extensions
    {"extensions":[{"id":"dc59768f-5dda-4857-b137-c3970471d1e2","provider":"concert_workflows","name":"workflows.registry","display_name":null,"extends":"portal.route","flag":null,"applies_to":null,"applies_when":null,"data":"{\"route_type\": \"pass_thru\", \"location\": \"/v2/\", \"local_svc_url\": \"https://pliant-proxy\", \"additional\": {\"proxy_set_header\": [\"Upgrade $http_upgrade\", \"Connection $connection_upgrade\"]}, \"proxy_url\": \"https://52.116.134.155\"}","nginx_conf":"location ~ /v2/([/\\?].*|$)\n{\n    proxy_pass https://52.116.134.155$1$is_args$args;\n\n    proxy_set_header Upgrade $http_upgrade;\n    proxy_set_header Connection $connection_upgrade;\n}"},{"id":"dd25566a-0a37-42c3-8bea-290efe3204ea","provider":"concert_workflows","name":"workflows.exchange.pass_thru","display_name":null,"extends":"portal.route","flag":null,"applies_to":null,"applies_when":null,"data":"{\"route_type\": \"pass_thru\", \"location\": \"/cw_internal/api/concert/token\", \"local_svc_url\": \"https://pliant-proxy\", \"additional\": {\"rewrite\": \"^/cw_internal(.*)$ $1 break\"}, \"proxy_url\": \"https://52.116.134.155\"}","nginx_conf":"location ~ /cw_internal/api/concert/token([/\\?].*|$)\n{\n    proxy_pass https://52.116.134.155;\n\n    rewrite ^/cw_internal(.*)$ $1 break;\n}"},{"id":"25f12200-bc12-423a-a0a7-9e6f5ed03b6c","provider":"concert_workflows","name":"workflows.exchange.internal","display_name":null,"extends":"portal.route","flag":null,"applies_to":null,"applies_when":null,"data":"{\"route_type\": \"pass_thru\", \"location\": \"/a/\", \"local_svc_url\": \"https://pliant-proxy\", \"additional\": {\"proxy_http_version\": \"1.1\", \"proxy_set_header\": [\"Host $host\", \"X-Forwarded-Port $server_port\", \"X-Forwarded-For $proxy_add_x_forwarded_for\", \"Connection \\\"\\\"\"]}, \"proxy_url\": \"https://52.116.134.155\"}","nginx_conf":"location ~ /a/([/\\?].*|$)\n{\n    proxy_pass https://52.116.134.155$1$is_args$args;\n\n    proxy_http_version 1.1;\n    proxy_set_header Host $host;\n    proxy_set_header X-Forwarded-Port $server_port;\n    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n    proxy_set_header Connection \"\";\n}"},{"id":"ea36c713-2837-4bc7-9c5e-6ff6d998aec2","provider":"concert_workflows","name":"workflows.exchange.api-docs","display_name":null,"extends":"portal.route","flag":null,"applies_to":null,"applies_when":null,"data":"{\"route_type\": \"pass_thru\", \"location\": \"/api-docs/\", \"local_svc_url\": \"https://pliant-proxy\", \"additional\": {\"proxy_http_version\": \"1.1\", \"proxy_set_header\": [\"Host $host\", \"X-Forwarded-Port $server_port\", \"X-Forwarded-For $proxy_add_x_forwarded_for\", \"Connection \\\"\\\"\"]}, \"proxy_url\": \"https://52.116.134.155\"}","nginx_conf":"location ~ /api-docs/([/\\?].*|$)\n{\n    proxy_pass https://52.116.134.155$1$is_args$args;\n\n    proxy_http_version 1.1;\n    proxy_set_header Host $host;\n    proxy_set_header X-Forwarded-Port $server_port;\n    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n    proxy_set_header Connection \"\";\n}"},{"id":"8ac39e33-6557-4127-b34f-30779d3f8372","provider":"concert_workflows","name":"workflows.exchange","display_name":null,"extends":"portal.route","flag":null,"applies_to":null,"applies_when":null,"data":"{\"route_type\": \"auth\", \"xchg_endpoint\": \"/cw_internal/api/concert/token\", \"location\": \"/cw\", \"local_svc_url\": \"https://pliant-proxy\", \"additional\": {\"limit_req\": \"zone=uilimit burst=100 nodelay\", \"proxy_set_header\": [\"X-Forwarded-For $proxy_add_x_forwarded_for\", \"Host $host\"], \"proxy_read_timeout\": \"300s\", \"proxy_ssl_server_name\": \"on\", \"proxy_hide_header\": \"Content-Security-Policy\", \"add_header\": \"Content-Security-Policy \\\"default-src 'self'; object-src 'none'; style-src \\\\* 'unsafe-inline'; font-src \\\\* data:; img-src 'self' data:;\\\" always\", \"proxy_redirect\": [\"http://$host/api https://$host/cw/api\", \"https://$host/api https://$host/cw/api\"]}, \"proxy_url\": \"https://52.116.134.155\"}","nginx_conf":"location ~ /cw([/\\?].*|$)\n{\n    set_by_lua $xchg_endpoint ' return \"/cw_internal/api/concert/token\" ';\n    lua_ssl_verify_depth 2;\n    lua_ssl_trusted_certificate /app/tmp/self-signed-ssl/tls.crt;\n    lua_ssl_certificate_key /app/tmp/self-signed-ssl/tls.key;\n    access_by_lua_file /nginx_data/lib/auth.lua;\n\n    proxy_pass https://52.116.134.155$1$is_args$args;\n\n    limit_req zone=uilimit burst=100 nodelay;\n    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n    proxy_set_header Host $host;\n    proxy_read_timeout 300s;\n    proxy_ssl_server_name on;\n    proxy_hide_header Content-Security-Policy;\n    add_header Content-Security-Policy \"default-src 'self'; object-src 'none'; style-src \\* 'unsafe-inline'; font-src \\* data:; img-src 'self' data:;\" always;\n    proxy_redirect http://$host/api https://$host/cw/api;\n    proxy_redirect https://$host/api https://$host/cw/api;\n}"},{"id":"fb183db5-ba77-4f9d-b53f-d9af22af2c89","provider":"concert_workflows","name":"workflows.root","display_name":"Workflows","extends":"concert.topmenu","flag":null,"applies_to":null,"applies_when":null,"data":"{\"description\": \"i18.workflows.root.desc\", \"root\": \"true\"}","nginx_conf":""},{"id":"bfd3ab22-25da-4d63-9931-14e85d946af8","provider":"concert_workflows","name":"workflows_manage","display_name":"Manage","extends":"concert.topmenu","flag":null,"applies_to":null,"applies_when":null,"data":"{\"description\": \"i18n.workflows.manage.desc\", \"parent\": \"workflows.root\", \"url\": \"/cw/flows\"}","nginx_conf":""},{"id":"354de962-8a53-40d8-9011-b2798160b001","provider":"concert_workflows","name":"workflows_authentications","display_name":"Authentications","extends":"concert.topmenu","flag":null,"applies_to":null,"applies_when":null,"data":"{\"description\": \"i18n.workflows.authentications.desc\", \"parent\": \"workflows.root\", \"url\": \"/cw/authentications\"}","nginx_conf":""},{"id":"89b82315-33d4-4914-b54f-06e9df4c4382","provider":"concert_workflows","name":"workflows_jobs","display_name":"Schedule","extends":"concert.topmenu","flag":null,"applies_to":null,"applies_when":null,"data":"{\"description\": \"i18n.workflows.schedule.desc\", \"parent\": \"workflows.root\", \"url\": \"/cw/jobs\"}","nginx_conf":""},{"id":"f810ea09-6ca5-498d-a227-f8b59adfbff7","provider":"concert_workflows","name":"workflows_logs","display_name":"History","extends":"concert.topmenu","flag":null,"applies_to":null,"applies_when":null,"data":"{\"description\": \"i18n.workflows.history.desc\", \"parent\": \"workflows.root\", \"url\": \"/cw/logs\"}","nginx_conf":""}]}
    Cleaning things up ...
    ```

Make the `enable_concert_workflows.sh` script executable:

```bash
chmod +x ./workflows/bin/tethering/enable_concert_workflows.sh
```

Run the following command to fetch the `VALUE WORKFLOW_APIKEY`:

```bash
export CONCERT_URL="https://YOUR_VM_PUBLIC_IP:12443"
export CONCERT_API_KEY="a..." 
./workflows/bin/tethering/get_concert_info.sh --concert-url=${CONCERT_URL} --c-api-key=${CONCERT_API_KEY}
```

???+ success "output"
    ```{.bash .no-copy}
    [...]
    GOT VALUE WORKFLOW_APIKEY "3f26c..."
    ```

Set the required environment variables:

```bash
export CONCERT_API_KEY=<valid API key generated in the Concert>
export CONCERT_USER=ibmconcert
export WORKFLOW_APIKEY="from-previous-step"
```

```bash
./workflows/bin/tethering/enable_concert_workflows.sh --concert-url="$CONCERT_HUB_URL" --c-api-key="$CONCERT_API_KEY" --c-user="$CONCERT_USER" --workflow-apikey="$WORKFLOW_APIKEY"
```


## Creating your first Workflow

Back in your browser, refresh the Concert home page. You should now see a Workflow tab at the top of your Concert instance. Select `Manage`:

![Concert Workflows](./images/concert-manage-workflows.png)

Select `Create Workflow`, give your workflow a name, and click `Select Template`. Set the template to `HTTP Template`:

![HTTP Template](./images/concert-http-template.png)

Create your workflow and run it using the `Run` button. You should see the workflow make a request to `example.com`!

!!! success "Workflow Lab Complete"
    Congratulations, you have successfully completed the Workflow install lab.
    
# Acknowledgements

This lab was based on: https://pages.github.ibm.com/cs-tel-ibm-concert/training/module3/concert-workflows/#installing-concert-workflows-on-a-vm
