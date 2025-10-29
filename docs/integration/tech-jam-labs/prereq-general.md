# Prerequisites for the Tech Jam

To complete all of the labs in the Integration Tech Jam you will likely need each of the following general utilities:

- SoapUI
- mailtrap
- OpenShift CLI (oc CLI)
- IBM Cloud Pak CLI (cloudctl)
- jq
- IBM API Connect Toolkit (apic cli)
- Container Runtime
- Git

You will very likely find most (if not all) of these utilities valuable when performing your Cloud Pak for Integration engagements and demos.

!!! danger "Disclaimer"
    There are some utilities that IBM does not allow on your corporate laptops.  We have done our best to point out only utilities that fit within policy.  Ultimately you are responsible for managing these utilities and corporate compliance.

## SoapUI

This is an alternative API testing utility similar to Postman.  Postman has been added to the IBM "not approved" list.  From [this page](https://www.soapui.org/downloads/soapui/){target="_blank"} you can download and install the SoapUI Open Source utility.  Specify the SoapUI tool during installation and if you have never used SoapUI, you may wish to download the tutorials.

## Mailtrap

!!! danger "Heads-Up"
    Use a non-IBM email address when signing up for mailtrap.  This will help you avoid some extra spam.

This email service is an easy, low profile way to provide a mail service used when configuring APIC.  Follow the steps at [mailtrap.io](https://mailtrap.io/){target="_blank"} to configure this tool.  

You will need your user and password for mailtrap when configuring APIC.

## OpenShift CLI

You very likely already have the OpenShift CLI installed on your laptop.  If not follow the instructions from Red Hat [here](https://docs.openshift.com/container-platform/4.10/cli_reference/openshift_cli/getting-started-cli.html){target="_blank"}  If you are unsure if you have the CLI?  Open a terminal window and type `oc`.

## IBM Cloud Pak CLI (cloudctl)

You can use IBM Cloud Pak® CLI (cloudctl) to view information about your cluster, manage your cluster, and more.  Instructions for installing the latest version are [found here](https://www.ibm.com/docs/en/cloud-paks/cp-integration/2022.2?topic=SSGT7J_22.2/cloudctl/3.x.x/install_cli.html){target="_blank"}.

## jq

jq is a lightweight and flexible command-line JSON processor.  For Mac users use `brew install jq` otherwise visit the [jq home page](https://stedolan.github.io/jq/){target="_blank"} for Windows and Linux.

## Container Runtime

If you do not have a container runtime installed on your laptop, you should install one.  Docker Desktop requires a license and is not a preferred option.  Consider installing [Colima](https://github.com/abiosoft/colima){target="_blank"} or [Podman](https://podman.io/){target="_blank"}

## Git

If you are unfamiliar with Git and running Git commands [follow this tutorial](https://docs.github.com/en/get-started/quickstart/set-up-git){target="_blank"}.  You will not need to be an expert but some familiarity will help.