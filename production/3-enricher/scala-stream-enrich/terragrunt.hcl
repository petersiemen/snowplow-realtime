include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

terraform {
  source = "../../../../snowplow-starter-ecs/snowplow-ecs/3-enrich/scala-stream-enrich//"
}

dependency "ecs-cluster" {
  config_path = "../../ecs-cluster"
}

dependency "kinesis" {
  config_path = "../../kinesis"
}

inputs = {

  image = "petersiemen/snowplow-scala-stream-enrich:1.1.3"
  region = local.common.inputs.aws_region
  account_id = local.common.inputs.production_account_id

  ecs_cluster_id = dependency.ecs-cluster.outputs.cluster_id

  collector_stream_good_arn = dependency.kinesis.outputs.collector_good_arn
  enricher_stream_good_arn = dependency.kinesis.outputs.enriched_good_arn
  enricher_stream_good_pii_arn = dependency.kinesis.outputs.enriched_good_pii_arn
  enricher_stream_bad_arn = dependency.kinesis.outputs.enriched_bad_arn
  enricher_state_table = "snowplow-scala-stream-enrich"

  task_cpu = 1024
  task_memory = 1024
  desired_count = 1

}
