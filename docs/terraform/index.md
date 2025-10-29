---
title: Intro to Terraform
---

Welcome to the Terraform section of the Platform Engineering Bootcamp. This introduction is intended as a quick overview on What Terraform is, Terraform core concepts and Terraform best practices. It does not aim to cover all aspects of the tool, rather just enough to get started with the lab.

# What is Terraform?

Terraform is an __infrastructure as code__ tool that lets you build, change, and version infrastructure safely, efficiently and in an automated way.

Terraform uses a __declarative__, high-level configuration language called HashiCorp Configuration Language (HCL) to describe the __desired “end-state”__ cloud or on-premises infrastructure for running an application. It then generates a plan for reaching that end-state and runs the plan to provision the infrastructure.

You can use terraform to manage infrastructure in the cloud and beyond.

# Terraform Glossary 

### Declarative (vs Imperative)
The term "declarative" is frequently used to describe Terraform. By "declarative" we mean the ability to describe how infrastructure should be configured via a high level configuration language.

For example, let's look at how to define an AWS S3 bucket using terraform:

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "prod-bucket"
    Environment = "production"
  }
}
```

> This block defines an S3 bucked called `my-tf-test-bucket` and tags it with a `Name` and `Environment` tag.

Instead of outlining all the steps required to configure your environment, the above HCL code snippet defines (or declares) how you want your bucket to be configured. Terraform is able to understand this higher level configuration and translate it into the steps required to configure your infrastructure.


By contrast, an "imperative" approach defines the specific commands needed to achieve the desired configuration, and looks like this:

```bash
aws s3api create-bucket --bucket my-tf-test-bucket

aws s3api put-bucket-tagging --bucket my-tf-test-bucket --tagging 'TagSet=[{Key=Name,Value=prod-bucket},{Key=Environment,Value=production}]'
```

> Here we are using the AWS CLI to create the same S3 resource.

While the above command produces the same result as the terraform code, it creates some challenges when working as part of a Platform Engineering team:

1. **How do you document what you did, allowing others to collaborate with you?** (maybe try to use a shell script in git? This approach can grow in complexity **very** quickly)
2. **How do you ensure you can reliably reproduce and repeat it?** (re run the shell script? What if some of the dependencies for your resources have changed?)
3. **How do keep track of any changes to the infrastructure you have deployed?**

By using a __declarative__ language, terraform solves these (and many more) problems for Platform Engineering teams. It documents the configuration deployed in a way that is scalable and easy to collaborate on. Furthermore, by writing HCL you can describe how you want (desire) your resources to be configured - allowing terraform to detect any changes from it.

### Desired (end) State vs Current State

When writing HCL, you are defining the resources (and configuration) you want your infrastructure to have: this is the `desired state`. Conversely, the `current state` represents the objects (and their configuration) that actually exist within your infrastructure at present.

Terraform is able to deploy your desired state, as well as reconcile differences between the desired state (as defined in HCL code) and the current state of your infrastructure in an automated and repeatable way. In doing so, it is considered an `Infrastructure as Code (IaC)` tool.

### Infrastructure as Code (IaC)

`Infrastructure as Code (IaC)` is the managing and provisioning of infrastructure through code instead of through manual processes. IaC comes with many benefits, including:

1. IaC automates the deployment and configuration of cloud resources in a repeatable way, saving Platform Engineering teams time and reducing errors
2. Using declarative IaC tools such as terraform makes it easy for Platform teams to collaborate, at scale
3. An IaC tool such as terraform allows you to version control changes to your infrastructure, making it easy to audit when changes are introduced, and roll back unwanted changes.


# Core Terraform Core Concepts

## Terraform Resources

Resources are the most important element in the Terraform language. Each resource block describes one or more infrastructure objects, such as virtual networks, compute instances, or higher-level components such as DNS records. For example, the following resource provisions a COS bucket in IBM Cloud:

```hcl
# Resource: Create an IBM Cloud Object Storage bucket
resource "ibm_cos_bucket" "example_bucket" {
  bucket_name          = "my-example-bucket"
  resource_group_id    =  ibm_resource_group.existing_group.id
  storage_class        = "standard"
  region_location      = "us-south"
  endpoint_type        = "public"
}
```

You can configure resources using `arguments` (`bucket_name`, `resource_group_id`, etc.. in the example above).

You can reference resources using `attributes`. Attributes are data and metadata related to your resource that might not be known until after creation, but you might still want to reference in your code. 

For example, you might need to reference the `id` of the COS bucket created in the example above.

[More on Terraform resources here](https://developer.hashicorp.com/terraform/language/resources)

## Terraform Data Sources

Terraform code will often need to reference resources that are not defined within it. `Data sources` allow Terraform to use information defined outside of Terraform, defined by another separate Terraform configuration, or modified by functions.

```hcl

# Data source: Get an existing resource group
data "ibm_resource_group" "existing_group" {
  name = "Default"
}

# Resource: Create an IBM Cloud Object Storage bucket
resource "ibm_cos_bucket" "example_bucket" {
  bucket_name          = "my-example-bucket"
  resource_group_id    = data.ibm_resource_group.existing_group.id
  storage_class        = "standard"
  region_location      = "us-south"
  endpoint_type        = "public"
}
```

[More on Terraform data sources here](https://developer.hashicorp.com/terraform/language/data-sources)

## Terraform State

`Terraform State` stores information about your managed infrastructure and configuration. This state is used by Terraform to map real world resources to your configuration and keep track of metadata. Terraform will store state as a simple JSON in a `terraform.tfstate` file:

```JSON
{
  "version": 4,
  "terraform_version": "1.6.0",
  "serial": 1,
  "lineage": "a1b2c3d4-e5f6-7890-1234-56789abcdef0",
  "outputs": {},
  "resources": [
    {
      "mode": "data",
      "type": "ibm_resource_group",
      "name": "existing_group",
      "provider": "provider[\"registry.terraform.io/ibm-cloud/ibm\"]",
      "instances": [
        {
    ...
```
Terraform uses state to build, change and manage infrastructure, as well as when reconciling any changes to infrastructure to the desired state.

[More information on Terraform State here](https://developer.hashicorp.com/terraform/language/state)

## Terraform providers

Terraform relies on plugins called providers to interact with cloud providers, SaaS providers, and other APIs. Each provider adds a set of resource types and/or data sources that Terraform can manage.

[There is a rich catalogue of Terraform providers which can be browsed on the Terraform Registry](https://registry.terraform.io/browse/providers)

## Terraform Modules

Modules are containers for multiple infrastructure resources that are used together. For example, a module might group an IBM Cloud VPC, a Virtual Server Instance and a Volume required to deploy an application.

One of the great benefits of Terraform is its ability to group infrastructure components into broader modules, allowing you to reliably manage infrastructure at scale

There are a number of existing terraform modules on Github. You can find an example of a module for [IBM COS here](https://github.com/terraform-ibm-modules/terraform-ibm-cos)

[More information on Terraform Modules here](https://developer.hashicorp.com/terraform/language/modules)


## Terraform Variables and Outputs

## Input 

Input variables let you customize aspects of Terraform modules without altering the module's own source code – you can think of them as a parameter for a function. You can define a variable using a variable block, allowing you to define its type and an optional default value:

```hcl
variable "image_id" {
  type = string
}

variable "availability_zone_names" {
  type    = list(string)
  default = ["us-west-1a"]
}
``` 
Variables allow the consumers of your code to customize its behaviour without changing the underlying HCL code. 


## Output 

Output values make information about your infrastructure available on the command line, and can expose information for other Terraform configurations to use. Output values are similar to return values in programming languages:

```hcl
output "instance_ip_addr" {
  value = ibm_vsi_instance.primary_ip
}
```
[Find more on variables here](https://developer.hashicorp.com/terraform/language/values/variables)

## Terraform CLI

The main way to interact with Terraform is via its CLI. It allows you to validate your HCL configuration, create infrastructure, reconcile changes and destroy infrastructure (and much much more)

[Find more on the Terraform CLI here](https://developer.hashicorp.com/terraform/cli/commands)


# Terraform Best Practices

## General

* You should store your project in github, and can use [the following `.gitignore` to get started](https://github.com/github/gitignore/blob/main/Terraform.gitignore)
* Don't hardcode values that can be passed as variables or discovered using data sources
  
While Terraform __can__ automate just about anything, it doesn't mean it __should__. Keep resource modules as plain as possible:

* Terraform is best at automating deployment and managment of infrastructure (usually from a cloud provider). If you are looking to automate instance configuration (e.g installing application dependencies, running prerequisite scripts and deploying an application on a remote server) consider using [`Ansible`](https://docs.ansible.com/ansible/latest/getting_started/index.html)
* Similarly, while Terraform can deploy resources to OpenShift and Kubernetes, it is not designed to do this. Consider using a tool like [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) - or ideally the `OpenShift GitOps Operator` -  instead

## Terraform Project structure

Terraform project should be composed of at least 3 files:

1. `main.tf` - defines the resources (e.g. resource blocks and data sources) managed by your project
2. `variables.tf` - defines input variables to your terraform project
3. `outputs.tf` - defines the output variables for your terraform project

If your project grows in size, you will want to organise following a module structure, trying to group resources that should logically be configured together in nested modules:

```
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── ...
├── modules/
│   ├── nestedA/
│   │   ├── README.md
│   │   ├── variables.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   ├── nestedB/
│   ├── .../
```

[More on project structure here](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform State Management

By default, terraform will manage state on your local machine in a `terraform.tfstate` file. This is fine for local development, but can pose a hindrance to collaborating with other Platform Engineers.

!!! warning "Sensitive Terraform State"
    **You should never store a terraform state in git, as it may contain sensitive values such as passwords!**

As a best practice, always try to configure your code to use`Remote State`, where Terraform writes the state data to a remote data store such an `S3 bucket` or `Terraform Cloud`. Remote State is a secure way to easily share state resources with your team.

[More on remote state](https://developer.hashicorp.com/terraform/language/state/remote)

!!! success "Next Steps"
    You are now ready to proceed to the [Terraform VSphere Lab](./terraform-vsphere-lab.md)