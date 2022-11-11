param coreID string
param hubID string
param devID string
param prodID string
param devAppPEname string
param devSqlPEname string
param prodAppPEname string
param prodSqlPEname string
param prodStoragePEname string

param privateDnsZone1ID string
param privateDnsZone2ID string
param privateDnsZone3ID string
param privateDnsZone1name string
param privateDnsZone2name string
param privateDnsZone3name string
 
resource Zone1ToCore 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${privateDnsZone1name}/${uniqueString(coreID)}'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: coreID
    }
  }
}

resource Zone2ToCore 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${privateDnsZone2name}/${uniqueString(coreID)}' 
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: coreID
    }
  }
}

resource Zone3ToCore 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${privateDnsZone3name}/${uniqueString(coreID)}' 
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: coreID
    }
  }
}

resource Zone1ToHub 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${privateDnsZone1name}/${uniqueString(hubID)}' 
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: hubID
    }
  }
}

resource Zone2ToHub 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${privateDnsZone2name}/${uniqueString(hubID)}' 
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: hubID
    }
  }
}

resource Zone3ToHub 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${privateDnsZone3name}/${uniqueString(hubID)}' 
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: hubID
    }
  }
}

resource Zone1ToDev 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${privateDnsZone1name}/${uniqueString(devID)}' 
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: devID
    }
  }
}

resource Zone2ToDev 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${privateDnsZone2name}/${uniqueString(devID)}' 
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: devID
    }
  }
}

resource Zone3ToDev 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${privateDnsZone3name}/${uniqueString(devID)}' 
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: devID
    }
  }
}

resource Zone1ToProd 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${privateDnsZone1name}/${uniqueString(prodID)}' 
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: prodID
    }
  }
}

resource Zone2ToProd 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${privateDnsZone2name}/${uniqueString(prodID)}' 
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: prodID
    }
  }
}

resource Zone3ToProd 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${privateDnsZone3name}/${uniqueString(prodID)}' 
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: prodID
    }
  }
}

resource devAppZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-05-01' = {
  name: '${devAppPEname}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-blob-core-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZone1ID
        }
      }
    ]
  }
}

resource devSqlZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-05-01' = {
  name: '${devSqlPEname}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-blob-core-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZone2ID
        }
      }
    ]
  }
}
    
resource prodAppZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-05-01' = {
  name: '${prodAppPEname}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-blob-core-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZone1ID
        }
      }
    ]
  }
}

resource prodSqlZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-05-01' = {
  name: '${prodSqlPEname}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-blob-core-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZone2ID
        }
      }
    ]
  }
}

resource prodStorageZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-05-01' = {
  name: '${prodStoragePEname}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-blob-core-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZone3ID
        }
      }
    ]
  }
}
