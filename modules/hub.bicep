@description('Location to deploy the resources to')
param location string = resourceGroup().location

var virtualNetworkName = 'vnet-hub1'
var subnet1Name = 'GatewaySubnet'
var subnet2Name = 'AppgwSubnet'
var subnet3name = 'AzureFirewallSubnet'
var subnet4name = 'AzureBastionSubnet'
// var hubGatewayName = 'gateway-hub1'
var bastionName = 'bastion-hub1'
var firewallName = 'firewall-hub1'
var appgatewayName = 'appgw-hub1'
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

resource firewall 'Microsoft.Network/azureFirewalls@2022-05-01' = {
  name: firewallName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'fw-ipconfig'
        properties: {
          subnet: {
            id: virtualNetwork.properties.subnets[2].id
          }
          publicIPAddress: {
            id: firewallpip.id
          }
        }
      }
    ]
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

resource appgateway 'Microsoft.Network/applicationGateways@2021-05-01' = {
  name: appgatewayName
  location: location
  properties: {
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: virtualNetwork.properties.subnets[1].id
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: appgatewaypip.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'myBackendPool'
        properties: {}
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'myHTTPSetting'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          requestTimeout: 20
        }
      }
    ]
    httpListeners: [
      {
        name: 'myListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', appgatewayName, 'appGwPublicFrontendIp')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', appgatewayName, 'port_80')
          }
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'myRoutingRule'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', appgatewayName, 'myListener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', appgatewayName, 'myBackendPool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', appgatewayName, 'myHTTPSetting')
          }
        }
      }
    ]
    enableHttp2: false
    autoscaleConfiguration: {
      minCapacity: 0
      maxCapacity: 10
    }
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

// resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2021-02-01' = {
//   name: hubGatewayName
//   location: location
//   properties: {
//     gatewayType: 'Vpn'
//     ipConfigurations: [
//       {
//         name: 'default'
//         properties: {
//           privateIPAllocationMethod: 'Dynamic'
//           subnet: {
//             id: virtualNetwork.properties.subnets[0].id
//           }
//           publicIPAddress: {
//             id: hubgatewaypip.id
//           }
//         }
//       }
//     ]
// }
// }

output hubID string = virtualNetwork.id
