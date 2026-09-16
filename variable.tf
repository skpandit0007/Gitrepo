variable "location" {
  type        = string
  default     = "East US"
  description = "Azure region for resource deployment"
}

variable "resource_group_name" {
  type        = string
  default     = "rg-devops-assignment"
  description = "Resource Group Name"
}

variable "vnet_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Virtual Network CIDR block"
}

variable "subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "Subnet CIDR block"
}

# The Map of Objects requirement
variable "virtual_machines" {
  type = map(object({
    vm_size        = string
    disk_size_gb   = number
    admin_username = string
    admin_password = string
    os_offer       = string
    os_sku         = string
  }))
  description = "Map of Virtual Machine configurations"
}