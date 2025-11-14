output "resource_group" {
    description = "Grupo de recursos de la solucion"
    value = azurerm_resource_group.rg.name
}

output "resource_group_location" {
    description = "Ubicación del grupo de recursos"
    value = azurerm_resource_group.rg.location
}