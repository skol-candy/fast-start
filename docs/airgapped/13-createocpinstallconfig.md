---
title: Create install-config.yaml file
hide:
    - toc
---

1. Exit the online bastion:

    ```{ .text .copy title="[root@bastiononline coreos-iso-maker]"}
    exit
    ```

1. Access the offline bastion:

    ```{ .text .copy title="[student laptop]"}
    ssh root@192.168.252.23
    ```

1. Create the directory where the `install-config.yaml` file will be placed:

    ```{ .text .copy title="[root@bastion ~]"}
    cd /root/registry/downloads/tools/
    ```

    ```{ .text .copy title="[root@bastion tools]"}
    mkdir ocp4
    cd ocp4
    ```

You need to cat the following files to create the `install-config.yaml` in the next step:

1. Quay private image registry CA

    ```{ .text .copy title="[root@bastion ocp4]"}
    cat /root/registry/quay-rootCA/rootCA.pem
    ```

    ```{ .pem .no-copy title="rootCA.pem"}
    -----BEGIN CERTIFICATE-----
    MIID3jCCAsagAwIBAgIUHj/Ux66Fpoktc/qtzoP6wgWZ2aIwDQYJKoZIhvcNAQEL
    BQAwdzELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAlZBMREwDwYDVQQHDAhOZXcgWW9y
    azENMAsGA1UECgwEUXVheTERMA8GA1UECwwIRGl2aXNpb24xJjAkBgNVBAMMHWJh
    c3Rpb24ub2NwNC5jc20tc3BnaS5hY21lLmVzMB4XDTIzMDkyMTE4NDAzM1oXDTI2
    MDcxMTE4NDAzM1owdzELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAlZBMREwDwYDVQQH
    DAhOZXcgWW9yazENMAsGA1UECgwEUXVheTERMA8GA1UECwwIRGl2aXNpb24xJjAk
    BgNVBAMMHWJhc3Rpb24ub2NwNC5jc20tc3BnaS5hY21lLmVzMIIBIjANBgkqhkiG
    9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv3eDBDh1GH6i+hptdlbMPYztWDsHCihyjRta
    WgD3SEyHobuWM/lSepwMC2mmyejZKsv/x4PYFsNrWBwt1oVicP3+sGNuNfKheFgn
    LAiXAgt35MLPR7oXZKCb82rb5jFUYWU6Ro2xHv8qxLAAv+BRzq5fDYczvsps3pq0
    rvdNLfCORBmtQnoRuKXTmOreQgZqHZkhb1g8P4jE+BJugSAQT4gy1cnP5HXFqpdC
    qaehQeQEi+k3yHVdYnMyVC2Ya609SUUeSUxuLrlO2EQTSwLzSZ02sMsIfBKbOgmu
    TJPGgd5jqrSu1LDem8YKws8u0MVEhkl3LkuUuOYBbt4kPxoTIwIDAQABo2IwYDAL
    BgNVHQ8EBAMCAuQwEwYDVR0lBAwwCgYIKwYBBQUHAwEwKAYDVR0RBCEwH4IdYmFz
    dGlvbi5vY3A0LmNzbS1zcGdpLmFjbWUuZXMwEgYDVR0TAQH/BAgwBgEB/wIBATAN
    BgkqhkiG9w0BAQsFAAOCAQEAEIanwOhmODUlshlmpXUMeAa7g8S/cEUy19tpo932
    /sHoxVJogMVdxBY2V1EjNUPr/6PImesUq0IA1piYXqdxw23kiTgAM01THn6xq9Bn
    ef7jKPuD7dVY1V8xMmt9EF1Bh4aTObCotF/6XOnBA6NaxWNq5jJ7dfRVU7Vqh5xa
    hyGRglgJw1LmrhwXTHLi6XBZXuwVlAw5HZFEsKsqD/6YqhmTMV7DA3Er/g3Qv1iJ
    NmnM5Ftr1huVtwXuETzm0VHIteSWXBV8/c4+COTlQpwVH2mQRcAZQsW8FibQIjP5
    k/26D0f5XWdf0u6cLowCmWRWhHrTe0ttUUm5ZcP7xeZNjA==
    -----END CERTIFICATE-----
    ```

    !!!info
        The content of this file will be pasted under `additionalTrustBundle` tag in the `install-config.yaml` file.

1. The Image Content Source Policy for the mirrored images

    ```{ .text .copy title="[root@bastion ocp4]"}
    cat /root/oc-mirror-workspace/results-XXXXXX/imageContentSourcePolicy.yaml
    ```

    ```{ .yaml .copy title="imageContentSourcePolicy.yaml" hl_lines="51-56"}
    ---
    apiVersion: operator.openshift.io/v1alpha1
    kind: ImageContentSourcePolicy
    metadata:
    name: generic-0
    spec:
    repositoryDigestMirrors:
    - mirrors:
        - bastion.ocp4.platformengineers.xyz:8443/ubi8
        source: registry.redhat.io/ubi8
    ---
    apiVersion: operator.openshift.io/v1alpha1
    kind: ImageContentSourcePolicy
    metadata:
    labels:
        operators.openshift.org/catalog: "true"
    name: operator-0
    spec:
    repositoryDigestMirrors:
    - mirrors:
        - bastion.ocp4.platformengineers.xyz:8443/openshift-logging
        source: registry.redhat.io/openshift-logging
    - mirrors:
        - bastion.ocp4.platformengineers.xyz:8443/openshift-pipelines
        source: registry.redhat.io/openshift-pipelines
    - mirrors:
        - bastion.ocp4.platformengineers.xyz:8443/rhel8
        source: registry.redhat.io/rhel8
    - mirrors:
        - bastion.ocp4.platformengineers.xyz:8443/ubi8
        source: registry.redhat.io/ubi8
    - mirrors:
        - bastion.ocp4.platformengineers.xyz:8443/redhat
        source: registry.redhat.io/redhat
    - mirrors:
        - bastion.ocp4.platformengineers.xyz:8443/openshift-serverless-1
        source: registry.redhat.io/openshift-serverless-1
    - mirrors:
        - bastion.ocp4.platformengineers.xyz:8443/ocp-tools-4-tech-preview
        source: registry.redhat.io/ocp-tools-4-tech-preview
    - mirrors:
        - bastion.ocp4.platformengineers.xyz:8443/openshift4
        source: registry.redhat.io/openshift4
    ---
    apiVersion: operator.openshift.io/v1alpha1
    kind: ImageContentSourcePolicy
    metadata:
    name: release-0
    spec:
    repositoryDigestMirrors:
    - mirrors:
        - bastion.ocp4.platformengineers.xyz:8443/openshift/release
        source: quay.io/openshift-release-dev/ocp-v4.0-art-dev
    - mirrors:
        - bastion.ocp4.platformengineers.xyz:8443/openshift/release-images
        source: quay.io/openshift-release-dev/ocp-release
    ```

    !!! info
        The highlighted content will be pasted under `imageContentSources` tag in the `install-config.yaml` file.

1. Create the `install-config.yaml` file:

    ```{ .text .copy title="[root@bastion ocp4]"}
    vi install-config.yaml
    ```

1. Make sure it looks like below:

    ```{ .yaml .copy title="install-config.yaml" hl_lines="25-26"}
    apiVersion: v1
    baseDomain: platformengineers.xyz
    compute:
    - hyperthreading: Enabled
      name: worker
      replicas: 9
    controlPlane:
      hyperthreading: Enabled
      name: master
      replicas: 3
    metadata:
      name: ocp4
    networking:
      clusterNetworks:
      - cidr: 9.248.0.0/14
        hostPrefix: 24
      machineNetwork:
      - cidr: 192.168.252.0/24
      networkType: OVNKubernetes
      serviceNetwork:
      - 9.31.0.0/16
    platform:
      none: {}
    fips: false
    pullSecret: '{"auths": {"bastion.ocp4.platformengineers.xyz:8443": { "auth": "aW5pdDpwYXNzdzByZA==", "email": "you@example.com"}}}'
    sshKey: 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICIl3vZvi6eh1SkTE9EWKnZZwG6bVvZZzZzBHuKgbrVW root@bastion.ocp4.platformengineers.xyz'
    additionalTrustBundle: |
        -----BEGIN CERTIFICATE-----
        MIID3jCCAsagAwIBAgIUHj/Ux66Fpoktc/qtzoP6wgWZ2aIwDQYJKoZIhvcNAQEL
        BQAwdzELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAlZBMREwDwYDVQQHDAhOZXcgWW9y
        azENMAsGA1UECgwEUXVheTERMA8GA1UECwwIRGl2aXNpb24xJjAkBgNVBAMMHWJh
        c3Rpb24ub2NwNC5jc20tc3BnaS5hY21lLmVzMB4XDTIzMDkyMTE4NDAzM1oXDTI2
        MDcxMTE4NDAzM1owdzELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAlZBMREwDwYDVQQH
        DAhOZXcgWW9yazENMAsGA1UECgwEUXVheTERMA8GA1UECwwIRGl2aXNpb24xJjAk
        BgNVBAMMHWJhc3Rpb24ub2NwNC5jc20tc3BnaS5hY21lLmVzMIIBIjANBgkqhkiG
        9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv3eDBDh1GH6i+hptdlbMPYztWDsHCihyjRta
        WgD3SEyHobuWM/lSepwMC2mmyejZKsv/x4PYFsNrWBwt1oVicP3+sGNuNfKheFgn
        LAiXAgt35MLPR7oXZKCb82rb5jFUYWU6Ro2xHv8qxLAAv+BRzq5fDYczvsps3pq0
        rvdNLfCORBmtQnoRuKXTmOreQgZqHZkhb1g8P4jE+BJugSAQT4gy1cnP5HXFqpdC
        qaehQeQEi+k3yHVdYnMyVC2Ya609SUUeSUxuLrlO2EQTSwLzSZ02sMsIfBKbOgmu
        TJPGgd5jqrSu1LDem8YKws8u0MVEhkl3LkuUuOYBbt4kPxoTIwIDAQABo2IwYDAL
        BgNVHQ8EBAMCAuQwEwYDVR0lBAwwCgYIKwYBBQUHAwEwKAYDVR0RBCEwH4IdYmFz
        dGlvbi5vY3A0LmNzbS1zcGdpLmFjbWUuZXMwEgYDVR0TAQH/BAgwBgEB/wIBATAN
        BgkqhkiG9w0BAQsFAAOCAQEAEIanwOhmODUlshlmpXUMeAa7g8S/cEUy19tpo932
        /sHoxVJogMVdxBY2V1EjNUPr/6PImesUq0IA1piYXqdxw23kiTgAM01THn6xq9Bn
        ef7jKPuD7dVY1V8xMmt9EF1Bh4aTObCotF/6XOnBA6NaxWNq5jJ7dfRVU7Vqh5xa
        hyGRglgJw1LmrhwXTHLi6XBZXuwVlAw5HZFEsKsqD/6YqhmTMV7DA3Er/g3Qv1iJ
        NmnM5Ftr1huVtwXuETzm0VHIteSWXBV8/c4+COTlQpwVH2mQRcAZQsW8FibQIjP5
        k/26D0f5XWdf0u6cLowCmWRWhHrTe0ttUUm5ZcP7xeZNjA==
        -----END CERTIFICATE-----
    imageContentSources:
    - mirrors:
      - bastion.ocp4.platformengineers.xyz:8443/openshift/release
      source: quay.io/openshift-release-dev/ocp-v4.0-art-dev
    - mirrors:
      - bastion.ocp4.platformengineers.xyz:8443/openshift/release-images
      source: quay.io/openshift-release-dev/ocp-release
    ```

    !!! warning "Important"
        Remember the `additionalTrusBundle` and `imageContentSources` sections come from the data output in the steps above.

    The highlighted content on the `pullSecret` tag is the base64-encoded username and password obtained on the [Create the private image registry in the offline bastion](#22-create-the-private-image-registry-in-the-offline-bastion) section when we ran the `mirror-registry install` command.

    ```{ .text .copy title="[root@bastion ocp4]"}
    echo -n 'init:passw0rd' | base64 -w0
    ```

    ```{ .text .no-copy title="Output"}
    aW5pdDpwYXNzdzByZA==
    ```

    !!! tip
        If you used the default `passw0rd` when installing your Quay private image registry, the `pullSecret` value in the `instal-config.yaml` above will be exactly the same value you need to use.

    The content for the `sshKey` tag is the output of:

    ```{ .text .copy title="[root@bastion ocp4]"}
    cat /root/.ssh/id_ed25519.pub
    ```

    ```{ .text .no-copy title="Output"}
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICIl3vZvi6eh1SkTE9EWKnZZwG6bVvZZzZzBHuKgbrVW root@bastion.ocp4.platformengineers.xyz
    ```

1. Create a copy of the `install-config.yaml` file in another directory, as it is automatically deleted in the following steps:

    ```{ .text .copy title="[root@bastion ocp4]"}
    cp install-config.yaml ../install-config.yaml
    ```
