resource "random_id" "log_analytics_workspace_name_suffix" {
    byte_length = 8
}


resource "azurerm_log_analytics_workspace" "insights" {
  name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix}"
  location            = azurerm_resource_group.aks_res_grp.location
  resource_group_name = azurerm_resource_group.aks_res_grp.name
  retention_in_days   = 30

   lifecycle {
        ignore_changes = [
            name,
        ]
    }
}