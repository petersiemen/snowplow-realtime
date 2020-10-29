include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

terraform {
  //source = "git::git@github.com:foo/modules.git//frontend-app?ref=v0.0.3"
  source = "../../../../snowplow-starter-aws/snowplow-realtime/snowplow/kinesis//"
}

dependency "s3" {
  config_path = "../../foundation/s3"
}

dependency "lambda-tsv-to-json-transformer" {
  config_path = "../4-storage/lambda-tsv-to-json-transformer"

  mock_outputs_allowed_terraform_commands = [
    "destroy"]
  mock_outputs = {
    lambda_arn = "fake-lambda_arn"
  }
}

inputs = {
  snowplow_bucket_arn = dependency.s3.outputs.tracking_arn
  lambda_tsv_to_json_transformer_arn = dependency.lambda-tsv-to-json-transformer.outputs.lambda_arn
  account_id = local.common.inputs.production_account_id
  region = local.common.inputs.aws_region
}
