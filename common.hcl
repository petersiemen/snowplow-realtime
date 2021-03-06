inputs = {
  //  region = get_env("aws_region")
  amazon_linux_2_ami = "ami-076431be05aaf8080"
  amazon_linux_2_ecs_ami = "ami-08c1d0b4f39f110d4"
  aws_region = get_env("aws_region")
  bucket_name = get_env("bucket_name")
  artifacts_bucket_name = get_env("artifacts_bucket_name")

  master_account_id = get_env("master_account_id")
  master_account_profile = get_env("master_account_profile")
  production_account_id = get_env("production_account_id")
  production_account_profile = get_env("production_account_profile")
  shared_services_account_id = get_env("shared_services_account_id")
  shared_services_account_profile = get_env("shared_services_account_profile")

  dns_zone_id = get_env("dns_zone_id")
  domain = get_env("domain")
  vpc_id = get_env("vpc_id")
  vpc_cidr = get_env("vpc_cidr")
  route_table_id = get_env("route_table_id")
  subnet_ids = get_env("subnet_ids")
  public_key = get_env("public_key")
  trusted_ip_address = get_env("trusted_ip_address")


}
