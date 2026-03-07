locals {
    common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = "true"
    }
    ig_final_tags = merge(
        local.common_tags,
        {
        Name = "${var.project}-${var.environment}"
        },
        var.igw_tags
    )
    az_names = slice(data.aws_availability_zones.available.name, 0,2)
}