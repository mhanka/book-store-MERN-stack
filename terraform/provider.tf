//Configure the AWS Provider
provider "aws" {
  //Set the AWS region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}