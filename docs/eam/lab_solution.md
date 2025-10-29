---
hide:
  - toc
---

# MAS Core and Manage Installation    

## OpenShift Gym request in TechZone

### TechZone Request

1. This example is using an OpenShift Gym.  The details to install OCP are out of scope for this document.  In this case the gym was requested and an OpenShift cluster has been provisioned using the VMware IPI installation method. [TechZone Gym Reservation](https://techzone.ibm.com/my/reservations/create/6421e3b3198c4332a346e403){target="_blank"}

    **Note:** [Link for OpenShift Install Examples](https://pages.github.ibm.com/skol/pe-bootcamp/ocp-on-vmware/){target="_blank"}

2. Cluster Build Details in the OpenShift Gym
    - Worker Node Count: 5
    - Worker Node Flavor: (32 vCPU v 64GB -- 300GB Operating System Disk)
    - Open Shift Version: 4.16 (Tested with this version) our

3. You will receive a secondary email once the OCP Cluster is ready for access.  

    **NOTE:** This could take 1 to 2 hours. Further this is not a perfect world, provisioning sometimes fails, or you may get a cluster with networking issues. The answer was to resubmit and/or delete the cluster then reprovision another one.

4. Install the OpenShift Cluster using the IPI install method.

    - [Deploying OpenShift on VMware](https://pages.github.ibm.com/skol/pe-bootcamp/ocp-on-vmware/){target="_blank"} 

5. Ensure that the following dependencies have been installed and/or enabled on the OpenShift cluster.

    - [Install ODF](https://pages.github.ibm.com/skol/pe-bootcamp/ocp-on-vmware/install-data-foundation/){target="_blank"}   
    - [Configure Local Image Repository](https://pages.github.ibm.com/skol/pe-bootcamp/ocp-on-vmware/config-image-registry/){target="_blank"}

## Ansible one-click CLI Installation 

### [Bastion or Workstation Setup for MAS Install](https://ibm-mas.github.io/ansible-devops/)

This installation will use Python Virtual Environments to install the required dependencies and Ansible.  This process should work very similarly on most unix/linux computers and even Windows with little or no modification.

1. Setup the bastion node in the gym, or a local macbook or linux instance.

    Perhaps the most difficult part in the installation now is getting your environment configured to execute the Ansible scripts against the OCP cluster. To utilize the Ansible one-click install you must do the following:  

2. Perform the remainder of the steps as the `root` user.

    ```bash
    sudo -i
    ```

3. ** RHEL 8 ONLY ** If your operating system is RHEL8 execute these commands. This sequence of commands will reboot the bastion node that is being used. A login after the reboot and `sudo -i` is required to complete these commands.

    ```bash
    yum update -y
    systemctl reboot
    yum install python3.9 -y
    python3.9 --version
    Python 3.9.20
    ```

4. Create a python virtual environment. This example will create the virtual environment in the ~/.localpy directory.  The full path for this directory will be /root/.localpy.

    ```bash
    python3.9 -m venv /root/.localpy
    ```

5. Activate this virtual Environment

    ```bash
    source /root/.localpy/bin/activate
    ```

6. The prompt will now indicate that the python virtual environment `.localpy` is now active.  Any python commands will now honor the virtual environment.

    ```bash
    (.localpy) [root@bastion ~]#
    ```

7. Install the python dependencies using `pip install` execute the folling commands to install the required python modules.

    ```bash
    pip install pip --upgrade
    pip install ansible
    pip install kubernetes
    pip install mas-devops
    pip install setuptools
    pip install jmespath
    ```

8. Install the Ansible Galaxy Collection required by the `one-click` install process.

    ```bash
    ansible-galaxy collection install ibm.mas_devops
    ```

9. Create a working directory for this MAS install

    ```bash
    mkdir -p ~/work/one-click/masconfig
    cd ~/work/one-click
    ```

10. Create a file for the required variables for one-click install of MAS-core. Create this file in the working directory (~/one-click)
n
   **Note:** This lab adds the environment variable KUBECONFIG to point to the cluster KUBECONFIG for OpenShift authorization

Example of vars.sh

```bash
export IBM_ENTITLEMENT_KEY='<paste ibm software entitlement here'
export MAS_INSTANCE_ID="inst1"
export MAS_CONFIG_DIR="~/one-click/masconfig"
export SLS_LICENSE_ID="IBM AMERICAS 2025 Internal Account"
export SLS_LICENSE_FILE="~/one-click/masconfig/a_mas_license.dat"
export DRO_CONTACT_EMAIL="don.bailey@ibm.com"
export DRO_CONTACT_FIRSTNAME="Don"
export DRO_CONTACT_LASTNAME="Bailey"
export KUBECONFIG=~/build2/auth/kubeconf
```

11.  Run the following command in the terminal to verify the OCP cluster
    is ready to be setup for MAS.

    ```bash
    ansible localhost -m include_role -a name=ibm.mas_devops.ocp_verify
    ```

12. Install MAS core

    ```bash
    ansible-playbook ibm.mas_devops.oneclick_core
    ```

13. Monitor the install by watching the terminal and the ansible output.  Also log in to the OpenShift cluster and monitor using the console.

14. Once the installation the output of the terminal will display the Admin Dashboard URL and credentials.

```bash
    "msg": [
        "Admin Dashboard ... https://admin.inst1.apps.ocpinstall.gym.lan",
        "Username .......... 7Y4uAMLrAyl3ztUaFlnaWe41pyq6Oskb",
        "Password .......... 4WSSc4V6p8covLLtdrMfaleQRWgFeyOy"
    ]
```

15. Log in using these temporary Admin credentials. Chrome seems to work better than Safari.

**Note:** If you get a blue spinning circle after entering follow these steps.

- using a web browser replace 'admin' with 'api' in the URL.  This has something to do with the self signed certificates.

```bash
https://admin.inst1.apps.ocpinstall.gym.lan
https://api.inst1.apps.ocpinstall.gym.lan
```
   
- You will see something similar to this

```bash
{"exception":{"id":"AIUCO1022E","properties":["/"]},"message":"AIUCO1022E: The requested URL could not be found: /","uuid":"8b2a1df6-3998-4912-b752-a214d77a8399"}
```

- The dashboard will work now

## Add MAS Manage and Demo Data

1. As the `root` user on the bastion node.

2. Install MAS Manage and Sample Data, this steps takes 10+ hours to complete.  Consider starting the installation in a tmux session so that if connectiviy is lost terminal output will be saved.

3. Add the following variables to ~/one-click/vars.sh

    ```bash
    export MAS_DB_IMPORT_DEMO_DATA=true
    export MAS_APP_SETTINGS_DEMODATA=true
    ```

4. Update shell variables

    ```bash
    source ~/one-click/vars.sh
    ```

5. Install Manage and sample data.

- [Add Manage and Sample Data](https://ibm-mas.github.io/ansible-devops/playbooks/oneclick-manage/)

**Note:** This install will take up to 12 hours

```bash
ansible-playbook ibm.mas_devops.oneclick_add_manage
```

## IBM Maximo Application Suite CLI Utility (mas-cli)

### [mas-cli Setup for MAS Install](https://ibm-mas.github.io/cli/)

## Update the password for the user `maxadmin`

**Note:** These steps are for MAS 8.x and 9.0.  They will not work for MAS 9.1.

1. Log in to Maximo as the temporary user for the MAS Core deployment.

2. Naviage to IBM Maximo Application Suite from the 9 Box in the top right of the console.

3. Select `Suite administration`

4. Select Users, and search for maxadmin

5. Select Edit from the additional options on the right side of the maxadmin user.

6. Scroll down and select `Replace forgotten password`

7. Select 'Custom' and set the password for the `maxadmin` account.

## Update the default administration account for MAS 9.1

