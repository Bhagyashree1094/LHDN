#
# Copyright 2023 lhdn & Microsoft. All rights reserved.
#
# -
# - Generate randomization (if asked)
# -
resource "random_id" "this" {
  count       = var.add_random == true ? 1 : 0
  byte_length = 3
}

# -
# - Generate Timestamp for the date created_on
# -
resource "time_static" "this" {}


locals {
  # -
  # - Generate the Azure Location name
  # -
  location_names = {
    "sea" = "Southeast Asia",
    "ea" = "East Asia"
  }

  # -
  # - Generate name separator (dash or no dash)
  # -
  separator = var.no_dashes == true ? "" : "-"

  # -
  # - Generate Random suffix (Defaults: number type, 3 digits, 0 padding)
  # -
  random_suffix = var.add_random == true ? format("%0${var.rnd_length}s", substr(random_id.this[0].dec, 0, var.rnd_length)) : ""

  # -
  # - Cascade that generates the Resource name
  # -
  
  # Build mandatory prefix
  resource_name_pref1 = upper(join(local.separator, [var.region_code, var.env, var.app_code, var.resource_type_code]))
  
  # Add base name, if any
  resource_name_pref2 = var.base_name != null && var.base_name != "" ? join(local.separator, [local.resource_name_pref1, var.base_name]) : local.resource_name_pref1

  # Add additional name, if any
  resource_name_pref3 = var.additional_name != null && var.additional_name != "" ? join(local.separator, [local.resource_name_pref2, var.additional_name]) : local.resource_name_pref2

  # Add iterator, if any
  resource_name_pref4 = var.iterator != null && var.iterator != "" ? join(local.separator, [local.resource_name_pref3, var.iterator]) : local.resource_name_pref3

  # Ensure remove dashes (some may come from witihn the variables' values)
  resource_name_pref5 = var.no_dashes == true ? replace(local.resource_name_pref4, "-", "") : local.resource_name_pref4

  # Trim to max length and generate completed resource name
  resource_name_pref6 = upper(length(local.resource_name_pref5) > var.max_length ? substr(local.resource_name_pref5, 0, var.max_length) : local.resource_name_pref5)


  # If selected, add the random id at the end by replacing the var.rnd_length last characters of the name
  resource_name = upper(var.add_random == true ? "${substr(local.resource_name_pref5, 0, (var.max_length - (var.rnd_length + length(local.separator))))}${local.separator}${local.random_suffix}" : local.resource_name_pref5)
 
  # -
  # - Generate Common tags
  # -
  generated_tags = {
    created_on  = formatdate("YYYY-MM-DD hh:mm ZZZ", time_static.this.rfc3339)
    # au          = var.au
    # owner       = var.owner
    # environment = var.env
    # org         = var.org
    # country     = var.country
    bu             = var.bu
    # costcenter      = var.bu
    # product_version = var.product_version
    # criticality    = var.criticality
  }
  # Add additional_tags
  base_tags = merge(local.generated_tags, var.additional_tags)
}
