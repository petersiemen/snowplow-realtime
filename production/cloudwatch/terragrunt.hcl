include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

terraform {
  source = "../../../snowplow-starter-ecs/snowplow-ecs/cloudwatch//"
}

dependency "alb" {
  config_path = "../alb"
}

dependency "ecs-cluster" {
  config_path = "../ecs-cluster"
}

inputs = {
  ecs_cluster_name = dependency.ecs-cluster.outputs.cluster_name
  alb_arn_suffix = dependency.alb.outputs.arn_suffix
}
