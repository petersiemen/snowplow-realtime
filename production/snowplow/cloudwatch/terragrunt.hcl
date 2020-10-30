include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

terraform {
  source = "../../../../snowplow-starter-aws/snowplow-realtime/snowplow/cloudwatch//"
}

dependency "alb" {
  config_path = "../../foundation/alb"
  mock_outputs_allowed_terraform_commands = ["destroy"]
  mock_outputs = {
    arn_suffix = "fake-arn_suffix"
  }
}

dependency "ecs-cluster" {
  config_path = "../../foundation/ecs-cluster"
  mock_outputs_allowed_terraform_commands = ["destroy"]
  mock_outputs = {
    cluster_name = "fake-cluster_name"
  }
}

dependency "stream-enrich-kinesis" {
  config_path = "../3-enricher/stream-enrich-kinesis"
  mock_outputs_allowed_terraform_commands = ["destroy"]
  mock_outputs = {
    ecs_service_name = "fake-ecs_service_name"
  }
}

dependency "scala-stream-collector-kinesis" {
  config_path = "../2-collector/scala-stream-collector-kinesis"
  mock_outputs_allowed_terraform_commands = ["destroy"]
  mock_outputs = {
    ecs_service_name = "fake-ecs_service_name"
  }
}

inputs = {
  ecs_cluster_name = dependency.ecs-cluster.outputs.cluster_name
  alb_arn_suffix = dependency.alb.outputs.arn_suffix

  ecs_service_name_collector = dependency.scala-stream-collector-kinesis.outputs.ecs_service_name
  ecs_service_name_enrich = dependency.stream-enrich-kinesis.outputs.ecs_service_name

}
