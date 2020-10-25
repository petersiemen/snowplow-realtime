locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

remote_state {
  backend = "s3"
  generate = {
    path = "generated-backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "snowplow-ecs-terraform-terragrunt-state"
    key = "${path_relative_to_include()}/terraform-terragrunt-production.tfstate"
    region = get_env("aws_region")
    encrypt = true
    dynamodb_table = "snowplow-ecs-terraform-terragrunt-state-production"
  }
}

generate "provider" {
  path = "generated-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

provider "aws" {
  region = "${local.common.inputs.aws_region}"
  profile = "${local.common.inputs.production_account_profile}"
  assume_role {
    role_arn  = "arn:aws:iam::${local.common.inputs.production_account_id}:role/OrganizationAccountAccessRole"
  }
  version = "~> 3.0"
}

provider "aws" {
  region = "${local.common.inputs.aws_region}"
  alias = "${local.common.inputs.shared_services_account_profile}"
  profile = "${local.common.inputs.shared_services_account_profile}"
  assume_role {
    role_arn  = "arn:aws:iam::${local.common.inputs.shared_services_account_id}:role/OrganizationAccountAccessRole"
  }
  version = "~> 3.0"
}

provider "aws" {
  alias = "${local.common.inputs.master_account_profile}"
  region = "${local.common.inputs.aws_region}"
  profile = "${local.common.inputs.master_account_profile}"
  version = "~> 3.0"
}
EOF
}

inputs = merge(local.common.inputs, {
  account_id = local.common.inputs.production_account_id
  env        = "production"
})
