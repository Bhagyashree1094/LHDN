#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# ----------------------------------
# - Required Terraform declarations
# ----------------------------------
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.50.0"
    }
  }
}