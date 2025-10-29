---
Title: Mirror OpenShift Content
hide:
  - toc
---

For mirroring OpenShift content, Red Hat provides the `oc-mirror` command-line interface. What content is mirrored is configured by defining an `ImageSetConfiguration` in a file.

## Install the oc-mirror CLI

1. Download the oc-mirror CLI.

   ```sh
   OCP_RELEASE_CHANNEL=stable
   ```

   ```sh
   curl -Lo oc-mirror.tar.gz \
       https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${OCP_RELEASE_CHANNEL}-${OCP_VERSION}/oc-mirror.tar.gz
   ```

2. Extract the oc-mirror CLI.

   ```sh
   tar xf oc-mirror.tar.gz oc-mirror
   ```

3. Move the CLI to `/usr/local/bin`.

   ```sh
   chmod +x oc-mirror
   sudo install oc-mirror /usr/local/bin
   ```

4. Verify.

   ```sh
   oc-mirror version
   ```

   ```{.text .no-copy title="Example output"}
   W0512 15:36:58.975204   15046 mirror.go:102]
   ⚠️  oc-mirror v1 is deprecated (starting in 4.18 release) and will be removed in a future release - please migrate to oc-mirror --v2

   WARNING: This version information is deprecated and will be replaced with the output from --short. Use --output=yaml|json to get the full version.
   Client Version: version.Info{Major:"", Minor:"", GitVersion:"4.18.0-202504231952.p0.g222e383.assembly.stream.el9-222e383", GitCommit:"222e38394c0d96357ba0179e88aa65956d4112a4", GitTreeState:"clean", BuildDate:"2025-04-23T20:30:36Z", GoVersion:"go1.22.12 (Red Hat 1.22.12-2.el8_10) X:strictfipsruntime", Compiler:"gc", Platform:"linux/amd64"}
   ```

5. Clean up.

   ```sh
   rm oc-mirror.tar.gz oc-mirror
   ```

## Collect information for the mirror operation

In order to limit the size of the mirrored content you need to specify minimal versions of both the platform and operator images.

1. Copy your pull secret from the [Red Hat Hybrid Cloud Console](https://console.redhat.com/openshift/install/pull-secret) and save it in file `${XDG_RUNTIME_DIR}/containers/auth.json`.

2. List all OpenShift versions for selected channel.

   ```sh
   oc-mirror list releases --channel ${OCP_RELEASE_CHANNEL}-${OCP_VERSION}
   ```

3. Select desired point release of OCP

   ```sh
   OCP_MINOR=19
   ```

4. List the OpenShift Data Foundation operators in the RedHat catalog.

   ```sh
   oc-mirror list operators \
       --catalog registry.redhat.io/redhat/redhat-operator-index:v${OCP_VERSION} \
       | grep -E 'ocs-operator|odf-operator|mcg-operator|odf-csi-addons-operator|odf-dependencies'
   ```

   ```{.text .no-copy title="Example output"}
   mcg-operator                                                stable-4.17
   ocs-operator                                                stable-4.17
   odf-csi-addons-operator                                     stable-4.17
   odf-operator                                                stable-4.17
   odf-dependencies                                            stable-4.17
   ```

5. List all versions in selected channel `stable-4.18` for package `odf-operator`.

   ```sh
   oc-mirror list operators \
     --catalog registry.redhat.io/redhat/redhat-operator-index:v${OCP_VERSION} \
     --package ocs-operator \
     --channel ${OCP_RELEASE_CHANNEL}-${OCP_VERSION}
   ```

   ```{.text .no-copy title="Example output"}
   VERSIONS
   4.17.0-rhodf
   ```

   Repeat this step for operators `ocs-operator`, `mcg-operator`, `odf-csi-addons-operator` and `odf-dependencies`.

6. Set rhodf package version

   ```sh
   RHODF_MIN_VERSION=4.18.2-rhodf
   ```

## Mirror the platform and operator images

1. Create the `ImageSetConfiguration` file.

   ```sh
   cat <<EOF > ~/ocpinstall/isc-platform-odf.yaml
   kind: ImageSetConfiguration
   apiVersion: mirror.openshift.io/v1alpha2
   mirror:
     platform:
       channels:
       - name: ${OCP_RELEASE_CHANNEL}-${OCP_VERSION}
         type: ocp
         minVersion: ${RHODF_MIN_VERSION}
       graph: true
     operators:
     - catalog: registry.redhat.io/redhat/redhat-operator-index:v${OCP_VERSION}
       packages:
       - name: odf-operator
         channels:
         - name: ${OCP_RELEASE_CHANNEL}-${OCP_VERSION}
         minVersion: ${RHODF_MIN_VERSION}
       - name: ocs-operator
         channels:
         - name: ${OCP_RELEASE_CHANNEL}-${OCP_VERSION}
         minVersion: ${RHODF_MIN_VERSION}
       - name: odf-csi-addons-operator
         channels:
         - name: ${OCP_RELEASE_CHANNEL}-${OCP_VERSION}
         minVersion: ${RHODF_MIN_VERSION}
       - name: mcg-operator
         channels:
         - name: ${OCP_RELEASE_CHANNEL}-${OCP_VERSION}
         minVersion: ${RHODF_MIN_VERSION}
       - name: odf-dependencies
         channels:
         - name: ${OCP_RELEASE_CHANNEL}-${OCP_VERSION}
         minVersion: ${RHODF_MIN_VERSION}
   EOF
   ```

2. Log in to private image registry.

   ```sh
   podman login 192.168.252.2:8443 -u admin -p QuayForAll! --tls-verify=false
   ```

3. Mirror the content.

   ```sh
   oc-mirror --config=${HOME}/ocpinstall/isc-platform-odf.yaml docker://192.168.252.2:8443/ocp4 --dest-skip-tls
   ```

   ```{.text .no-copy title="Example output"}
   #...
   info: Mirroring completed in 1h19m55.57s (50.34MB/s)
   Rendering catalog image "192.168.252.2:8443/ocp4/redhat/redhat-operator-index:v4.18" with file-based catalog
   Writing image mapping to oc-mirror-workspace/results-1752686279/mapping.txt
   Writing UpdateService manifests to oc-mirror-workspace/results-1752686279
   Writing CatalogSource manifests to oc-mirror-workspace/results-1752686279
   Writing ICSP manifests to oc-mirror-workspace/results-1752686279
   ```
