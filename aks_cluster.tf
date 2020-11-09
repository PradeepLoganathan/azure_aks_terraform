resource "azurerm_kubernetes_cluster" "aks_cluster" {
    name                            = "${var.resource_prefix}-cluster"
    location                        = azurerm_resource_group.aks_res_grp.location
    resource_group_name             = azurerm_resource_group.aks_res_grp.name
    dns_prefix                      = "${var.resource_prefix}-akscluster"
    kubernetes_version              = var.kubernetes_version
    private_cluster_enabled         = false
    sku_tier                        = var.sku_tier

    #create system node pool
    default_node_pool {
        name                 = "system"
        orchestrator_version = var.kubernetes_version
        vm_size              = var.system_node_pool_vm_size
        os_disk_size_gb      = var.system_node_pool_os_disk_size
        node_count           = var.system_node_pool_node_count
        max_pods             = var.max_pods_per_node
    }

    role_based_access_control {
        enabled = true

        azure_active_directory {
         managed = true
        }
    }

    identity {
    type = "SystemAssigned"
    }

    addon_profile {
        # PREVIEWFEATURE: AzurePolicy
        azure_policy {
        enabled = true
        }

        kube_dashboard {
        enabled = false
        }

        oms_agent {
        enabled                    = true
        log_analytics_workspace_id = var.log_analytics_workspace_resource_id
        }
    }
}

resource "azurerm_kubernetes_cluster_node_pool" "aks_cluster_user_pool" {
        name                    = "user"
        mode                    = "User"
        orchestrator_version    = var.kubernetes_version
        kubernetes_cluster_id   = azurerm_kubernetes_cluster.aks_cluster.id
        enable_auto_scaling     = true
        vm_size                 = var.user_node_pool_vm_size
        os_disk_size_gb         = var.user_node_pool_os_disk_size
        min_count               = var.user_node_pool_min_count
        max_count               = var.user_node_pool_max_count
        max_pods                = var.max_pods_per_node
}