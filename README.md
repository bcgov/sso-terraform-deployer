# terraform-openshift-deployer

Terraform module which creates a service account to deploy applications on Openshift cluster.

## Usage

```hcl
module "openshift" {
  source  = "bcgov/openshift/deployer"
  version = "0.1.0"

  name: my-deployer
  namespace: xxxxx-dev
}
```
