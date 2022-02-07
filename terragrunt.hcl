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
  #tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaa3roehpairwhfhzenxbmofim6ies4h7cvcowbzv26ia3oiq47ygga"
  #user_ocid    = "ocid1.user.oc1..aaaaaaaa7fcbiowrdo4fcy37c6wqbwfewzhc4tinkbfh6zdethvk4ht7lgzq"
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
    key                         = "${path_relative_to_include()}/terraform.tfstate"
    region                      = local.region
    endpoint                    = "https://${local.os_namespace}.compat.objectstorage.${local.region}.oraclecloud.com"
    encrypt                     = true
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
    # AWS... must be declared as environment variables
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

