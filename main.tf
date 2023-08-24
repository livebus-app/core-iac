terraform {
  backend "s3" {
    bucket = "livebus-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./modules/network"
}

module "database" {
  source               = "./modules/database"
  pg-subnet-group-name = module.network.pg-subnet-group-name
  pg-security-group-id = module.network.pg-security-group-id
}

module "stream" {
  source          = "./modules/stream"
}

module "compute" {
  source = "./modules/compute"
}
