# Data block to fetch the most recent Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu) AMI owner ID

  # Filters AMIs by name pattern for Ubuntu 20.04 LTS
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  # Filters AMIs that use EBS as the root device type
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  # Filters AMIs that use hardware virtualization
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data block to fetch all available AWS availability zones
data "aws_availability_zones" "available" {}