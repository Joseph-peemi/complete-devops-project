terraform {
  backend "s3" {
    bucket = "complete-devops-project-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_endpoint = "complete-project-key"
  }
}