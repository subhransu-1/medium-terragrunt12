remote_state {
  backend = "s3"
  config = {
    bucket  = "medium-terragrunt-example1"
    key     = "terragrunted/${path_relative_to_include()}.tfstate"
    encrypt = false
  }
}

terraform {
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()
    optional_var_files = [
      find_in_parent_folders("regional.tfvars"),
    ]
  }
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region to create infrastructure in"
  type        = string
}

terraform {
  backend "s3" {
  }
}

EOF
}

