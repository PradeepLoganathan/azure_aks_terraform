output "cluster_id" {
  value       = azurerm_kubernetes_cluster.aks_cluster.id
  description = "Resource ID of the Kubernetes Cluster"
}

output "host" {
  value       = azurerm_kubernetes_cluster.aks_cluster.kube_admin_config[0].host
  description = "The Kubernetes cluster server host"
}

output "client_certificate" {
  value       = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_admin_config[0].client_certificate)
  sensitive   = true
  description = "Public certificate used by clients to authenticate to the Kubernetes cluster"
}

output "client_key" {
  value       = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_admin_config[0].client_key)
  sensitive   = true
  description = "Private key used by clients to authenticate to the Kubernetes cluster"
}

output "cluster_ca_certificate" {
  value       = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_admin_config[0].cluster_ca_certificate)
  sensitive   = true
  description = "Public CA certificate used as the root of trust for the Kubernetes cluster"
}

output "cluster_resource_group_name" {
  value       = azurerm_resource_group.aks_res_grp.name
  description = "Resource Group Name"
}

output "cluster_name" {
  value       = azurerm_kubernetes_cluster.aks_cluster.name
  description = "Name of the Kubernetes Cluster"
}

output "cluster_kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  description = "config for the Kubernetes Cluster"
}
