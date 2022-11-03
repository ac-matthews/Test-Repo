@description('Location to deploy the resources to')
param location string = resourceGroup().location

var virtualNetworkName = 'vnet-hub1'
var subnet1Name = 'GatewaySubnet'
var subnet2Name = 'AppgwSubnet'
var subnet3name = 'AzureFirewallSubnet'
var subnet4name = 'AzureBastionSubnet'
var bastionName = 'bastion-hub1'
var bastionpipname = 'bastionpip'
var firewallpipname = 'firewallpip'
var appgatewaypipname = 'appgateway'
var hubgatewaypipname = 'hubgatewaypip'

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

resource bastionpip 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name:  bastionpipname
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
  }
} 

resource azureBastion 'Microsoft.Network/bastionHosts@2022-05-01' = {
  name: bastionName
  location: location
  properties: {
    ipConfigurations: [
      {
        id: bastionpip.id
        name: 'ipconfig'
        properties: {
          publicIPAddress: {
            id: bastionpip.id
          }
          subnet: {
            id: virtualNetwork.properties.subnets[3].id
          }
        }
      }
    ]
  }
}

resource firewallpip 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name:  firewallpipname
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
  }
} 

resource appgatewaypip 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name:  appgatewaypipname
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
  }
} 

resource hubgatewaypip 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name:  hubgatewaypipname
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
  }
} 
