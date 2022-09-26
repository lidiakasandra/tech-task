terraform {
  required_providers {
    azurerm = {
        source  = "hashicorp/azurerm"
        version = "=2.48.0"
    }
  }
}

# First, the cluster in AKS
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "rg" {
  name     = "app-rg"
  location = "westeurope"
}

resource "azurerm_container_registry" "registry" {
  depends_on          = [azurerm_resource_group.rg]
  name                = "lipudemoregistry"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false
}
resource "azurerm_kubernetes_cluster" "cluster" {
  depends_on          = [azurerm_resource_group.rg]
  name                = "app-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "app"

  default_node_pool {
    name       = "default"
    node_count = "1"
    vm_size    = "standard_d2_v2"
  }
  identity {
    type = "SystemAssigned"
  }
}
resource "local_file" "kubeconfig" {
  depends_on   = [azurerm_kubernetes_cluster.cluster]
  filename     = "kubeconfig"
  content      = azurerm_kubernetes_cluster.cluster.kube_config_raw
}
resource "null_resource" "ex1" {
    depends_on   = [local_file.kubeconfig]
    provisioner "local-exec" {
    command = "cp kubeconfig ~/.kube/config"
    }
}
resource "null_resource" "ex2" {
    depends_on   = [null_resource.ex1]
    provisioner "local-exec" {
    command = "docker build -t lipudemoregistry.azurecr.io/100jokes:latest . && docker push lipudemoregistry.azurecr.io/100jokes && helm template chart --output-dir deploy/base && kubectl applyhelm template chart --output-dir deploy/base && kubectl create -k deploy/production -k deploy/production"
    }
}





