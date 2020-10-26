include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

terraform {
  source = "../../../snowplow-starter-ecs/snowplow-ecs//alb/"
}


inputs = {
  ami_id = local.common.inputs.amazon_linux_2_ami
  vpc_public_subnets = local.common.inputs.subnet_ids
  dns_provider = local.common.inputs.shared_services_account_profile
  dns_provider_region = local.common.inputs.aws_region

}
