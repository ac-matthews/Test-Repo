@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location

param subscriptionId string = subscription().subscriptionId
param kvResourceGroup string = resourceGroup().name

param kvName string

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: kvName
  scope: resourceGroup(subscriptionId, kvResourceGroup )
}

module core 'modules/core.bicep' = {
  name: 'core'
  params: {
    logAnalyticsID: logAnalytics.outputs.logAnalyticsID
    adminUsername: kv.getSecret('username')
    adminPassword: kv.getSecret('password')
    location: location
    routeTableID: routes.outputs.routeTableID
  }
}

module hub 'modules/hub.bicep' = {
  name: 'hub'
  params: {
    storageAccountID: prod.outputs.storageAccountID
    logAnalyticsID: logAnalytics.outputs.logAnalyticsID
    prodAppServiceHostName: prod.outputs.prodAppServiceHostName
    location: location
  }
}

module dev 'modules/dev1.bicep' = {
  name: 'dev'
  params: {
    routeTableID: routes.outputs.routeTableID
    location: location
    SQLadminUsername: kv.getSecret('sqluser1')
    SQLadminPassword: kv.getSecret('sqlpassword1')
  }
}

module prod 'modules/prod1.bicep' = {
  name: 'prod'
  params: {
    routeTableID: routes.outputs.routeTableID
    location: location
    SQLadminUsername: kv.getSecret('sqluser2')
    SQLadminPassword: kv.getSecret('sqlpassword2')
    logAnalyticsID: logAnalytics.outputs.logAnalyticsID
  }
}

module peerings 'modules/peerings.bicep' = {
  name: 'peerings'
  params: {
    coreID: core.outputs.coreID
    hubID: hub.outputs.hubID
    devID: dev.outputs.devID
    prodID: prod.outputs.prodID
  }
}

module logAnalytics 'modules/loganalytics.bicep' = {
  name: 'logAnalytics'
  params: {
    location: location
  }
}

module routes 'modules/routes.bicep' = {
  name: 'routes'
  params: {
    location: location
        firewallPrivateIP: '0.0.0.0'
  }
}

module routesupdate 'modules/routes.bicep' = {
  name: 'routesupdate'
  params: {
    location: location
    firewallPrivateIP: hub.outputs.firewallPrivateIP
  }
}

module dnsZones 'modules/dnsZones.bicep' = {
  name: 'dnsZones'
}

module dns 'modules/dns.bicep' = {
  name: 'dns'
  params: {
    privateDnsZone1ID: dnsZones.outputs.privateDnsZone1ID
    privateDnsZone2ID: dnsZones.outputs.privateDnsZone2ID
    privateDnsZone3ID: dnsZones.outputs.privateDnsZone3ID
    privateDnsZone1name: dnsZones.outputs.privateDnsZone1name
    privateDnsZone2name: dnsZones.outputs.privateDnsZone2name
    privateDnsZone3name: dnsZones.outputs.privateDnsZone3name
    coreID: core.outputs.coreID
    prodID: prod.outputs.prodID
    hubID: hub.outputs.hubID
    devID: dev.outputs.devID
    devAppPEname: dev.outputs.devAppPE
    devSqlPEname: dev.outputs.devSqlPE
    prodAppPEname: prod.outputs.prodAppPE
    prodSqlPEname: prod.outputs.prodSqlPE
    prodStoragePEname: prod.outputs.prodStoragePE
  }
}
