#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# -
# - Required Terraform providers & versions
# -
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">=3.1.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.7.2"
    }
  }
}
