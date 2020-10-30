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
    lambda_arn = "fake-lambda_arn"
  }
}

dependency "lambda-json-to-postgres-loader" {
  config_path = "../lambda-json-to-postgres-loader"

  mock_outputs_allowed_terraform_commands = ["destroy"]
  mock_outputs = {
    lambda_arn = "fake-lambda_arn"
  }
}

terraform {
  //source = "git::git@github.com:foo/modules.git//frontend-app?ref=v0.0.3"
  source = "../../../../../snowplow-starter-aws/snowplow-realtime/snowplow/4-storage/s3-bucket-notifications//"
}

inputs = {
  bucket = dependency.s3.outputs.tracking_bucket
  bucket_arn = dependency.s3.outputs.tracking_arn

  lambda_notifications = [
    {
      lambda_arn = dependency.lambda-json-to-postgres-loader.outputs.lambda_arn
      filter_prefix = "good-stream-enriched/2020/"
      events = [
        "s3:ObjectCreated:*"]
    }
  ]
}
