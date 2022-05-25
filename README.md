# terraform-openshift-deployer

Terraform module which creates a service account to deploy applications on Openshift cluster.

## Usage

```hcl
terraform {
  required_version = ">= 0.15.3"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "deployer" {
  source  = "bcgov/openshift/deployer"
  version = "0.9.0"

  name      = "oc-deployer"
  namespace = "xxxxxx-prod"
}

output "sc_secret" {
  value = module.deployer.default_secret_name
}
```
