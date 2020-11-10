resource "azurerm_kubernetes_cluster" "aks_cluster" {
    name                            = "${var.resource_prefix}-cluster"
    location                        = azurerm_resource_group.aks_res_grp.location
    resource_group_name             = azurerm_resource_group.aks_res_grp.name
    dns_prefix                      = "${var.resource_prefix}-akscluster"
    kubernetes_version              = var.kubernetes_version
    node_resource_group             = "${var.resource_prefix}-worker"
    private_cluster_enabled         = false
    sku_tier                        = var.sku_tier

    network_profile {
        network_plugin     = "azure"
        network_policy     = "azure"
        service_cidr       = var.service_cidr
        dns_service_ip     = var.dns_service_ip
        docker_bridge_cidr = var.docker_cidr
        outbound_type      = "userDefinedRouting"
    }

    #create system node pool
    default_node_pool {
        name                  = substr(var.system_node_pool.name, 0, 12)
        orchestrator_version  = var.kubernetes_version
        node_count            = var.system_node_pool.node_count
        vm_size               = var.system_node_pool.vm_size
        type                  = "VirtualMachineScaleSets"
        availability_zones    = var.system_node_pool.zones
        max_pods              = 250
        os_disk_size_gb       = 128
        node_labels           = var.system_node_pool.labels
        node_taints           = var.system_node_pool.taints
        enable_auto_scaling   = var.system_node_pool.cluster_auto_scaling
        min_count             = var.system_node_pool.cluster_auto_scaling_min_count
        max_count             = var.system_node_pool.cluster_auto_scaling_max_count
        enable_node_public_ip = false
        #advanced networking
        vnet_subnet_id        = azurerm_subnet.aks_subnet.id
    }

    network_profile {
        network_plugin     = "azure"
        network_policy     = "azure"
        service_cidr       = var.service_cidr
        dns_service_ip     = var.dns_service_ip
        docker_bridge_cidr = var.docker_cidr
        outbound_type      = "userDefinedRouting"
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