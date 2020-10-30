#!/bin/bash

export aws_region="eu-central-1"
export bucket_name="XYZ"
export artifacts_bucket_name="XYZ"

export master_account_id=123456
export master_account_profile=XYZ
export production_account_id=78901234
export production_account_profile=ABC
export shared_services_account_id=56789123
export shared_services_account_profile=DEF

export dns_zone_id=KLMOP
export domain=YOURDOMAIN.COM

export vpc_id="vpc-124567"
export vpc_cidr="172.31.0.0/16"
export subnet_ids='["subnet-123456", "subnet-789123", "subnet-45678"]'
export route_table_id="rtb-xyz"
export public_key="ssh-rsa ABCEFESDFGSDF"

export trusted_ip_address="1.2.3.4"