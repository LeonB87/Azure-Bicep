param appServiceName string

param webConfigAlwaysOn bool = true

@allowed([
  'v7.0'
  'v6.0'
])
param webConfigNetFrameworkVersion string = 'v6.0'

@allowed([
  'AllAllowed'
  'Disabled'
  'FtpsOnly'
])
param webconfigFtpsState string = 'FtpsOnly'

@allowed([
  '1.0'
  '1.1'
  '1.2'
])
param webconfigMinTlsVersion string = '1.2'
param webconfigHttp20Enabled bool = true

resource appService 'Microsoft.Web/sites@2022-03-01' existing = {
  name: appServiceName
}

resource config 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'web'
  parent: appService
  properties: {
    alwaysOn: webConfigAlwaysOn
    ftpsState: webconfigFtpsState
    netFrameworkVersion: webConfigNetFrameworkVersion
    minTlsVersion: webconfigMinTlsVersion
    http20Enabled: webconfigHttp20Enabled
  }
}
