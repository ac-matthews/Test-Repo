@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location

param firewallIP string

var routeTableName = 'Exercise-Route-Table'
var routeToFirewallName = 'routeToFirewall'
var CoreToFirewallRouteName = 'CoreToFirewall'

resource routeTable 'Microsoft.Network/routeTables@2022-05-01' = {
  name: routeTableName
  location: location
}

resource CoreToFirewall 'Microsoft.Network/routeTables/routes@2022-05-01' = {
  name: CoreToFirewallRouteName
  parent: routeTable
  properties: {
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: firewallIP
    addressPrefix: '10.20.0.0/16'
  }
}

resource routeToFirewall 'Microsoft.Network/routeTables/routes@2022-05-01' = {
  name: routeToFirewallName
  parent: routeTable
  properties: {
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: firewallIP
    addressPrefix: '0.0.0.0/0'
  }
}
