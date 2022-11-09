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
    adminUsername: kv.getSecret('username')
    adminPassword: kv.getSecret('password')
    location: location 
  }
}

module hub 'modules/hub.bicep' = {
  name: 'hub'
  params: {
    location: location
  }
}

module dev 'modules/dev1.bicep' = {
  name: 'dev'
  params: {
    location: location
    SQLadminUsername: kv.getSecret('sqluser1')
    SQLadminPassword: kv.getSecret('sqlpassword1')
  }
}

module prod 'modules/prod1.bicep' = {
  name: 'prod'
  params: {
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
    firewallIP: hub.outputs.firewallIP
  }
}
