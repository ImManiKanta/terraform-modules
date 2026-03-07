locals {
    common_tags = {
        Projects = var.project
        Environment = var.environment
        Terraform = "true"
    }

}