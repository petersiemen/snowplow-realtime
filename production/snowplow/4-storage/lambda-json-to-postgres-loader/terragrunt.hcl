include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

dependency "s3" {
  config_path = "../../../foundation/s3"
}

dependency "rds" {
  config_path = "../../../foundation/rds"
}

terraform {
  //source = "git::git@github.com:foo/modules.git//frontend-app?ref=v0.0.3"
  source = "../../../../../snowplow-starter-aws/snowplow-realtime/snowplow/4-storage/lambda-json-to-postgres-loader//"
}

inputs = {
  deploy_s3_bucket = dependency.s3.outputs.artifacts_bucket
  deploy_s3_key = "snowplow-json-to-postgres-loader/00adc99e7e32edc4d8e9bb026dab7aa6"
  trigger_s3_bucket_arn = dependency.s3.outputs.tracking_arn

  dwh_database = "snowplow"
  dwh_host = dependency.rds.outputs.host
  dwh_port = dependency.rds.outputs.port
  dwh_username = dependency.rds.outputs.username
  dwh_password = dependency.rds.outputs.password


}
