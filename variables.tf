variable "name" {
  default     = "task_vpc"
  type        = string
  description = "Name of the VPC"
}

variable "region" {
  default     = "ap-southeast-1"
  type        = string
  description = "Mention Region for VPC / default is ap-southeast-1"
}

variable "key_name" {
  type        = string
  description = "Key Pair for Machine/Instance"
}

variable "cidr_block" {
  default     = "10.0.0.0/26"
  type        = string
  description = "VPC - CIDR block"
}

variable "public_subnet_cidr_blocks" {
  default     = ["10.0.0.32/28", "10.0.0.48/28"]
  type        = list
  description = "public subnet CIDR"
}

variable "private_subnet_cidr_blocks" {
  default     = ["10.0.0.0/28", "10.0.0.16/28"]
  type        = list
  description = "private subnet CIDR"
}

variable "availability_zones" {
  default     = ["ap-southeast-1a","ap-southeast-1c"]
  type        = list
  description = "availability zones"
}

variable "ubuntu_ami" {
  type        = string
  description = "Ubuntu Machine AMI ID"
}

variable "ubuntu_instance_type" {
  default     = "t3.nano"
  type        = string
  description = "Instance Type"
}