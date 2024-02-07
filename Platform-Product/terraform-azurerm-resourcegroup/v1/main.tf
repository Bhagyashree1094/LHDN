module "lhdn_rg_name" {
  # Local uses the module from the relative path
   source = "../../terraform-azurerm-module/v1"

  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = var.iterator
  # au              = var.au
  owner           = var.owner
  bu              = var.bu
  app_code        = var.app_code
  # product_version = var.product_version

  # Resource Group specifics settings
  resource_type_code  = "rg"
  max_length          = 90
  no_dashes           = false
  add_random          = var.add_random
  rnd_length          = var.rnd_length
}

# -
# - Create the Resource Group
# -
resource "azurerm_resource_group" "this" {
  name     = module.lhdn_rg_name.name
  location = module.lhdn_rg_name.location

  tags = merge(module.lhdn_rg_name.tags, var.additional_tags)
}
