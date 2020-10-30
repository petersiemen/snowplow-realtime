include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

terraform {
  source = "../../../../../snowplow-starter-aws/snowplow-realtime/snowplow/3-enrich/scala-stream-enrich//"
}

dependency "ecs-cluster" {
  config_path = "../../../foundation/ecs-cluster"
}

dependency "kinesis" {
  config_path = "../../kinesis"
  mock_outputs_allowed_terraform_commands = [
    "destroy"]
  mock_outputs = {
    collector_good_arn = "fake-collector_good_arn"
    enriched_good_arn = "fake-enriched_good_arn"
    enriched_good_pii_arn = "fake-enriched_good_pii_arn"
    enriched_bad_arn = "fake-enriched_bad_arn"
  }
}

inputs = {

  image = "petersiemen/snowplow-stream-enrich-kinesis:1.1.3"
  region = local.common.inputs.aws_region
  account_id = local.common.inputs.production_account_id

  ecs_cluster_id = dependency.ecs-cluster.outputs.cluster_id
  ecs_default_capacity_provider = dependency.ecs-cluster.outputs.default_capacity_provider
  ecs_default_capacity_provider_base = 0
  ecs_default_capacity_provider_weight = dependency.ecs-cluster.outputs.default_capacity_provider_weight

  collector_stream_good_arn = dependency.kinesis.outputs.collector_good_arn
  enricher_stream_good_arn = dependency.kinesis.outputs.enriched_good_arn
  enricher_stream_good_pii_arn = dependency.kinesis.outputs.enriched_good_pii_arn
  enricher_stream_bad_arn = dependency.kinesis.outputs.enriched_bad_arn
  enricher_state_table = "snowplow-scala-stream-enrich"

  task_cpu = 1024
  task_memory = 1024
  desired_count = 1

}
