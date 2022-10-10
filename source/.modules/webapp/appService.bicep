param location string

param serverFarmId string

param appserviceName string

param enabled bool = true
param httpsOnly bool = true

@allowed([
    'None'
    'SystemAssigned'
    'UserAssigned'
  ]
)
param managedServiceIdentityType string
param managedUserIdentity object = {}

resource appservice 'Microsoft.Web/sites@2022-03-01' = {
  name: appserviceName
  identity: {
    type: managedServiceIdentityType
    userAssignedIdentities: (managedServiceIdentityType == 'UserAssigned') ? managedUserIdentity : null
  }
  location: location
  kind: 'app'
  properties: {
    enabled: enabled
    serverFarmId: serverFarmId
    httpsOnly: httpsOnly
  }
}

output appserviceId string = appservice.id
output appserviceConfig object = appservice.properties
output appserviceKind string = appservice.kind
