provider "azurerm" {
    subscription_id = var.subscription_id
    features {}
}

resource "azurerm_resource_group" "rg" {
    name = "rg-${var.project}-${var.environment}"
    location = var.location
    tags = var.tags
}

resource "azurerm_key_vault" "keyvault" {
    name = var.key_vault_name
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
    tenant_id = var.tenant_id
    sku_name = "standard"
}


resource "azurerm_mssql_server" "sqlserver" {
    name = "dbsv-${ lower(var.project) }-${ var.environment }"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    version = "12.0"
    administrator_login = var.admin_sql_user
    administrator_login_password = var.admin_sql_password
    tags = var.tags
}

resource "azurerm_mssql_database" "db" {
    name = "${var.project}"
    server_id = azurerm_mssql_server.sqlserver.id
    sku_name = "S0"
    tags = var.tags
}


resource "azurerm_storage_account" "datalake" {
    name = "lake${lower(var.project)}"
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
    account_tier = "Standard"
    account_kind = "StorageV2"
    is_hns_enabled = true
    account_replication_type = "GRS"
    access_tier = "Hot"
    tags = var.tags
}

resource "azurerm_storage_data_lake_gen2_filesystem" "bronze" {
    name = "bronze"
    storage_account_id = azurerm_storage_account.datalake.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "silver" {
    name = "silver"
    storage_account_id = azurerm_storage_account.datalake.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "gold" {
    name = "gold"
    storage_account_id = azurerm_storage_account.datalake.id
}

resource "azurerm_data_factory" "factory" {
    name = "factory-${lower(var.project)}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
}

resource "azurerm_databricks_workspace" "databricks" {
    name = "databricks-${lower(var.project)}-${var.environment}"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
    sku = "standard"
}

