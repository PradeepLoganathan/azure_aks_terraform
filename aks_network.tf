resource "azurerm_virtual_network" "aks_vnet" {
    name                = "${var.resource_prefix}-vnet"
    location            = azurerm_resource_group.aks_res_grp.location
    resource_group_name = azurerm_resource_group.aks_res_grp.name
    address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "aks_subnet" {
    name                = "${var.resource_prefix}-subnet"
    resource_group_name = azurerm_resource_group.aks_res_grp.name
    virtual_network_name= azurerm_virtual_network.aks_vnet.name
    address_prefixes    = ["10.1.0.0/24"]
}