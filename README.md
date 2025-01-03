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
> Environment variables have the lowest precedence


### Variables
Usually, kept in a separate file `variables.tf`. Values are accessible in module the same way as the environment variables. Additionally, the file `terraform.tfvars` can be used to set variables (act kind of like env vars). If the desired variable (in config file) does not exist in this file, it will look in `variables.tf` for any default definitions. If that's also not available, the user will be prompted when applying the infrastructure.

When using `terraform plan/apply`, variable inputs can be overwritten using the `-var="{variable_name}={value}` tag.


### Data sources
Can be used to dynamically apply AMI's (have different IDs across regions).


### Output values
Used to export structured data about resources. Recommended to keep in separate file.



## AWS EC2 Instances

### SSH keys
To log into a running instance, one way is to use SSH keypairs. Keys can be generated (locally) using:
```bash
ssh-keygen -t rsa -b 2048 -C 'test key' -N '' -f ~/.ssh/ test_key
```
`-t` - type
`-b` - number of bytes
`-C` - comment (optional)
`-N` - encryption phrase (optional / if empty no encryption)
`-f` - alternative location for key generation

Once generated, the access needs to be changed using `chmod 400 {private_key}`.


> [!IMPORTANT]
> The **public** key needs to be copied to the server for ssh connections. Also, the instance itself needs to have a public IP (`associate_public_ip_address = true`).
