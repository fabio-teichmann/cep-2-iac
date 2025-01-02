# cep-2-iac
Creating and reproducing infrastructure and cloud environments


## Terraform basics

1. Module-approach: 
  - all `.tf` (config) files in the same folder will be run together
  - modules can interact with each other
  - distinction between root modules and other modules; entrypoint usually `main.tf`
2. Providers: where infrastructure should be managed (usually a cloud provider or Kubernetes, etc.)
3. config files can come in native tf syntax (`.tf`) or JSON (`.tf.json`)


###Useful commands
- `terraform init` -- initializes working directory
- `terraform plan` -- compares current state to current configuration (does not make changes!)
- `terraform validate` -- validates the syntax of config files (automatically done by `plan` and `apply`)
- `terraform apply` -- creates all infrastructure elements that are required to create the current configuration (difference between current and desired state)
- `terraform destroy` -- deletes resources listed in the configuration
    - ` -target {general resource name}.{resource name from config}` --> destroys selected resource only
- `terraform fmt` -- formats config files

### Env Vars
Environment variables in TerraForm need two things:
1. in the config file it needs to be declared as a `variable` (with type)
2. the name of the variable needs to be prefixed by `TF_VAR_` at declaration

The variable can be accessed using `var.{variable name}` within the config script.

> [!IMPORTANT]
> environment variables have the lowest precedence


### Variables
Usually, kept in a separate file `variables.tf`. Values are accessible in module the same way as the environment variables. Additionally, the file `terraform.tfvars` can be used to set variables (act kind of like env vars). If the desired variable (in config file) does not exist in this file, it will look in `variables.tf` for any default definitions. If that's also not available, the user will be prompted when applying the infrastructure.

When using `terraform plan/apply`, variable inputs can be overwritten using the `-var="{variable_name}={value}` tag.
