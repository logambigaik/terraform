variable "region" {
  default = "us-west-2"
}

variable "aws_access_key" {
  description = "aws access key"
  default = ""
}

variable "aws_secret_key" {
  description = "aws secret key"
  default = ""
}

variable "key_name" {
  default = "aws"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "amis" {
  type = "map"

  default = {
    us-west-2 = "ami-0d6621c01e8c2de2c"
  }
}


variable "kafka_instance_type" {
  default = "t2.small"
}

variable "kafka_cluster_size" {
  default = "2"
}

variable "project" {
  default = "kafka"
}
