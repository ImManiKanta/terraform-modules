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
    public_subnet_final_tags = merge(
                        local.common_tags,
                        {
                        Name = "${var.project}-${var.environment}"
                        },
                        var.public_subnet_tags
                    )

}