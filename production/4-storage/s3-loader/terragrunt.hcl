include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

terraform {
  source = "../../../../snowplow-starter-ecs/snowplow-ecs/4-storage/s3-loader//"
}

dependency "ecs-cluster" {
  config_path = "../../ecs-cluster"
}

dependency "kinesis" {
  config_path = "../../kinesis"
}

dependency "s3" {
  config_path = "../../s3"
}

inputs = {

  image = "petersiemen/snowplow-s3-loader:0.7.0"
  region = local.common.inputs.aws_region
  account_id = local.common.inputs.production_account_id
  ecs_cluster_id = dependency.ecs-cluster.outputs.cluster_id

  in_stream_name = dependency.kinesis.outputs.enriched_good_name
  out_stream_name = dependency.kinesis.outputs.s3_loader_enriched_bad_name
  in_stream_arn = dependency.kinesis.outputs.enriched_good_arn
  out_stream_arn = dependency.kinesis.outputs.s3_loader_enriched_bad_arn
  s3_bucket = dependency.s3.outputs.tracking_bucket
  s3_bucket_arn = dependency.s3.outputs.tracking_arn

}
