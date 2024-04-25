# указываем версию терраформа
terraform {
  required_version = "1.8.1" 

  # указываем, что нам требуется aws provider 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0" 
    }
  }

# в настройках бекенда нельзя использовать переменные
 # поэтому тут хардкод

  backend "s3" {
    bucket         = "awesome-tf-remote-state"
    key            = "terraform.tfstate"     
    region         = "us-east-1"
    dynamodb_table = "awesome-terraform-lock"
  }
}

# провайдер
provider "aws" {
  region     = var.aws_region
}