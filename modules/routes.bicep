
param location string = resourceGroup().location
param firewallPrivateIP string

var routeTableName = 'Exercise-Route-Table'
var CoreToFirewallRouteName = 'CoreToFirewall'
var AllToFirewallRouteName = 'AllToFirewall'

resource routeTable 'Microsoft.Network/routeTables@2022-05-01' = {
  name: routeTableName
  location: location
}

resource AllToFirewall 'Microsoft.Network/routeTables/routes@2022-05-01' = {
  name: AllToFirewallRouteName
  parent: routeTable
  properties: {
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: firewallPrivateIP
    addressPrefix: '0.0.0.0/0'
  }
}

resource CoreToFirewall 'Microsoft.Network/routeTables/routes@2022-05-01' = {
  name: CoreToFirewallRouteName
  parent: routeTable
  properties: {
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: firewallPrivateIP
    addressPrefix: '10.20.0.0/16'
  }
}

output routeTableID string = routeTable.id
