include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

terraform {
  source = "../../../../../snowplow-starter-aws/snowplow-realtime/snowplow/2-collector/scala-stream-collector-kinesis//"
}

dependency "ecs-cluster" {
  config_path = "../../../foundation/ecs-cluster"
}

dependency "kinesis" {
  config_path = "../../kinesis"
  mock_outputs_allowed_terraform_commands = ["destroy"]
  mock_outputs = {
    collector_good_arn = "fake-collector_good_arn"
    collector_bad_arn = "fake-collector_bad_arn"
  }
}

dependency "alb" {
  config_path = "../../../foundation/alb"
}


inputs = {

  image = "petersiemen/snowplow-scala-stream-collector-kinesis:1.0.1"
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
  desired_count = 1
  task_cpu = 1024
  task_memory = 1024

  collector_cookie_domain1 = "petersiemen.net"
  collector_cookie_domain2 = "caravan-markt24.de"
  collector_cookie_fallback_domain = "petersiemen.net"

}
