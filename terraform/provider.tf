
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.42"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.99"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "hcloud" {}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "aws" {
  region = try(var.region["aws"], "eu-central-1")
}
