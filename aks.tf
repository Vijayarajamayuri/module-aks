# aks-module
data "azurerm resource _group" "g" {
#force this module to wait for rg to be created
    depends_on = [var.resource_group_id]
    name= var. resource_group_name

data "azurerm_private_dns_zone" "K8s_dns_zone" {
    provider = azurerm. hub
    name = var. aks_privatelink_dns_zone_name
    resource_group_name = var.rg.name
}    

re# aks-module
data "azurerm resource _group" "rg" {
#force this module to wait for rg to be created
    depends_on = [var.resource_group_id]
    name= var. resource_group_name

data "azurerm_private_dns_zone" "K8s_dns_zone" {
    provider = azurerm. hub
    name = var. aks_privatelink_dns_zone_name
    resource_group_name = var.rg.name
}    

resource "azurerm_kubernetes_cluster" "K8s" {
    name = var. aks_name
    location= var. azure_location
    resource_group_name = data.azurerm_resource_group. rg. name
    dns_prefix= var.aks_dns_prefix
    node_resource_group = var.aks_node_resource_group_name
    kubernetes_version = var.aks_version

    default_node_pool {
        name == "default" 
        node_count= var.aks_node_count
        vm_size= var.aks_node_sku
        vnet_subnet_id= var.aks_vnet_subnet_id
        max_pods= var.aks_max_pods
        enable_node_public_ip = "false"
        availability _zones = ["1", "2","3"]
    }
    service principal {
        client_id = var.aks_client_id
        client_secret = var.aks_client_secret
    }
    network_profile {
         load balancer_sku =   "Standard"
        network_plugin = "azure"
        network_policy= "azure"
        dns_service_ip = var.aks_dns_service_ip
        docker_bridge_cidr = var.aks_docker_bridge_cidr
        service_cidr = = var.aks_service_cidr
        outbound type = "userDefinedRouting"

    }
    
    role_based_access_control {
        enabled = "true"
        azure_active_directory {
          managed = "true"
        }
   }
    addon_profile {
        oms_agent {
          enabled= "true"
          log_analytics_workspace_id = var.aks_law_id
        }
    }

 
    private_cluster_enabled = "true"
    private_dns_zone_id= data.azurerm_private_dns_zone.k8s_dns_zone.id
    tags = var.tags
  

 data "azurerm_monitor_diagnostic_categories" "aks_categories" {
    resource_id = azurerm_kubernetes_cluster.k8s.id
 }

 output "k8s_id" {
   value       = azurerm_kubernetes_cluster.id
   sensitive   = true
   description = "description"
   depends_on  = []
 }
 source "azurerm_kubernetes_cluster" "K8s" {
    name = var. aks_name
    location= var. azure_location
    resource_group_name = data.azurerm_resource_group. rg. name
    dns_prefix= var.aks_dns_prefix
    node_resource_group = var.aks_node_resource_group_name
    kubernetes_version = var.aks_version
    default_node_pool {
    name == "default" 
    node_count= var.aks_node_count
