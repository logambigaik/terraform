variable "aws_region" {
 type = "string"
 description = "Used AWS Region."
 default = "us-east-1"
}
variable "aws_access_key" {
 type = "string"
 description = "The account identification key used by your Terraform client."
 default = ""
}
variable "aws_secret_key" {
 type = "string"
 description = "The secret key used by your terraform client to access AWS."
 default = ""
}

variable "subnet_count" {
  type        = "string"
  description = "The number of subnets we want to create per type to ensure high availability."
  default = "3"  
}

variable "accessing_computer_ip" {
 type = "string"
 description = "IP of the computer to be allowed to connect to EKS master and nodes."
 default = ""
}

variable "keypair-name" {
  type = "string"
  description = "Name of the keypair declared in AWS IAM, used to connect into your instances via SSH."
  default = "aws"
}
