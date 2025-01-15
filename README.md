# cep-2-iac
Creating and reproducing infrastructure and cloud environments

# TL;DR

## Recommended workflow
- create user profile specific to TF access needs (not admin)
- Backend & State Lock
  - provision infrastructure for state lock (S3 + DynamoDB)
  - ensure versioning and encryption are enabled (!)
  - ensure DynamoDB has `LockID` of type `string` (!)
- configure `backend` to use configured infrastructure --> use **partial configuration**
- 


# TerraForm

1. Module-approach: 
  - all `.tf` (config) files in the same folder will be run together
  - modules can interact with each other
  - distinction between root modules and other modules; entrypoint usually `main.tf`
2. Providers: where infrastructure should be managed (usually a cloud provider or Kubernetes, etc.)
3. config files can come in native tf syntax (`.tf`) or JSON (`.tf.json`)


## Command workflow
- `terraform init` -- initializes working directory
- `terraform plan` -- compares current state to current configuration (does not make changes!)
- `terraform apply` -- creates all infrastructure elements that are required to create the current configuration (difference between current and desired state)
- `terraform destroy` -- deletes resources listed in the configuration
    - ` -target {general resource name}.{resource name from config}` --> destroys selected resource only
- `terraform fmt` -- formats config files

> [!NOTE]
> Changes in the backend or modules used in the configuration will require to re-run `terraform init` to include those changes in the root module.


## State
Stores bindings between configuration file and real-life state. Automatically generated/updated when run `terraform apply/destroy`. Stored in JSON format.

Use `terraform state list` to see resources and their names saved in the state. Using `terraform show` we can assess the state using the CLI (e.g. `grep`).

Can use `-replace {resource}` flag to `terraform -apply` to specifically replace a resource (destroy and recreate). This can be useful, when the system is not functioning properly.

> [!IMPORTANT]
> The local state will **contain all sensitive information in clear text**. Thus, never add to repo or share otherwise.


## Variables
There are 3 classes of variables in terraform:
1. `variable "name" {}`: can change with different inputs to the configuration. Defining a default value is optional but might be enforced when applying the configuration. Are referenced as `var.name`
2. `locals { var1 = "" }`: similar to global variables, static per configuration. Referenced as `local.var1`
3. `output "name" {}`: similar to return values in a classic function. Can be used to reference values from a module within the root or use them between modules. Referenced as `output.name`

Usually, variable definitions are kept in a separate file `variables.tf`. Values are accessible in a module the same way as the environment variables. Additionally, the file `terraform.tfvars` can be used to set variables. If the desired variable (in config file) does not exist in this file, it will look in `variables.tf` for any default definitions. If that's also not available, the user will be prompted when applying the infrastructure. Variables in child modules that don't have a default are mandatory to define in root.

When using `terraform plan/apply`, variable inputs can be overwritten using the `-var="{variable_name}={value}` tag.


### Variable types
There are two types of variables in TerraForm:
1. simple: `number`, `string`, `bool`, `null`
2. complex:
  - collection types: `list`, `map` (like py dict), `set`
  - structural types: `tuple`, `object`


### Env Vars
Environment variables in TerraForm need two things:
1. in the config file it needs to be declared as a `variable` (with type)
2. the name of the environment variable needs to be prefixed by `TF_VAR_`

The variable can be accessed using `var.{variable name}` within the config script.

> [!IMPORTANT]
> Environment variables have the lowest precedence


### Locals
Named values that can be referred to in config files. They do not change value. Only available in current module (locally scoped).

```tf
# locals.tf
locals {
  key = value
  ...
  owner = "DevOps Team"
  common_tags = {
    Name = "dev"
    Environment = "development"
    Version = 1.10
  }
}

# main.tf
resource ... {
  tags = local.common_tags
}
```


### Output values
Used to export structured data about resources. Recommended to keep in separate file.



## Looping (`count` / `for_each`)
Count (using lists) can cause issues since lists are ordered. Eliminating an element in between may cause an error and/or undesired behavior.
Count can be used with every resource.

> [!NOTE]
> helpful in-built functions for handling: `element()` and `length()`


## Dynamic blocks
Can be used with:
- resource
- data
- provider
- provisioner

Allows to dynamically generate multiple elements of a resource without repeating the block itself (e.g. multiple ingress rules for the same SG).


## Conditional expressions
Kinda replacement for if/else in TerraForm.

```tf
variable "env" {
  type = string
  default = "test"
}

# main.tf
resource "xyz" "prod-foo" {
  # ...
  count = var.env == "prod" ? 1:0
}
```



## Built-in functions
[Documentation](https://developer.hashicorp.com/terraform/language/functions)


## Splat expressions
Lists, sets, tuples

Example:
```tf
output "private_addresses" {
  value = aws_instance.server[*].private_ip
}

```


## Data sources
Can be used to dynamically apply AMI's (have different IDs across regions).


## Logs
Use env vars:
- `export TF_LOG=DEBUG`
- `export TF_LOG_PATH={file location and name}.log`


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


### Initialization / start-up scripts (automation)
Instead of manually logging into an instance to set it up properly (e.g. install software), this should also be provided automatically when the infrastructure is provisioned. There are multiple ways to achieve this:

1. using `user_data` attribute
2. using `cloud-init` (industry standard)
3. using an open-source tool like Packer
4. using Provisioners

#### `user_data` attribute
Passes commands to cloud provider which runs them on instance. Viewable in AWS console. Ideomatic and native to cloud provider.


#### cloud-init
Standard for customizing instances. Runs on most Linux distributions and cloud providers. Can run per-instance or per-boot configurations.


#### Provisioners
> [!WARNING]
> Should be a last resort and used with care!  



## TerraForm Backends and Remote State Management
The state file is created/stored locally and reflects all recent changes to the configuration. To avoid complications and conflicts that could arise from differing configuration states, TerraForm offers **Backends** (store states remotely). Default backend is local. TerraForm supports a number of different storage locations as backend options - those are called [work spaces](https://developer.hashicorp.com/terraform/language/state/workspaces).

### Using work spaces
To configure a work space, we need to add a block to the `terraform {...}` config block:

```
# example for amazon s3 bucket
terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key" # where the file is written to
    region = "us-east-1"
    profile = "test-user"
  }
}
```

> [!NOTE]
> The recommended way is to use a partial configuration; meaning the `backend` block will be mostly empty and missing values are supplied at `init`. E.g. `terraform init -backend-config="path-to-be-config"`.

By default, the S3 bucket does not enforce a state lock. To achieve this, we need to add a DynamoDB table to the S3 configuration (see [State Locking](https://developer.hashicorp.com/terraform/language/backend/s3#state-locking)):

```
# example for amazon s3 bucket
terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key" # where the file is written to
    region = "us-east-1"
    profile = "test-user"
    dynamodb_table = "table_name"
  }
}
```

## Security best practices
Secret values should never appear in clear text in the configuration files as those files will be checked-in into Git. I circumvented this in the beginning by using (local) environment variables and terraform variables.

> [!NOTE]
> I learned there is another even more convenient way for authenticating to AWS with the secret keys: using `profile` argument in the `provider` block and set it to the desired user. That user has to be defined in the aws config files (`~/.aws/config` and `~/.aws/credentials`).


> [!IMPORTANT]
> Keep in mind, that shell commands are stored in the shell's `history`(!). I.e. if a secret appears in `export ...` in clear text, it will show in the history as well. To avoid this security issue, type an extra whitespace before a command ` export ...`.


The state file by default shows srcrets in clear text. Hence, it is of vital importance to store the statefile(s) in an encrypted manner (both at rest and in transit) to avoid corruption and undesired access.

### Secret manager
There are several options for a secret manager that will ensure security and encryption of secrets. E.g. HashiCorp Vault (25 secrets free), AWS Secrets Manager (paid), etc.


## TerraForm Modules
A set of configuration file(s) in a single directory are called Module. Modules organize and encapsulate functionality of a configuration. There are two types: (1) local modules, and (2) remote modules. Refers to the location of the config files.

```
root module
|-- child module 1
|-- child module 2
|-- ...
...
```

Modules in root can be used using the `module` block and they need a re-init (!):
```
module "mod-name" {
  source = "path/to/module"
  var_name = value
  ...
}
```
Modules can be parameterized to provide more flexibility. To achieve this, the relevant parameters inside the module (configuration) need to be set to variables (e.g. in the `variables.tf` file of that module). The same variable names can be set in the root module with desired values. Parameters that are not set in root, will deviate to the defined default. **If no default is specified the parameter is mandatory to be set in root**.


### Accessing child module outputs
Especially, when we need to refer to/access a dynamically generated attribute of a resource while it's created - e.g. the ID of a vpc - we need to access that value from the child module where the resource is defined (child module).

To do that, define `output` blocks for relevant parameters that need to be passed down to root. In root, use `module.{module_name}.{output_name}` to access the parameter.

> [!NOTE]
> One child module **cannot** use the outputs of another child module(!). These need to be passed up through root.

> [!IMPORTANT]
> When the root configuration is run, filepaths are evaluated from that modules position.


### TerraForm registry
Instead of writing each module by oneself, the [TerraForm Registry](registry.terraform.io) can be leveraged to import pre-built modules. These modules need to be customized to the individual use case.
