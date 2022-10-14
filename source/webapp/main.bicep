targetScope = 'subscription'
// General parameters

param location string = 'westeurope'
param dateTime string = utcNow('ddMMyyyyHHmm')

@description('The resourcegroup to deploy the webapp to')
@minLength(3)
@maxLength(14)
param resourcegroupname string

@description('the app service plan name')
param appServicePlanName string = 'azapp-plan-wds-001'

@description('the app service')
param appserviceName string = 'azapp-wds-001'

@description('optionally a name to create a managed certificate. Leave empty to not create a managed certificate.')
param customDomainName string = 'webapp.saas.westerdijkstraat.nl'

resource appResourcegroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourcegroupname
  location: location
}

module appServicePlan '../.modules/webapp/appServicePlan.bicep' = {
  name: 'appServicePlan-${dateTime}'
  scope: appResourcegroup
  params: {
    appServicePlanName: appServicePlanName
    location: location
    appServicePlanSkuName: 'B1'
  }
}

module appService '../.modules/webapp/appService.bicep' = {
  scope: appResourcegroup
  name: 'appService-${dateTime}'
  params: {
    appserviceName: appserviceName
    location: location
    managedServiceIdentityType: 'SystemAssigned'
    serverFarmId: appServicePlan.outputs.appServicePlanId
  }
}

module appserviceConfig '../.modules/webapp/appServiceConfig.bicep' = {
  scope: appResourcegroup
  name: 'appServiceConfig-${dateTime}'
  params: {
    appServiceName: appService.outputs.appserviceConfig.name
    webConfigAlwaysOn: false
  }
}

// only deploy if a custom DNS name is required

module initialHostnameBinding '../.modules/webapp/appServiceSSLBinding.bicep' = if (!empty(customDomainName)) {
  scope: appResourcegroup
  dependsOn: [
    appService
  ]
  name: 'initial-HostnameBinding-${dateTime}'
  params: {
    appServiceName: appserviceName
    customHostname: customDomainName
    sslState: 'Disabled'
  }
}

module certificate '../.modules/webapp/webappCertificate.bicep' = if (!empty(customDomainName)) {
  dependsOn: [
    appserviceConfig
    initialHostnameBinding
  ]
  scope: appResourcegroup
  name: 'certificate-${dateTime}'
  params: {
    location: location
    serverFarmId: appServicePlan.outputs.appServicePlanId
    customHostname: customDomainName
  }
}

module activateHostnameBinding '../.modules/webapp/appServiceSSLBinding.bicep' = if (!empty(customDomainName)) {
  scope: appResourcegroup
  dependsOn: [
    certificate
  ]
  name: 'activate-HostnameBinding-${dateTime}'
  params: {
    appServiceName: appserviceName
    customHostname: customDomainName
    sslState: 'SniEnabled'
  }
}

// output appserviceId string = appService.outputs.appserviceId
// output appserviceConfig object = appService.outputs.appserviceConfig
// output appserviceKind string = appService.outputs.appserviceKind
