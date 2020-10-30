include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

dependency "s3" {
  config_path = "../../../foundation/s3"
  mock_outputs_allowed_terraform_commands = ["destroy"]
  mock_outputs = {
    tracking_arn = "fake-tracking_arn"
    artifacts_bucket = "fake-artifacts_bucket"
  }
}


terraform {
  //source = "git::git@github.com:foo/modules.git//frontend-app?ref=v0.0.3"
  source = "../../../../../snowplow-starter-aws/snowplow-realtime/snowplow/4-storage/lambda-tsv-to-json-transformer//"
}

inputs = {
  deploy_s3_bucket = dependency.s3.outputs.artifacts_bucket
  deploy_s3_key = "snowplow-tsv-to-json-transformer/961d99b809096547bef29d5010e62f8c"
  trigger_s3_bucket_arn = dependency.s3.outputs.tracking_arn
}
