---
Title: Create Install Config
hide:
  - toc
---

## Collect Install Config Asset Information

1. Create a pull-secret for the mirror-registry.

   ```sh
   REG_CREDS=$(echo -n 'admin:QuayForAll!' | base64)
   ```

   ```sh
   cat <<EOF
   {"auths":{"192.168.252.2:8443":{"auth":"${REG_CREDS}","email":"admin@quay.io"}}}
   EOF
   ```

   ```{.text .no-copy title="Example output"}
   {"auths":{"192.168.252.2:8443":{"auth":"YWRtaW46UXVheUZvckFsbCE=","email":"admin@quay.io"}}}
   ```

2. Calculate the checksum for the Red Hat CoreOS OVA image.

   ```sh
   sha256sum /var/www/html/rhcos-vmware.x86_64.ova
   ```

   ```{.text .no-copy title="Example output"}
   312a12cac8c2ba7b73fdb1b0b7abada8f8048901f304fac95b0819d3058dbdca  /var/www/html/rhcos-vmware.x86_64.ova
   ```

## Run the wizard

1. Install oc & openshift-install binaries

   ```sh
   wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OCP_VERSION}.${OCP_MINOR}/openshift-client-linux-amd64-rhel8.tar.gz
   ```

   ```sh
   wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OCP_VERSION}.${OCP_MINOR}/openshift-install-linux.tar.gz
   ```

   ```sh
   tar xf openshift-client-linux-amd64-rhel8.tar.gz oc
   ```

   ```sh
   tar xf openshift-install-linux.tar.gz openshift-install
   ```

   ```sh
   chmod +x oc openshift-install
   sudo install oc openshift-install /usr/local/bin
   ```

   ```sh
   rm openshift-client-linux-amd64-rhel8.tar.gz oc openshift-install-linux.tar.gz openshift-install
   ```

2. Enabling vCenter CA Certificate Trust

   ```sh
   VSPHERE_HOSTNAME=ocpgym-vc.techzone.ibm.local
   ```

   ```sh
   mkdir -p ~/ocpinstall/vmware
   curl -o ~/ocpinstall/vmware/download.zip -k https://${VSPHERE_HOSTNAME}/certs/download.zip
   unzip ~/ocpinstall/vmware/download.zip -d ~/ocpinstall/vmware
   sudo cp -a ~/ocpinstall/vmware/certs/lin/. /etc/pki/ca-trust/source/anchors/
   sudo update-ca-trust extract
   ```

3. Generate SSH key for OpenShift install.

   ```sh
   ssh-keygen -t rsa -N '' -f ~/.ssh/openshift_rsa
   ```

4. Launch the installation wizard.

   ```sh
   openshift-install create install-config
   ```

5. Complete the installer survey.

   For this exercise, the cluster **must** be named `ocpinstall`.

   ```{.text .no-copy title="Example"}
   ? SSH Public Key /home/admin/.ssh/id_core.pub
   ? Platform vsphere
   ? vCenter ocpgymwdc-vc.techzone.ibm.local
   ? Username gymuser-yf5tfa4q@techzone.ibm.local
   ? Password [? for help] ********
   INFO Connecting to vCenter ocpgymwdc-vc.techzone.ibm.local
   INFO Defaulting to only available datacenter: IBMCloud
   INFO Defaulting to only available cluster: /IBMCloud/host/ocpgym-wdc
   ? Default Datastore /IBMCloud/datastore/gym-50vmycg18b-yf5tfa4q-storage
   ? Network gym-50vmycg18b-yf5tfa4q-segment
   ? Virtual IP Address for API 192.168.252.3
   ? Virtual IP Address for Ingress 192.168.252.4
   ? Base Domain gym.lan
   ? Cluster Name ocpinstall
   ? Pull Secret [? for help] *********************************************************************

   INFO Install-Config created in: .
   ```

6. Review / compare the parameters with the `openshift-install.yaml` template below.

   ```{.yaml .no-copy title="Reference install-config.yaml"}
   additionalTrustBundlePolicy: Proxyonly
   apiVersion: v1
   baseDomain: gym.lan
   compute:
   - architecture: amd64
     hyperthreading: Enabled
     name: worker
     platform: {}
     replicas: 3
   controlPlane:
     architecture: amd64
     hyperthreading: Enabled
     name: master
     platform: {}
     replicas: 3
   metadata:
     creationTimestamp: null
     name: ocpinstall
   networking:
     clusterNetwork:
     - cidr: 10.128.0.0/14
       hostPrefix: 23
     machineNetwork:
     - cidr: 192.168.252.0/24
     networkType: OVNKubernetes
     serviceNetwork:
     - 172.30.0.0/16
   platform:
     vsphere:
       apiVIPs:
       - 192.168.252.3
       clusterOSImage: http://192.168.252.2/rhcos-vmware.x86_64.ova?sha256=312a12cac8c2ba7b73fdb1b0b7abada8f8048901f304fac95b0819d3058dbdca
       failureDomains:
       - name: ocpgym-wdc
         region: IBMCloud
         server: ocpgymwdc-vc.techzone.ibm.local
         topology:
           computeCluster: /IBMCloud/host/ocpgym-wdc
           datacenter: IBMCloud
           folder: /IBMCloud/vm/ocpgym-wdc/gym-50vmycg18b-979vmfdt
           datastore: /IBMCloud/datastore/gym-50vmycg18b-979vmfdt-storage
           networks:
           - gym-50vmycg18b-979vmfdt-segment
           resourcePool: /IBMCloud/host/ocpgym-wdc/Resources/Cluster Resource Pool/Gym Member Resource Pool/gym-50vmycg18b-979vmfdt
         zone: ocpgym-wdc
       ingressVIPs:
       - 192.168.252.4
       vcenters:
       - datacenters:
         - IBMCloud
         password: VRLGjoCh
         port: 443
         server: ocpgymwdc-vc.techzone.ibm.local
         user: gymuser-979vmfdt@techzone.ibm.local
   publish: External
   pullSecret: '{"auths":{"192.168.252.2:8443":{"auth":"YWRtaW46UXVheUZvckFsbCE=","email":"admin@quay.io"}}}'
   sshKey: |
     ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKvA1NaDixwxp479SamIQqEkeY3xobH8X/M/cmgattNY core@bastion
   additionalTrustBundle: |
     -----BEGIN CERTIFICATE-----
     MIIFSDCCAzCgAwIBAgIUS+LsQxm6cV2+roXKohcwc3d7d0EwDQYJKoZIhvcNAQEL
     BQAwIjEgMB4GA1UECgwXZ3ltLENOPXJlZ2lzdHJ5Lmd5bS5sYW4wHhcNMjQwNDEy
     MDk1NzM3WhcNMzQwNDEwMDk1NzM3WjAiMSAwHgYDVQQKDBdneW0sQ049cmVnaXN0
     cnkuZ3ltLmxhbjCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOWc0Bxa
     U/oyUsE5Qyqow6kdNNa4jLGWaDPSe/mx7qUmlLS6a2+bvVbBv9ys/tW9vpkECpgM
     TYGNpq0aNgdLP14/m/5MbCuEQ7Tc6Fj4PtxfKtJPSTcsPdRCxvBeYV/fJ2md2RaC
     y/1+oqdky8TGAOOOkalFkVPOJ/4ptn5rkMQmKYxqX0fk/SqLRJpEvVPSNaTM9gQM
     ufddOiWyNzTyHbADyjjwgQo2ZtAaNwMZaFaCPGO4ic1PhN87mCs+/tIO1GqLYmLb
     GoM+wdYYggIYGclOXIUh+rLbBpFCzSsu7m3L/tL1+uKthlaLKV+dfCWpM+H6owqe
     XtsuSyJieaNpjyTrQeJ50U7H5SV1Dq6FWMN2x2lIjnzlS4oEePzpCPB2BPmfBbBA
     8g6miCz81yy9fPre4wvv+GrQK2ghPBQyA+QxNyE/rRDERl+e19YoNBU3cJ9mdR7A
     E83nNX5YreZ2aOI1gk+1J/brWriGAwNEg803FxrOLDh5PWVHi0D47X227POrrHQD
     APdwvPj72wwC/waaLWlSI9HRGik0dXPBBddMBXYxL7Cny4nrNR9efR+DIa2abhsE
     p10PjHzWbRkVRnRCkNWLn2KbES7a4ERHFmsFD5tidYWcaUzGRptpMlRWM9G4woxL
     ZXKC8cB2CGNw41ZPr5tFKY6xlQfdprDo9oJ7AgMBAAGjdjB0MB0GA1UdDgQWBBQY
     2zYOaeqvUL0UB4Y86Zy1jI/aWTAfBgNVHSMEGDAWgBQY2zYOaeqvUL0UB4Y86Zy1
     jI/aWTAPBgNVHRMBAf8EBTADAQH/MCEGA1UdEQQaMBiCEHJlZ2lzdHJ5Lmd5bS5s
     YW6HBMCo/AIwDQYJKoZIhvcNAQELBQADggIBACJgpZrAnSR10YapjbC/TsXsXeDg
     PBO1Xic1O316NNlUTQdY4ROJWtpwiSE+pGRCAwO+A0Ylrw5auP61yQRRjTqdDtcN
     eEwD1Cw8xoPoRAhPwDn2hxBDN17u8LQ5JWSMfhQjsfNJrXT41XPM6cyLPaB9C0Jq
     Pi0OWagitQNIEW5UA63EtuqyhxcWah+BJx4I6uUOrLlUdqxqS1JeciQXAgo27eTV
     kE3qJtpgrU5KiIYytQ05QTqgfrjM+fMa1sRoGAs8W/VUJS/7QaBz+gQ8HHw8ISKA
     CNGD5Rt+WoGSanCTHWgH3t10Su645P6ih86OGyb1w4boJeGeR2gMd+o+e0RwetJU
     ebmLzn0Nlh3h/5GRJYl75o+moGySoUwIHAjJg+WVfc3ubEVNgzJNdqvVx07BzJ7J
     6a6IZSGBPeL0VIn0xIjhur+gaNRGNpkyKRpeWlxKaUw2zpK9LcuOcO6Zmy0cuHpP
     CONOYXayCeWhB0ufLI4sMOUUmPJDkXYsWR58pQhPTyO5T5ABNGXXgA9lE73ncnoV
     3L1UIeSxEDspv0vYzE27eGUUr1192YIj545NzQgyev4JA5/SfNDLWvTG9+r6rdMT
     sEXa5X0Von35v2dnXuvmw/wVkQCnIm55kTioFXLlt1da0sBuXO63+DLSRgP/7lpS
     K5D4kb1yO+t7InPy
     -----END CERTIFICATE-----
   imageDigestSources:
   - mirrors:
     - 192.168.252.2:8443/ocp4/ubi8
     source: registry.access.redhat.com/ubi8
   - mirrors:
     - 192.168.252.2:8443/ocp4/rhel8
     source: registry.redhat.io/rhel8
   - mirrors:
     - 192.168.252.2:8443/ocp4/rhel9
     source: registry.redhat.io/rhel9
   - mirrors:
     - 192.168.252.2:8443/ocp4/rhceph
     source: registry.redhat.io/rhceph
   - mirrors:
     - 192.168.252.2:8443/ocp4/odf4
     source: registry.redhat.io/odf4
   - mirrors:
     - 192.168.252.2:8443/ocp4/openshift4
     source: registry.redhat.io/openshift4
   - mirrors:
     - 192.168.252.2:8443/ocp4/openshift/release
     source: quay.io/openshift-release-dev/ocp-v4.0-art-dev
   - mirrors:
     - 192.168.252.2:8443/ocp4/openshift/release-images
     source: quay.io/openshift-release-dev/ocp-release
   ```

7. Modify your Install Config asset.

   Open the `install-config.yaml` file in your editor of choice. In addition to the VMware week modifications apply the following changes.

   ```{.yaml .no-copy title="Restricted network modifications"}
   #...
   platform:
     vsphere:
       #...
       clusterOSImage: http://192.168.252.2/rhcos-vmware.x86_64.ova?sha256=312a12cac8c2ba7b73fdb1b0b7abada8f8048901f304fac95b0819d3058dbdca
   #...
   additionalTrustBundle: |
     YOUR_QUAY_CERTIFICATE
   imageDigestSources:
   - mirrors:
     - 192.168.252.2:8443/ocp4/ubi8
     source: registry.access.redhat.com/ubi8
   - mirrors:
     - 192.168.252.2:8443/ocp4/rhel8
     source: registry.redhat.io/rhel8
   - mirrors:
     - 192.168.252.2:8443/ocp4/rhel9
     source: registry.redhat.io/rhel9
   - mirrors:
     - 192.168.252.2:8443/ocp4/rhceph
     source: registry.redhat.io/rhceph
   - mirrors:
     - 192.168.252.2:8443/ocp4/odf4
     source: registry.redhat.io/odf4
   - mirrors:
     - 192.168.252.2:8443/ocp4/openshift4
     source: registry.redhat.io/openshift4
   - mirrors:
     - 192.168.252.2:8443/ocp4/openshift/release
     source: quay.io/openshift-release-dev/ocp-v4.0-art-dev
   - mirrors:
     - 192.168.252.2:8443/ocp4/openshift/release-images
     source: quay.io/openshift-release-dev/ocp-release
   ```

   The `imageDigestSources` should be copied from `${HOME}/oc-mirror-workspace/results-*/imageContentSourcePolicy.yaml`.

   Replace the sha value of `clusterOSImage` to match the one returned by **step 2**.
