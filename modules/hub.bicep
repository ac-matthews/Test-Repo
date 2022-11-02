@description('Location to deploy the resources to')
param location string = resourceGroup().location

var virtualNetworkName = 'vnet-core1'
var subnet1Name = 'GatewaySubnet'
var subnet2Name = 'AppgwSubnet'
var subnet3name = 'AzureFirewallSubnet'
var subnet4name = 'AzureBastionSubnet'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: '10.10.1.0/24'
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: '10.10.2.0/24'
        }
      }
      {
        name: subnet3name
        properties: {
          addressPrefix: '10.10.3.0/24'
        }
      }
      {
        name: subnet4name
        properties: {
          addressPrefix: '10.10.4.0/24'
        }
      }
    ]
  }
}
