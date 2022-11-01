param routeName string
param routeTableName string
param addressPrefix string

resource routeTable 'Microsoft.Network/routeTables@2022-05-01' existing = {
  name: routeTableName
}

resource routeTableRoute 'Microsoft.Network/routeTables/routes@2022-05-01' = {
  name: routeName
  parent: routeTable
  properties: {
    nextHopType: 'Internet'
    addressPrefix: addressPrefix
  }
}
