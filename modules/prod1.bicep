@description('Location to deploy the resources to')
param location string = resourceGroup().location

@description('Username for the SQL server.')
@secure()
param SQLadminUsername string

@description('Password for the SQL server.')
@secure()
param SQLadminPassword string

param sqlServerName string = 'sql-prod-${uniqueString(resourceGroup().id)}'
param storageAccountName string = 'saprod1${uniqueString(resourceGroup().id)}'
param appServicePlanName string = 'app-plan-prod1-${uniqueString(resourceGroup().id)}'
param appServiceName string = 'helloworldprod${uniqueString(resourceGroup().id)}'
param linuxFxVersion string = 'DOTNETCORE|6.0'
param logAnalyticsID string

var sqlDatabaseName = 'db-prod1'
var virtualNetworkName = 'vnet-prod1'
var subnet1Name = 'appServicePlanProd'
var subnet2Name = 'sqlDatabaseProd'
var subnet3Name = 'storageProd'
var privateEndpoint1Name = 'privEndpointAPPprod'
var privateEndpoint2Name = 'privEndpointSQLprod'
var privateEndpoint3Name = 'privEndpointStorageprod'
var nsg1name = 'nsg1prod'
var nsg2name = 'nsg2prod'
var nsg3name = 'nsg3prod'
var appInsightsName = 'appInsightsProd'


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.31.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: '10.31.1.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroup1.id
          }
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: '10.31.2.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroup2.id
          }
        }
      }
      {
        name: subnet3Name
        properties: {
          addressPrefix: '10.31.3.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroup3.id
          }
        }
      }
    ]
  }
}

resource networkSecurityGroup1 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: nsg1name
  location: location
}

resource networkSecurityGroup2 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: nsg2name
  location: location
}

resource networkSecurityGroup3 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: nsg3name
  location: location
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: 'B1'
  }
  kind: 'linux'
}

resource appService 'Microsoft.Web/sites@2021-03-01' = {
  name: appServiceName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}

resource srcControls 'Microsoft.Web/sites/sourcecontrols@2021-03-01' = {
  name: '${appService.name}/web'
  properties: {
    repoUrl: 'https://github.com/Azure-Samples/dotnetcore-docs-hello-world'
    branch: 'master'
    isManualIntegration: true
  }
}

resource privateEndpoint1 'Microsoft.Network/privateEndpoints@2022-05-01'= {
  name: privateEndpoint1Name
  location: location
  properties: {
    subnet: {
      id: virtualNetwork.properties.subnets[0].id
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpoint2Name
        properties: {
          privateLinkServiceId: appService.id
          groupIds: [
            'sites'
          ]
        }
      }
    ]
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'string'
  tags: {
    displayName: 'AppInsightsDev'
    ProjectName: appServiceName
  }
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsID
  }
}

resource sqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: SQLadminUsername
    administratorLoginPassword: SQLadminPassword
  }
}

resource database 'Microsoft.Sql/servers/databases@2021-11-01' = {
  name: sqlDatabaseName
  location: location
  parent: sqlServer
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
}

resource privateEndpoint2 'Microsoft.Network/privateEndpoints@2022-05-01'= {
  name: privateEndpoint2Name
  location: location
  properties: {
    subnet: {
      id: virtualNetwork.properties.subnets[1].id
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpoint2Name
        properties: {
          privateLinkServiceId: sqlServer.id
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource privateEndpoint3 'Microsoft.Network/privateEndpoints@2022-05-01'= {
  name: privateEndpoint3Name
  location: location
  properties: {
    subnet: {
      id: virtualNetwork.properties.subnets[2].id
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpoint3Name
        properties: {
          privateLinkServiceId: storageAccount.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

output prodID string = virtualNetwork.id
