# Terraform Example

This repo demonstrates an approach for using [Terraform](https://www.terraform.io/) to manage
AWS resources.


## What's in the box

Applying this terraform code in a given environment will result in the
following infrastructure being created:

 - VPC with 1 private subnet and 1 public subnet
 - 1 or more EC2 instances in a "web" tier, configured to run `docker`
 - 1 MySQL RDS instance
 - 1 Redis ElastiCache instance

### ⚠️ Warnings ⚠️

 - Applying these changes **will cost you money**, so make sure you `destroy`
   them when you're done experimenting

 - The resulting infrastructure does not necessarily follow AWS best practices
   for secure and resilient production systems, so buyer beware


## Organization

The terraform code is organized into _environments_, found under
`terraform/envs`:

    $ ls terraform/envs/
    prod
    stage


Each environment comprises a `terraform.tfvars` file, which customizes the
terraform plan for that specific environment, and a `terraform.tfstate` file,
which reflects the live state of the environment's resources:

    $ ls terraform/envs/prod/
    terraform.tfstate
    terraform.tfvars


## Running `terraform`

Because of the non-standard organization described above, the
[`tf_wrapper`](/tf_wrapper) script must be used to run any `terraform`
commands:

    $ ./tf_wrapper ENV ACTION [ARGS]

For example, to plan changes in the prod environment, use:

    $ ./tf_wrapper prod plan

As noted above, if you `apply` any changes, make sure to `destroy` them when
you're done experimenting to avoid a surprising AWS bill:

    $ ./tf_wrapper prod destroy
