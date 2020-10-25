include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

terraform {
  //source = "git::git@github.com:foo/modules.git//frontend-app?ref=v0.0.3"
  source = "../../../snowplow-starter-ecs/snoplow-ecs/kinesis//"
}

dependency "s3" {
  config_path = "../s3"
}

inputs = {
  snowplow_bucket_arn = dependency.s3.outputs.tracking_arn
}
