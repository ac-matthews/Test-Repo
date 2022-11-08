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

var sqlDatabaseName = 'db-prod1'
var virtualNetworkName = 'vnet-prod1'
var subnet1Name = 'appServicePlanProd'
var subnet2Name = 'sqlDatabaseProd'
var subnet3Name = 'storageProd'
var privateEndpoint1Name = 'privEndpointSQLprod'
var privateEndpoint2Name = 'privEndpointStorageprod'

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
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: '10.31.2.0/24'
        }
      }
      {
        name: subnet3Name
        properties: {
          addressPrefix: '10.31.3.0/24'
        }
      }
    ]
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

resource privateEndpoint1 'Microsoft.Network/privateEndpoints@2022-05-01'= {
  name: privateEndpoint1Name
  location: location
  properties: {
    subnet: {
      id: virtualNetwork.properties.subnets[1].id
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpoint1Name
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

resource privateEndpoint2 'Microsoft.Network/privateEndpoints@2022-05-01'= {
  name: privateEndpoint2Name
  location: location
  properties: {
    subnet: {
      id: virtualNetwork.properties.subnets[2].id
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpoint2Name
        properties: {
          privateLinkServiceId: storageAccount.id
          groupIds: [
            'storage'
          ]
        }
      }
    ]
  }
}

output prodID string = virtualNetwork.id
