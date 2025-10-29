---
Title: Solution: GitOps
hide:
    - toc
---

# Solution: GitOps

## Bastion and Workstation Prep

1. Download and install `argo` on Linux. [Other Platforms here](https://argo-cd.readthedocs.io/en/stable/cli_installation/)

    ```bash
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
    rm -f argocd-linux-amd64
    ```

2. Verify `argocd`

    ```bash
    # argocd version
    argocd: v2.14.2+ad27246
      BuildDate: 2025-02-06T00:06:23Z
      GitCommit: ad2724661b66ede607db9b5bd4c3c26491f5be67
      GitTreeState: clean
      GoVersion: go1.23.3
      Compiler: gc
      Platform: linux/amd64
    FATA[0000] Argo CD server address unspecified
    ```
    **Note:** The error does not apply. This is to ensure that the command `argocd` is in the PATH.

## OpenShift GitOps Operator Install

1. Login to OpenShift Console as kubeadmin.
2. Select Operaters->Operator Hub.
3. In the 'Search' Type 'open gitops' to search for OpenShift GitOps.
4. Select the 'Red Hat OpenShift GitOps' Operator.

    ![GitOps Operator Installation 1](./images/gitops_operator_install_1.png)

5. Install the OpenShift GitOps Operator with default values.

    ![GitOps Operator Installation 2](./images/gitops_operator_install_2.png)

6. Select Install

    ![GitOps Operator Installation 3](./images/gitops_operator_install_3.png)

7. The operator is installing

    ![GitOps Operator Installation 4](./images/gitops_operator_install_4.png)

9. Launch the ArgoCD Application in OpenShift.
 
    ![ArgoCD Launch](./images/gitops_argo_launch.png)

10. Login via OpenShift

    ![ArgoCD Login](./images/gitops_argo_login.png)

11. ArgoCD Console

    ![ArgoCD Console](./images/gitops_argo_console.png)
