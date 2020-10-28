include {
  path = find_in_parent_folders()
}

locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

terraform {
  //source = "git::git@github.com:foo/modules.git//frontend-app?ref=v0.0.3"
  source = "../../../../snowplow-starter-ecs/snowplow-ecs/rds//"
}


inputs = {
  vpc_id = local.common.inputs.vpc_id
  vpc_public_subnets = local.common.inputs.subnet_ids
  instance_class = "db.t3.micro"
  name = "snowplow"
  db_user = "snowplow"
  db_pass = "ein0Ciebaex9"
  db_name = "snowplow"
  publicly_accessible = true
}
