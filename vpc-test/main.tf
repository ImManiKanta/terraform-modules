module "vpc" {
    source = "git::https://github.com/ImManiKanta/terraform-modules.git//vpc?ref=main" #subfolder "vpc" and main branch
    project = var.project
    environment = var.environment
}
#https://github.com/ImManiKanta/terraform-modules.git?ref=main