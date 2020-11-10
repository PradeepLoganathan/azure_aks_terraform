variable "resource_prefix" {
  type        = string
  description = "(Required) Prefix given to all resources within the module."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "kubernetes_version" {
  type        = string
  default     = "1.16.8"
  description = "Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade)."
}

variable "tags" {
  type        = map
  default     = {}
  description = "Set of base tags that will be associated with each supported resource."
}

variable "log_analytics_workspace_resource_id" {
  type        = string
  description = "(Required) Resource ID of the Log Analytics workspace for storing Azure Monitor metrics"
}

variable "max_pods_per_node" {
  type        = string
  default     = "30"
  description = "The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
}

#system node pool settings

variable "system_node_pool" {
  description = "The object to configure the default system node pool with number of worker nodes, worker node VM size and Availability Zones."
  type = object({
    name                           = string
    node_count                     = number 
    vm_size                        = string
    zones                          = list(string)
    labels                         = map(string)
    taints                         = list(string)
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
  })

  default = {
      node_count                        = 2
      vm_size                           = "Standard_D2s_v3"
      cluster_auto_scaling_min_count    = 3
      cluster_auto_scaling_max_count    = 5
      cluster_auto_scaling              = true
      labels                            = {}
      name                              = "system-node-pool"
      taints                            = ["CriticalAddonsOnly=true:NoSchedule"]
      zones                             = ["1", "2"]
  }
}

variable log_analytics_workspace_name {
    description = "The name of the Log Analytics workspace."
    default     = "aksmonitor"
}

#user node pool settings
variable "user_node_pool_min_count" {
  type        = string
  default     = 3
  description = "Minimum number of nodes for auto-scaling"
}

variable "user_node_pool_max_count" {
  type        = string
  default     = 5
  description = "Maximum number of nodes for auto-scaling"
}

variable "user_node_pool_vm_size" {
  type        = string
  default     = "Standard_D2s_v3"
  description = "The size of each VM in the Agent Pool (e.g. Standard_F1). Changing this forces a new resource to be created."
}

variable "user_node_pool_os_disk_size" {
  type        = string
  default     = "120"
  description = "The Agent Operating System disk size in GB. Changing this forces a new resource to be created."
}

variable "sku_tier" {
  type        = string
  default     = "Free"
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA)"
}

variable "vnet_subnet_id" {
  description = "Resource id of the Virtual Network subnet"
  type        = string
}

variable "service_cidr" {
  type        = string
  default     = "100.64.0.0/16"
  description = "The Network Range used by the Kubernetes service. This range should not be used by any network element on or connected to this virtual network. Service address CIDR must be smaller than /12."
}

variable "dns_service_ip" {
  type        = string
  default     = "100.64.0.10"
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Don't use the first IP address in your address range, such as .1. The first address in your subnet range is used for the kubernetes.default.svc.cluster.local address. Changing this forces a new resource to be created."
}

variable "docker_cidr" {
  type        = string
  default     = "100.65.0.1/16"
  description = "IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created."
}

