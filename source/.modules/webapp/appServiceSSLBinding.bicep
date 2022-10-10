@allowed([
  'SniEnabled'
  'Disabled'
  'IpBasedEnabled'
])
param sslState string
param customHostname string

param appServiceName string

resource appService 'Microsoft.Web/sites@2022-03-01' existing = {
  name: appServiceName
}

resource hostname 'Microsoft.Web/sites/hostNameBindings@2022-03-01' = {
  name: customHostname
  parent: appService
  properties: {
    siteName: customHostname
    sslState: sslState
  }
}
