@description('Location to deploy the resources to')
param location string = resourceGroup().location

var virtualNetworkName = 'vnet-dev1'
var subnet1Name = 'appServicePlanDev'
var subnet2Name = 'sqlDatabaseDev'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.30.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: '10.30.1.0/24'
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: '10.30.2.0/24'
        }
      }
    ]
  }
}
