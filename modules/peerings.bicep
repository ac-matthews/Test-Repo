param coreID string
param hubID string
param devID string
param prodID string

var hubVnet = 'vnet-hub1'
var coreVnet = 'vnet-core1'
var devVnet = 'vnet-dev1'
var prodVnet = 'vnet-prod1'

resource HubToCore 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-05-01' = {
  name: '${hubVnet}/peering_to_core'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: true
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: coreID
    }
  }
}

resource CoreToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-05-01' = {
  name: '${coreVnet}/peering_to_hub'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: true
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: hubID
    }
  }
}

resource HubToDev 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-05-01' = {
  name: '${hubVnet}/peering_to_dev'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: true
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: devID
    }
  }
}

resource DevToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-05-01' = {
  name: '${devVnet}/peering_to_hub'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: true
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: hubID
    }
  }
}

resource HubToProd 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-05-01' = {
  name: '${hubVnet}/peering_to_prod'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: true
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: prodID
    }
  }
}

resource ProdToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-05-01' = {
  name: '${prodVnet}/peering_to_hub'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: true
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: hubID
    }
  }
}
