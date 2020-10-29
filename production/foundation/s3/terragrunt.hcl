include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

terraform {
  //source = "git::git@github.com:foo/modules.git//frontend-app?ref=v0.0.3"
  source = "../../../../snowplow-starter-aws/snowplow-realtime/foundation/s3//"
}

inputs = {
  bucket_name = local.common.inputs.bucket_name
  artifacts_bucket_name = local.common.inputs.artifacts_bucket_name

  vpc_id = local.common.inputs.vpc_id
  route_table_id = local.common.inputs.route_table_id
  region = local.common.inputs.aws_region
}
