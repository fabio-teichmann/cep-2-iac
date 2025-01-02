# cep-2-iac
Creating and reproducing infrastructure and cloud environments


## Terraform basics

1. Module-approach: 
  - all `.tf` (config) files in the same folder will be run together
  - modules can interact with each other
  - distinction between root modules and other modules; entrypoint usually `main.tf`
2. Providers: where infrastructure should be managed (usually a cloud provider or Kubernetes, etc.)
3. config files can come in native tf syntax (`.tf`) or JSON (`.tf.json`)
4. commands:
  - `terraform init` -- initializes working directory
  - `terraform plan` -- compares current state to current configuration (does not make changes!)
  - `terraform validate` -- 
  - `terraform apply` --

### Env Vars
Environment variables in TerraForm need two things:
1. in the config file it needs to be declared as a `variable` (with type)
2. the name of the variable needs to be prefixed by `TF_VAR_` at declaration

The variable can be accessed using `var.{variable name}` within the config script.

