param routeTableName string
param location string

resource udr 'Microsoft.Network/routeTables@2022-05-01' = {
  name: routeTableName
  location: location
}

output routeTableId string = udr.id
