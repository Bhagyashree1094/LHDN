#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

output "id" {
  description = "Resource Id of AKS cluster"
  value       = azurerm_kubernetes_cluster.this.id
}

output "fqdn" {
  description = "The FQDN of the Azure Kubernetes Managed Cluster."
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "private_fqdn" {
  description = "The FQDN for the Azure Portal resources when private link has been enabled, which is only resolvable inside the Virtual Network used by the Kubernetes Cluster."
  value       = azurerm_kubernetes_cluster.this.private_fqdn
}

output "node_resource_group" {
  description = "The Resource Group that contains the Managed resources by the AKS service these should not be altered directly)."
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}
