# AWS VPC Module for terraform

A lightweight VPC module for terraform.

## Usage

```hcl

module "vpc" {
  source = "github.com/rnesbit/tf_simple_vpc?ref=v0.3"

  environment = "${var.environment}"

  region = "${var.region}"
  cidr = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support = "${var.enable_dns_support}"

  az = "${var.az}"

  public_subnet = "${var.public_subnet}"
  private_subnet ="${var.private_subnet}"

  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

  # bastion host

  bastion_ami = "${var.bastion_ami}"
  bastion_instance_type = "${var.bastion_instance_type}"
  key_name = "${var.key_name}"

  # terraform host

  terraform_ami = "${var.terraform_ami}"
  terraform_instance_type = "${var.terraform_instance_type}"
  key_name = "${var.key_name}"

  # spinnaker host

  spinnaker_ami = "${var.spinnaker_ami}"
  spinnaker_instance_type = "${var.spinnaker_instance_type}"
  key_name = "${var.key_name}"

  # jenkins host

  jenkins_ami = "${var.jenkins_ami}"
  jenkins_instance_type = "${var.jenkins_instance_type}"
  key_name = "${var.key_name}"

}

```

See `interface.tf` for additional configurable variables.

## License

MIT
