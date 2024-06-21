//Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47.0"
    }
  }
  backend "s3" {
    bucket         	   = "book-store-terraform-state-bucket"
    key              	   = "state/terraform.tfstate"
    region         	   = "us-east-1"
    encrypt = true
    dynamodb_table = "bookstore_tf_lockid"
  }
}

provider "aws" {
  //Set the AWS region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}