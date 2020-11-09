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
variable "system_node_pool_node_count" {
  type        = string
  default     = 2
  description = "Number of nodes which exists in system node pool"
}

variable "system_node_pool_vm_size" {
  type        = string
  default     = "Standard_D2s_v3"
  description = "The size of each VM in the Agent Pool (e.g. Standard_F1). Changing this forces a new resource to be created."
}


variable "system_node_pool_os_disk_size" {
  type        = string
  default     = "120"
  description = "The Agent Operating System disk size in GB. Changing this forces a new resource to be created."
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
