include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

terraform {
  //source = "git::git@github.com:snowplow-starter-aws/snowplow-realtime.git/foundation/ecs-cluster//?ref=master"
  source = "../../../../snowplow-starter-aws/snowplow-realtime/foundation/ecs-cluster//"
}

dependency "admin" {
  config_path = "../admin"
  mock_outputs_allowed_terraform_commands = ["destroy"]
  mock_outputs = {
    key_name = "fake-key_name"
  }
}

dependency "alb" {
  config_path = "../alb"

  mock_outputs_allowed_terraform_commands = ["destroy"]
  mock_outputs = {
    security_group_lb_id = "fake-security_group_lb_id"
  }
}


inputs = {

  vpc_id = local.common.inputs.vpc_id
  private_subnets = local.common.inputs.subnet_ids
  security_group_lb_id = dependency.alb.outputs.security_group_lb_id
  amazon_linux_2_ecs_ami = local.common.inputs.amazon_linux_2_ecs_ami
  instance_type = "t3.small"
  min_size = 0
  max_size = 3
  desired_capacity = 3
  key_name = dependency.admin.outputs.key_name
}
