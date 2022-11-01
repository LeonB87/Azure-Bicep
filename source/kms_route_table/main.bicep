targetScope = 'resourceGroup'

param location string = 'westeurope'
param dateTime string = utcNow('ddMMyyyyHHmm')

param routeTableName string

module routeTable '../.modules/network/routeTable.bicep' = {
  name: 'route${dateTime}'
  params: {
    routeTableName: routeTableName
    location: location
  }
}

module route1 '../.modules/network/routeTableRoute.bicep' = {
  name: 'route1${dateTime}'
  dependsOn: [
    routeTable
  ]
  params: {
    addressPrefix: '23.102.135.246/32'
    routeName: 'DirectRouteToKMS'
    routeTableName: routeTableName
  }
}

module route2 '../.modules/network/routeTableRoute.bicep' = {
  name: 'route2${dateTime}'
  dependsOn: [
    routeTable
  ]
  params: {
    addressPrefix: '20.118.99.224/32'
    routeName: 'DirectRouteToAZKMS01'
    routeTableName: routeTableName
  }
}

module route3 '../.modules/network/routeTableRoute.bicep' = {
  name: 'route3${dateTime}'
  dependsOn: [
    routeTable
  ]
  params: {
    addressPrefix: '40.83.235.53/32'
    routeName: 'DirectRouteToAZKMS02'
    routeTableName: routeTableName
  }
}
