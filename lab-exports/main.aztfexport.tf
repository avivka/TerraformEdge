resource "azurerm_resource_group" "res-0" {
  location = "eastus2"
  name     = "azure-rg"
  tags = {
    LODManaged   = "lod"
    LabInstance  = "51008558"
    LabProfile   = "183286"
    PoolOrgId    = "172"
    ProfileOrgId = "172"
    SeriesId     = "24662"
    TS           = "133910040987772141"
  }
}
resource "azurerm_container_registry" "res-1" {
  location            = "eastus2"
  name                = "acr51008558050725"
  resource_group_name = "azure-rg"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_container_registry_scope_map" "res-2" {
  actions                 = ["repositories/*/metadata/read", "repositories/*/metadata/write", "repositories/*/content/read", "repositories/*/content/write", "repositories/*/content/delete"]
  container_registry_name = "acr51008558050725"
  description             = "Can perform all read, write and delete operations on the registry"
  name                    = "_repositories_admin"
  resource_group_name     = "azure-rg"
  depends_on = [
    azurerm_container_registry.res-1,
  ]
}
resource "azurerm_container_registry_scope_map" "res-3" {
  actions                 = ["repositories/*/content/read"]
  container_registry_name = "acr51008558050725"
  description             = "Can pull any repository of the registry"
  name                    = "_repositories_pull"
  resource_group_name     = "azure-rg"
  depends_on = [
    azurerm_container_registry.res-1,
  ]
}
resource "azurerm_container_registry_scope_map" "res-4" {
  actions                 = ["repositories/*/content/read", "repositories/*/metadata/read"]
  container_registry_name = "acr51008558050725"
  description             = "Can perform all read operations on the registry"
  name                    = "_repositories_pull_metadata_read"
  resource_group_name     = "azure-rg"
  depends_on = [
    azurerm_container_registry.res-1,
  ]
}
resource "azurerm_container_registry_scope_map" "res-5" {
  actions                 = ["repositories/*/content/read", "repositories/*/content/write"]
  container_registry_name = "acr51008558050725"
  description             = "Can push to any repository of the registry"
  name                    = "_repositories_push"
  resource_group_name     = "azure-rg"
  depends_on = [
    azurerm_container_registry.res-1,
  ]
}
resource "azurerm_container_registry_scope_map" "res-6" {
  actions                 = ["repositories/*/metadata/read", "repositories/*/metadata/write", "repositories/*/content/read", "repositories/*/content/write"]
  container_registry_name = "acr51008558050725"
  description             = "Can perform all read and write operations on the registry"
  name                    = "_repositories_push_metadata_write"
  resource_group_name     = "azure-rg"
  depends_on = [
    azurerm_container_registry.res-1,
  ]
}
resource "azurerm_container_registry" "res-7" {
  location            = "eastus2"
  name                = "acr51008558050825"
  resource_group_name = "azure-rg"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_container_registry_scope_map" "res-8" {
  actions                 = ["repositories/*/metadata/read", "repositories/*/metadata/write", "repositories/*/content/read", "repositories/*/content/write", "repositories/*/content/delete"]
  container_registry_name = "acr51008558050825"
  description             = "Can perform all read, write and delete operations on the registry"
  name                    = "_repositories_admin"
  resource_group_name     = "azure-rg"
  depends_on = [
    azurerm_container_registry.res-7,
  ]
}
resource "azurerm_container_registry_scope_map" "res-9" {
  actions                 = ["repositories/*/content/read"]
  container_registry_name = "acr51008558050825"
  description             = "Can pull any repository of the registry"
  name                    = "_repositories_pull"
  resource_group_name     = "azure-rg"
  depends_on = [
    azurerm_container_registry.res-7,
  ]
}
resource "azurerm_container_registry_scope_map" "res-10" {
  actions                 = ["repositories/*/content/read", "repositories/*/metadata/read"]
  container_registry_name = "acr51008558050825"
  description             = "Can perform all read operations on the registry"
  name                    = "_repositories_pull_metadata_read"
  resource_group_name     = "azure-rg"
  depends_on = [
    azurerm_container_registry.res-7,
  ]
}
resource "azurerm_container_registry_scope_map" "res-11" {
  actions                 = ["repositories/*/content/read", "repositories/*/content/write"]
  container_registry_name = "acr51008558050825"
  description             = "Can push to any repository of the registry"
  name                    = "_repositories_push"
  resource_group_name     = "azure-rg"
  depends_on = [
    azurerm_container_registry.res-7,
  ]
}
resource "azurerm_container_registry_scope_map" "res-12" {
  actions                 = ["repositories/*/metadata/read", "repositories/*/metadata/write", "repositories/*/content/read", "repositories/*/content/write"]
  container_registry_name = "acr51008558050825"
  description             = "Can perform all read and write operations on the registry"
  name                    = "_repositories_push_metadata_write"
  resource_group_name     = "azure-rg"
  depends_on = [
    azurerm_container_registry.res-7,
  ]
}
resource "azurerm_kubernetes_cluster" "res-13" {
  dns_prefix          = "aks-510085-azure-rg-23a9f4"
  location            = "eastus2"
  name                = "aks-51008558"
  resource_group_name = "azure-rg"
  default_node_pool {
    name    = "nodepool1"
    vm_size = "Standard_D2as_v5"
    upgrade_settings {
      max_surge = "10%"
    }
  }
  identity {
    type = "SystemAssigned"
  }
  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDrG6/NRXuK6rAPEFF5J3R8NLYfCVkXG6lqxet57+JnCtDMmPj1McBuru6NcqvylZ7XWNrAkpcZPuSWQq0Li6fshahDWoIJLy+pfal0MoixyopRl5cc2NrjlusLf1AXLfWOFp+92a/yl8gI1wU5ab1kbAjflQfFFaVECEl8ImKjvAWfLPsAfShnHoz8vZ4gQMlkXbixH9gI/qrktkAPoR/yhZI7K9h2t+E2E1Z+7r4WKXjQAUXtCJ4t6OYQcqYszkqqAtVYhc1Rj2MVPCgb6mp2FFkrVOI3azgwUWuDbbTNuOrhm2RcmfQu7Yj/ZcthvdObD7pZQIjGCvJgneC7OFuv"
    }
  }
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_kubernetes_cluster_node_pool" "res-14" {
  auto_scaling_enabled  = true
  kubernetes_cluster_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.ContainerService/managedClusters/aks-51008558"
  max_count             = 3
  min_count             = 1
  name                  = "linux1"
  vm_size               = "Standard_D2as_v5"
  depends_on = [
    azurerm_kubernetes_cluster.res-13,
  ]
}
resource "azurerm_kubernetes_cluster_node_pool" "res-15" {
  kubernetes_cluster_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.ContainerService/managedClusters/aks-51008558"
  mode                  = "System"
  name                  = "nodepool1"
  vm_size               = "Standard_D2as_v5"
  upgrade_settings {
    max_surge = "10%"
  }
  depends_on = [
    azurerm_kubernetes_cluster.res-13,
  ]
}
resource "azurerm_user_assigned_identity" "res-16" {
  location            = "eastus2"
  name                = "aks-identity-7195945"
  resource_group_name = "azure-rg"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_user_assigned_identity" "res-17" {
  location            = "eastus2"
  name                = "kubelet-identity-7195945"
  resource_group_name = "azure-rg"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_log_analytics_workspace" "res-18" {
  location            = "eastus2"
  name                = "aks-51008558-law"
  resource_group_name = "azure-rg"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-19" {
  category                   = "General Exploration"
  display_name               = "All Computers with their most recent data"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_General|AlphabeticallySortedComputers"
  query                      = "search not(ObjectName == \"Advisor Metrics\" or ObjectName == \"ManagedSpace\") | summarize AggregatedValue = max(TimeGenerated) by Computer | limit 500000 | sort by Computer asc\r\n// Oql: NOT(ObjectName=\"Advisor Metrics\" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) by Computer | top 500000 | Sort Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-20" {
  category                   = "General Exploration"
  display_name               = "Stale Computers (data older than 24 hours)"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_General|StaleComputers"
  query                      = "search not(ObjectName == \"Advisor Metrics\" or ObjectName == \"ManagedSpace\") | summarize lastdata = max(TimeGenerated) by Computer | limit 500000 | where lastdata < ago(24h)\r\n// Oql: NOT(ObjectName=\"Advisor Metrics\" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) as lastdata by Computer | top 500000 | where lastdata < NOW-24HOURS // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-21" {
  category                   = "General Exploration"
  display_name               = "Which Management Group is generating the most data points?"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_General|dataPointsPerManagementGroup"
  query                      = "search * | summarize AggregatedValue = count() by ManagementGroupName\r\n// Oql: * | Measure count() by ManagementGroupName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-22" {
  category                   = "General Exploration"
  display_name               = "Distribution of data Types"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_General|dataTypeDistribution"
  query                      = "search * | extend Type = $table | summarize AggregatedValue = count() by Type\r\n// Oql: * | Measure count() by Type // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-23" {
  category                   = "Log Management"
  display_name               = "All Events"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|AllEvents"
  query                      = "Event | sort by TimeGenerated desc\r\n// Oql: Type=Event // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-24" {
  category                   = "Log Management"
  display_name               = "All Syslogs"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|AllSyslog"
  query                      = "Syslog | sort by TimeGenerated desc\r\n// Oql: Type=Syslog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-25" {
  category                   = "Log Management"
  display_name               = "All Syslog Records grouped by Facility"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|AllSyslogByFacility"
  query                      = "Syslog | summarize AggregatedValue = count() by Facility\r\n// Oql: Type=Syslog | Measure count() by Facility // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-26" {
  category                   = "Log Management"
  display_name               = "All Syslog Records grouped by ProcessName"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|AllSyslogByProcessName"
  query                      = "Syslog | summarize AggregatedValue = count() by ProcessName\r\n// Oql: Type=Syslog | Measure count() by ProcessName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-27" {
  category                   = "Log Management"
  display_name               = "All Syslog Records with Errors"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|AllSyslogsWithErrors"
  query                      = "Syslog | where SeverityLevel == \"error\" | sort by TimeGenerated desc\r\n// Oql: Type=Syslog SeverityLevel=error // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-28" {
  category                   = "Log Management"
  display_name               = "Average HTTP Request time by Client IP Address"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|AverageHTTPRequestTimeByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by cIP\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-29" {
  category                   = "Log Management"
  display_name               = "Average HTTP Request time by HTTP Method"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|AverageHTTPRequestTimeHTTPMethod"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by csMethod\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-30" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by Client IP Address"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|CountIISLogEntriesClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by cIP\r\n// Oql: Type=W3CIISLog | Measure count() by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-31" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by HTTP Request Method"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|CountIISLogEntriesHTTPRequestMethod"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csMethod\r\n// Oql: Type=W3CIISLog | Measure count() by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-32" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by HTTP User Agent"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|CountIISLogEntriesHTTPUserAgent"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUserAgent\r\n// Oql: Type=W3CIISLog | Measure count() by csUserAgent // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-33" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by Host requested by client"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|CountOfIISLogEntriesByHostRequestedByClient"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csHost\r\n// Oql: Type=W3CIISLog | Measure count() by csHost // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-34" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by URL for the host \"www.contoso.com\" (replace with your own)"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|CountOfIISLogEntriesByURLForHost"
  query                      = "search csHost == \"www.contoso.com\" | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog csHost=\"www.contoso.com\" | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-35" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by URL requested by client (without query strings)"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|CountOfIISLogEntriesByURLRequestedByClient"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-36" {
  category                   = "Log Management"
  display_name               = "Count of Events with level \"Warning\" grouped by Event ID"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|CountOfWarningEvents"
  query                      = "Event | where EventLevelName == \"warning\" | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event EventLevelName=warning | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-37" {
  category                   = "Log Management"
  display_name               = "Shows breakdown of response codes"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|DisplayBreakdownRespondCodes"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by scStatus\r\n// Oql: Type=W3CIISLog | Measure count() by scStatus // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-38" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event Log"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|EventsByEventLog"
  query                      = "Event | summarize AggregatedValue = count() by EventLog\r\n// Oql: Type=Event | Measure count() by EventLog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-39" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event Source"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|EventsByEventSource"
  query                      = "Event | summarize AggregatedValue = count() by Source\r\n// Oql: Type=Event | Measure count() by Source // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-40" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event ID"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|EventsByEventsID"
  query                      = "Event | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-41" {
  category                   = "Log Management"
  display_name               = "Events in the Operations Manager Event Log whose Event ID is in the range between 2000 and 3000"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|EventsInOMBetween2000to3000"
  query                      = "Event | where EventLog == \"Operations Manager\" and EventID >= 2000 and EventID <= 3000 | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLog=\"Operations Manager\" EventID:[2000..3000] // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-42" {
  category                   = "Log Management"
  display_name               = "Count of Events containing the word \"started\" grouped by EventID"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|EventsWithStartedinEventID"
  query                      = "search in (Event) \"started\" | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event \"started\" | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-43" {
  category                   = "Log Management"
  display_name               = "Find the maximum time taken for each page"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|FindMaximumTimeTakenForEachPage"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = max(TimeTaken) by csUriStem\r\n// Oql: Type=W3CIISLog | Measure Max(TimeTaken) by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-44" {
  category                   = "Log Management"
  display_name               = "IIS Log Entries for a specific client IP Address (replace with your own)"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|IISLogEntriesForClientIP"
  query                      = "search cIP == \"192.168.0.1\" | extend Type = $table | where Type == W3CIISLog | sort by TimeGenerated desc | project csUriStem, scBytes, csBytes, TimeTaken, scStatus\r\n// Oql: Type=W3CIISLog cIP=\"192.168.0.1\" | Select csUriStem,scBytes,csBytes,TimeTaken,scStatus // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-45" {
  category                   = "Log Management"
  display_name               = "All IIS Log Entries"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|ListAllIISLogEntries"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | sort by TimeGenerated desc\r\n// Oql: Type=W3CIISLog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-46" {
  category                   = "Log Management"
  display_name               = "How many connections to Operations Manager's SDK service by day"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|NoOfConnectionsToOMSDKService"
  query                      = "Event | where EventID == 26328 and EventLog == \"Operations Manager\" | summarize AggregatedValue = count() by bin(TimeGenerated, 1d) | sort by TimeGenerated desc\r\n// Oql: Type=Event EventID=26328 EventLog=\"Operations Manager\" | Measure count() interval 1DAY // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-47" {
  category                   = "Log Management"
  display_name               = "When did my servers initiate restart?"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|ServerRestartTime"
  query                      = "search in (Event) \"shutdown\" and EventLog == \"System\" and Source == \"User32\" and EventID == 1074 | sort by TimeGenerated desc | project TimeGenerated, Computer\r\n// Oql: shutdown Type=Event EventLog=System Source=User32 EventID=1074 | Select TimeGenerated,Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-48" {
  category                   = "Log Management"
  display_name               = "Shows which pages people are getting a 404 for"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|Show404PagesList"
  query                      = "search scStatus == 404 | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog scStatus=404 | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-49" {
  category                   = "Log Management"
  display_name               = "Shows servers that are throwing internal server error"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|ShowServersThrowingInternalServerError"
  query                      = "search scStatus == 500 | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by sComputerName\r\n// Oql: Type=W3CIISLog scStatus=500 | Measure count() by sComputerName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-50" {
  category                   = "Log Management"
  display_name               = "Total Bytes received by each Azure Role Instance"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|TotalBytesReceivedByEachAzureRoleInstance"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by RoleInstance\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by RoleInstance // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-51" {
  category                   = "Log Management"
  display_name               = "Total Bytes received by each IIS Computer"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|TotalBytesReceivedByEachIISComputer"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by Computer | limit 500000\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by Computer | top 500000 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-52" {
  category                   = "Log Management"
  display_name               = "Total Bytes responded back to clients by Client IP Address"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|TotalBytesRespondedToClientsByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(scBytes) by cIP\r\n// Oql: Type=W3CIISLog | Measure Sum(scBytes) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-53" {
  category                   = "Log Management"
  display_name               = "Total Bytes responded back to clients by each IIS ServerIP Address"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|TotalBytesRespondedToClientsByEachIISServerIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(scBytes) by sIP\r\n// Oql: Type=W3CIISLog | Measure Sum(scBytes) by sIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-54" {
  category                   = "Log Management"
  display_name               = "Total Bytes sent by Client IP Address"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|TotalBytesSentByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by cIP\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-55" {
  category                   = "Log Management"
  display_name               = "All Events with level \"Warning\""
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|WarningEvents"
  query                      = "Event | where EventLevelName == \"warning\" | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLevelName=warning // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-56" {
  category                   = "Log Management"
  display_name               = "Windows Firewall Policy settings have changed"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|WindowsFireawallPolicySettingsChanged"
  query                      = "Event | where EventLog == \"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" and EventID == 2008 | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLog=\"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" EventID=2008 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-57" {
  category                   = "Log Management"
  display_name               = "On which machines and how many times have Windows Firewall Policy settings changed"
  log_analytics_workspace_id = "/subscriptions/23a9f43c-3caf-46e2-be51-e0cabf6d2832/resourceGroups/azure-rg/providers/Microsoft.OperationalInsights/workspaces/aks-51008558-law"
  name                       = "LogManagement(aks-51008558-law)_LogManagement|WindowsFireawallPolicySettingsChangedByMachines"
  query                      = "Event | where EventLog == \"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" and EventID == 2008 | summarize AggregatedValue = count() by Computer | limit 500000\r\n// Oql: Type=Event EventLog=\"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" EventID=2008 | measure count() by Computer | top 500000 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-18,
  ]
}
