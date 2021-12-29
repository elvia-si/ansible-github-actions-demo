provider "aws" {
  region = "eu-west-1"
}

module "network" {
  source = "github.com/pasc-ed/talent-academy-vpc-module"

  vpc_cidr         = var.vpc_cidr
  region           = var.region
  vpc_name         = var.vpc_name
  internet_gw_name = var.internet_gw_name
  public_a_cidr    = var.public_a_cidr
  public_b_cidr    = var.public_b_cidr
  public_c_cidr    = var.public_c_cidr
  private_a_cidr   = var.private_a_cidr
}



resource "aws_security_group" "my_app_sg" {
  name        = "my_app_sg"
  description = "Allow access to my Server"
  vpc_id      = module.network.my_vpc_id

  # INBOUND RULES
  ingress {
    description = "SSH from my mac"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["158.181.77.181/32"]
  }

  ingress {
    description = "SSH from my VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }

   ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow access to the world"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_app_sg"
  }
}

data "aws_ami" "my_aws_ami" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }
}

resource "aws_instance" "my_public_server" {
  ami                    = data.aws_ami.my_aws_ami.id
  instance_type          = var.instance_type
  key_name               = var.keypair_name
  subnet_id              = module.network.public_subnet_a_id
  vpc_security_group_ids = [aws_security_group.my_app_sg.id]
}
