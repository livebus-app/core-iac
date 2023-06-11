terraform {
  backend "s3" {
    bucket = "livebus-terraform-state-2023"
    key    = "terraform.tfstate"
    region = "us-east-1" 
  }
}

module "network" {
  source = "./modules/network"
}

module "database" {
  source                = "./modules/database"
  rds-subnet-group-name = module.network.rds-subnet-group-name
  rds-security-group-id = module.network.rds-security-group-id
  object-digest-lambda-arn = module.compute.object-digest-lambda-arn
}

module "compute" {
  source = "./modules/compute"
}