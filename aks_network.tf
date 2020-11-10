
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


resource "azurerm_route_table" "aks_route_table" {
  name                = "${azurerm_resource_group.aks_res_grp.name}-routetable"
  location            = azurerm_resource_group.aks_res_grp.location
  resource_group_name = azurerm_resource_group.aks_res_grp.name

  route {
    name                   = "cluster-01"
    address_prefix         = "10.100.0.0/14"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.1.1"
  }
}
resource "azurerm_subnet_route_table_association" "cluster-01" {
  subnet_id      = azurerm_subnet.aks_subnet.id
  route_table_id = azurerm_route_table.aks_route_table.id
}