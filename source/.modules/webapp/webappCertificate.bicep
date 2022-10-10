param location string
param customHostname string
param serverFarmId string

resource managedCertificate 'Microsoft.Web/certificates@2022-03-01' = {
  name: customHostname
  location: location
  properties: {
    serverFarmId: serverFarmId
    canonicalName: customHostname
  }
}
