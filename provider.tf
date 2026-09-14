terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.68"
    }
  }

  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {}

  subscription_id = "YOUR-SUBSCRIPTION-ID"
}