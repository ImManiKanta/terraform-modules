resource "aws_instance" "this" {
  ami = local.ami_id
  instance_type = local.instance_type
  vpc_security_group_ids = var.sg_ids

  tags = {
    Name = "catalogue-${local.environment}"
    Environment = local.environment
  }
}

/* resource "aws_security_group" "allow_all" {
  name        = "allow_all_terraform" #This is for AWS Account
  description = "Allow all inbound traffic and all outbound traffic"

  egress { #outbound
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

   ingress { #inbound
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all_terraform"
  }
} */