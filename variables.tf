variable "subscription_id" {
    type = string
    description = "The Azure subscription ID"
}

variable "project" {
    type = string
    description = "The name of the current project"
}

variable "environment" {
    type = string
    description = "The current environment of the project"
}

variable "location" {
    type = string
    description = "The Azure Region to deploy a specific resource"
    # default = "East US"
}
variable "tags" {
    type = map(string)
    description = "A map of strings to apply to all resources"
    default = {
        environment = "production"
        date = "nov-2025"
        createdBy= "Terraform"
    }
}

variable "admin_sql_user" {
    type = string
    description = "Value of the SQL server admin user"
}

variable "admin_sql_password" {
    type = string
    description = "Value of the SQL server admin password"
}

variable "key_vault_name" {
    type = string
    description = "Name for the Azure Key Vault"
}

variable "tenant_id" {
    type = string
    description = "Tenant id"
}
