output "vm_private_ips" {
  value       = { for k, v in azurerm_network_interface.nic : k => v.private_ip_address }
  description = "Private IP addresses for created VMs"
}