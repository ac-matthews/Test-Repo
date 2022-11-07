@description('Location to deploy the resources to')
param location string = resourceGroup().location

var virtualNetworkName = 'vnet-prod1'
var subnet1Name = 'appServicePlanProd'
var subnet2Name = 'sqlDatabaseProd'
var subnet3Name = 'storageProd'

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

output prodID string = virtualNetwork.id
