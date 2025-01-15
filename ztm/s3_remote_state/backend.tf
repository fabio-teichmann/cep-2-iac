terraform {
  backend "s3" {
    bucket  = "cloud-config-cep-2"
    key     = "cep-2/s3_backend.tfstate"
    region  = "eu-central-1"
    profile = "cep-2-admin"
    # dynamodb_table = "cep-2-state-lock"
  }
}
