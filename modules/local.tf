locals {
    ami_id = data.aws_ami.joindevops.id
    instance_type = "t3.small"
    environment = "dev"
}