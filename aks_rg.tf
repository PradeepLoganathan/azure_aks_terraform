resource "azurerm_resource_group" "aks_res_grp" {
    name        = "${var.resource_prefix}-rg"
    location    = var.location
}