locals {
  # Extract the needed variables for easy access on this file
  environment    = "dev"
  region         = "eu-frankfurt-1"
  os_namespace   = "frdv3joeh99d"
  os_bucket_name = "os-terraform-dev-001"
}

# Generate an OCI provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "oci" {
  region       = "${local.region}"
  # tenancy_ocid, user_ocid, fingerprint and private_key_path or private_key variables must be declared as environment variables
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an Object Storage bucket
remote_state {
  backend = "s3"
  config = {
    bucket                      = local.os_bucket_name
    key                         = "${replace(path_relative_to_include(), "/", "%2F")}%2Fterraform.tfstate"
    region                      = local.region
    endpoint                    = "https://frvn5ignckvl.compat.objectstorage.eu-frankfurt-1.oraclecloud.com"
    shared_credentials_file     = "./s3.credentials"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Configure root level configuration that all resources can inherit.
terraform {
  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=15m"]
  }
  extra_arguments "parallelism" {
    commands  = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=2"]
  }
}

