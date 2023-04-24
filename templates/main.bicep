param location string = resourceGroup().location

param appVersion string = 'latest'

@description('admin email used for Lets Encrypt.')
param acmeEmail string

module servicebusModule 'modules/servicebus.bicep' = {
  name: 'serviceBus'
  params: {
    location: location
    appVersion: appVersion
  }
}

module appInsightsModule 'modules/applicationInsights.bicep' = {
  name: 'appInsights'
  params: {
    location: location
    appVersion: appVersion
  }
}

var containerImage = 'ghcr.io/gpsuscodewith/modm'

module containerInstanceModule 'modules/containerInstance.bicep' = {
  name: 'containerInstance'
  params: {
    location: location
    appVersion: appVersion
    containerImage: containerImage
    resourceGroupName: resourceGroup().name
    subscriptionId: subscription().subscriptionId
    tenantId: subscription().tenantId
    acmeEmail: acmeEmail
    serviceBusNamespace: servicebusModule.outputs.serviceBusNamespace
    appInsightsInstrumentationKey: appInsightsModule.outputs.appInsightsInstrumentationKey
  }
  dependsOn: [
    servicebusModule
    appInsightsModule
  ]
}

module roleAssignments 'modules/roleAssignments.bicep' = {
  name: 'roleAssignments'
  params: {
    containerGroupName: containerInstanceModule.outputs.containerGroupName
    serviceBusNamespace: servicebusModule.outputs.serviceBusNamespace
    storageAccountName: containerInstanceModule.outputs.storageAccountName
    appInsightsName: appInsightsModule.outputs.appInsightsName
  }
  dependsOn: [
    servicebusModule
    containerInstanceModule
    appInsightsModule
  ]
}
