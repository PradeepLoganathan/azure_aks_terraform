resource "azurerm_kubernetes_cluster" "aks_cluster" {
    name                            = "${var.resource_prefix}-cluster"
    location                        = azurerm_resource_group.aks_res_grp.location
    resource_group_name             = azurerm_resource_group.aks_res_grp.name
    dns_prefix                      = "${var.resource_prefix}-akscluster"
    kubernetes_version              = var.kubernetes_version
    node_resource_group             = "${var.resource_prefix}-worker"
    private_cluster_enabled         = false
    sku_tier                        = var.sku_tier
    
    lifecycle {
        ignore_changes = [
        default_node_pool[0].node_count
        ]
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
        
        enable_auto_scaling   = var.system_node_pool.cluster_auto_scaling
        min_count             = var.system_node_pool.cluster_auto_scaling_min_count
        max_count             = var.system_node_pool.cluster_auto_scaling_max_count
        enable_node_public_ip = false
        #advanced networking
        vnet_subnet_id        = azurerm_subnet.aks_subnet.id
    }

    network_profile {
        # Using azure-cni for advanced networking
        network_plugin     = "azure"
        # The network policy to be used with Azure CNI.
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
        enabled = var.addons.azure_policy
        }

        # kube_dashboard {
        # enabled = var.addons.kubernetes_dashboard
        # }

        oms_agent {
        enabled                    = var.addons.oms_agent
        log_analytics_workspace_id = azurerm_log_analytics_workspace.clusterinsightsworkspace.id
        }
    }
}

resource "azurerm_kubernetes_cluster_node_pool" "aks_cluster_user_pool" {
    
    lifecycle {
    ignore_changes = [
      node_count
    ]
  }
    
  for_each = var.additional_node_pools
    
    kubernetes_cluster_id   = azurerm_kubernetes_cluster.aks_cluster.id
    name                    = each.value.node_os == "Windows" ? substr(each.key, 0, 6) : substr(each.key, 0, 12)
    orchestrator_version    = var.kubernetes_version
    mode                    = "User"
    node_count              = each.value.node_count
    vm_size                 = each.value.vm_size
    availability_zones      = each.value.zones
    enable_auto_scaling     = each.value.cluster_auto_scaling 
    
    os_type                 = each.value.node_os
    min_count               = each.value.cluster_auto_scaling_min_count
    max_count               = each.value.cluster_auto_scaling_max_count
    max_pods                = var.max_pods_per_node
    
    node_taints             = each.value.taints
}
