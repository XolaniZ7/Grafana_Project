variable "vpc_cidr" {
  description = "VPC cidr"
  type        = string
}

variable "public_subnets" {
  description = "subnet cidr"
  type        = list(string)

}

variable "instance_type" {
  description = "Instance Type"
  type        = string
}