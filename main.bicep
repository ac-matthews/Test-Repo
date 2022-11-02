@description('The Azure region into which the resources should be deployed.')
param location string = 'resourceGroup().location'

@description('Username for the Virtual Machine.')
param adminUsername string

@description('Password for the Virtual Machine.')
@secure()
param adminPassword string
module core 'modules/core.bicep' = {
  name: 'core'
  params: {
    adminPassword: adminUsername
    adminUsername: adminPassword
    location: location 
  }
}
