locals {
  ami_id = data.aws_ami.joindevops.id
  private_subnet_id = split("," , data.aws_ssm_parameter.private_subnet_id.value)[0]
  catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  backend_alb_listener_arn = data.aws_ssm_parameter.backend_alb_listener_arn.value
  sg_id = data.aws_ssm_parameter.sg_id.value
  common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = "true"
    }
}