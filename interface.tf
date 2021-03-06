# tf_simple_vpc/interface.tf

variable "environment" {
  type = "string"
  description = "name of the environment."
}

variable "region" {
  type = "string"
}

variable "cidr" {
  type = "string"
   description = "The CIDR of the VPC."
 }

variable "enable_dns_hostnames" {
   default     = true
   description = "Should be true if you want to use private DNS within the VPC"
}

variable "enable_dns_support" {
   default     = true
   description = "Should be true if you want to use private DNS within the VPC"
}

variable "az" {
  default = "us-west-1a"
  description = "availability zones"
}

variable "public_subnet" {
   default = "10.0.0.0/24"
   description = "the public subnet"
 }

variable "private_subnet" {
   default = "10.0.1.0/24"
   description = "the private subnet"
}

variable "map_public_ip_on_launch" {
  default = true
}

# hosts

variable "key_name" {
  type = "string"
}

#bastion host

variable "bastion_ami" {
  type = "map"
}

variable "bastion_instance_type" {
  type = "string"
}

# terraform host

variable "terraform_ami" {
  type = "map"
}

variable "terraform_instance_type" {
  type = "string"
}

# spinnaker host

variable "spinnaker_ami" {
  type = "map"
}

variable "spinnaker_instance_type" {
  type = "string"
}

# jenkins host

variable "jenkins_ami" {
  type = "map"
}

variable "jenkins_instance_type" {
  type = "string"
}
