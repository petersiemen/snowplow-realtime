include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

terraform {
  //source = "git::git@github.com:foo/modules.git//frontend-app?ref=v0.0.3"
  source = "../../../snowplow-starter-ecs/snoplow-ecs/ecs-cluster//"
}

dependency "admin" {
  config_path = "../admin"
}

dependency "alb" {
  config_path = "../alb"
}


inputs = {

  vpc_id = local.common.inputs.vpc_id
  private_subnets = local.common.inputs.subnet_ids
  security_group_lb_id = dependency.alb.outputs.security_group_lb_id
  amazon_linux_2_ecs_ami = local.common.inputs.amazon_linux_2_ecs_ami
  instance_type = "t3.small"
  desired_capacity = 1
  min_size = 0
  max_size = 2
  key_name = dependency.admin.outputs.key_name
}
