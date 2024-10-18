# VPC Module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Grafana-vpc" 
  cidr = var.vpc_cidr  

  azs            = data.aws_availability_zones.available.names 
  public_subnets = var.public_subnets                          

  enable_dns_hostnames = true 

  tags = {
    Name        = "Grafana-vpc" 
    Terraform   = "true"        
    Environment = "dev"        
  }

  public_subnet_tags = {
    Name = "Grafana subnet" 
  }
}

# Security Group for Grafana
module "grafana_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "Grafana-sg"                 
  description = "Security group for Grafana" 
  vpc_id      = module.vpc.vpc_id            

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"      
      cidr_blocks = "0.0.0.0/0" 
    },
    {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      description = "Grafana"   
      cidr_blocks = "0.0.0.0/0" 
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"       
      cidr_blocks = "0.0.0.0/0" 
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"        
      cidr_blocks = "0.0.0.0/0" 
    }
  ]

  tags = {
    Name = "Grafana-sg" 
  }
}

# EC2 Instance for Grafana
module "grafana_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "Grafana-server" 

  ami                         = data.aws_ami.ubuntu.id                         
  instance_type               = var.instance_type                              
  key_name                    = "Grafana-kp"                                   
  monitoring                  = true                                           
  vpc_security_group_ids      = [module.grafana_sg.security_group_id]          
  subnet_id                   = module.vpc.public_subnets[0]                   
  associate_public_ip_address = true                                           
  user_data                   = file("Grafana-install.sh")              
  availability_zone           = data.aws_availability_zones.available.names[0] 

  tags = {
    Name        = "Grafana-server" 
    Terraform   = "true"           
    Environment = "dev"            
  }
}
