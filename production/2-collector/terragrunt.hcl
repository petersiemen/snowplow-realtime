include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

terraform {
  source = "../../../snowplow-starter-ecs/snoplow-ecs/2-collector//"
}

dependency "ecs-cluster" {
  config_path = "../ecs-cluster"
}

dependency "kinesis" {
  config_path = "../kinesis"
}

dependency "alb" {
  config_path = "../alb"
}


inputs = {

  image = "petersiemen/snowplow-stream-collector:1.0.1"
  domain = local.common.inputs.domain
  dns_provider = local.common.inputs.shared_services_account_profile
  dns_provider_region = local.common.inputs.aws_region
  account_id = local.common.inputs.production_account_id

  vpc_id = local.common.inputs.vpc_id

  ecs_cluster_id = dependency.ecs-cluster.outputs.cluster_id
  ecs_cluster_name = dependency.ecs-cluster.outputs.cluster_name
  ecs_default_capacity_provider = dependency.ecs-cluster.outputs.default_capacity_provider
  ecs_default_capacity_provider_base = 1
  ecs_default_capacity_provider_weight = dependency.ecs-cluster.outputs.default_capacity_provider_weight

  collector_stream_good_arn  = dependency.kinesis.outputs.collector_good_arn
  collector_stream_bad_arn = dependency.kinesis.outputs.collector_bad_arn

  zone_id = local.common.inputs.dns_zone_id
  lb_zone_id = dependency.alb.outputs.alb_zone_id
  lb_dns_name = dependency.alb.outputs.alb_dns_name
  lb_listener_443_arn = dependency.alb.outputs.alb_listener_443_arn
  lb_listener_80_arn = dependency.alb.outputs.alb_listener_80_arn

  max_count = 2
  min_count = 1
}
