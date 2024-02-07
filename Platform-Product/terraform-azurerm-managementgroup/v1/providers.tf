#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#


# -
# - Required Terraform providers and version
# -
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.90.0"
    }
  }
}
