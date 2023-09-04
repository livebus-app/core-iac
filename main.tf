terraform {
  backend "s3" {
    bucket = "livebus-terraform-state-v2"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    awscc = {
      source = "hashicorp/awscc"
    }
  }
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
  source = "./modules/stream"
  dynamodb-stream-table-name = module.database.label-analysis-db-name
}

module "compute" {
  source = "./modules/compute"
}

module "pipeline" {
  source = "./modules/pipeline"
  lbl_dynamodb_insertion_stream_arn = module.stream.lbl_dynamodb_insertion_stream_arn
  enrichment_lambda_arn = module.compute.label_digest_lambda_arn
  target_resource_arn = module.compute.put_rds_lambda_arn
}