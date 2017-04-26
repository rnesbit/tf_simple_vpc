# AWS VPC Module for terraform

A lightweight VPC module for terraform.

## Usage

```hcl

module "vpc" {
  source = "github.com/rnesbit/tf_simple_vpc"

  environment = "vpc_name"

  region = "region_name"
  cidr = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"

  az = "az_name"

  public_subnet = "10.0.0.0/24"
  private_subnet = "10.0.1.0/24"

  map_public_ip_on_launch = "true"

  # bastion hosts

  bastion_ami = "ami-9e247efe"
  bastion_instance_type = "t2.micro"
  key_name = "key_name"
}

```

See `interface.tf` for additional configurable variables.

## License

MIT
