inputs = {
  region = "eu-central-1"
  amazon_linux_2_ami = "ami-076431be05aaf8080"
  amazon_linux_2_ecs_ami = "ami-0d2e4df42e13655e0"

  master_account_id = get_env("TF_master_account_id")
  production_account_id = get_env("TF_production_account_id")

  dns_zone_id = get_env("TF_dns_zone_id")
  domain = get_env("TF_domain")
  vpc_id = get_env("TF_vpc_id")
  subnet_ids = get_env("TF_subnet_ids")
  public_key = get_env("TF_public_key")

}
