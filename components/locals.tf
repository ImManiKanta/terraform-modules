locals {
  ami_id = data.aws_ami.joindevops.id
  private_subnet_id = split("," , data.aws_ssm_parameter.private_subnet_id.value)[0]
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  backend_alb_listener_arn = data.aws_ssm_parameter.backend_alb_listener_arn.value
  sg_id = data.aws_ssm_parameter.sg_id.value
  port_number = var.component == "frontend" ? 80 : 8080
  health_check_path = var.component == "frontend" ? "/" : "/health"
  host_header = var.component == "frontend" ? "${var.component}-${var.environment}.${var.domain_name}" : "${var.component}.backend-alb-${var.environment}.${var.domain_name}"
  common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = "true"
    }
}