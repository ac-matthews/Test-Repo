param dnsZone1Name string = 'privatelink.azurewebsites.net'
param dnsZone2Name string = 'privatelink.database.windows.net'
param dnsZone3Name string = 'privatelink.blob.core.windows.net'

resource privateDnsZone1 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: dnsZone1Name
  location: 'global'
  properties: {}
}

resource privateDnsZone2 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: dnsZone2Name
  location: 'global'
  properties: {}
}

resource privateDnsZone3 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: dnsZone3Name
  location: 'global'
  properties: {}
}

output privateDnsZone1ID string = privateDnsZone1.id
output privateDnsZone2ID string = privateDnsZone2.id
output privateDnsZone3ID string = privateDnsZone3.id
output privateDnsZone1name string = privateDnsZone1.name
output privateDnsZone2name string = privateDnsZone2.name
output privateDnsZone3name string = privateDnsZone3.name


