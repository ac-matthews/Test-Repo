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
  }
}

module prod 'modules/prod1.bicep' = {
  name: 'prod'
  params: {
    location: location
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
