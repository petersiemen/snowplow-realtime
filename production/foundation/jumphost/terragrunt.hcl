include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

terraform {
  //source = "git::git@github.com:foo/modules.git//frontend-app?ref=v0.0.3"
  source = "../../../../snowplow-starter-ecs/snowplow-ecs/jumphost//"
}

dependency "admin" {
  config_path = "../admin"
}


inputs = {
  ami_id = local.common.inputs.amazon_linux_2_ami
  key_name = dependency.admin.outputs.key_name
}
