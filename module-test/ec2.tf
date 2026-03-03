module "ec2" {
   source = "../modules"
   sg_ids = var.sg_ids
}