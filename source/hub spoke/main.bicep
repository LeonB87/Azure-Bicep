targetScope = 'subscription'

// General parameters

param location string = 'westeurope'
param dateTime string = utcNow('ddMMyyyyHHmm')

// Hub Parameters

param vnetName string = 'vnet-hub-wds-001'
param hubAddressPrefix string = '10.10.0.0/16'

param hubResourcegroupName string = 'rg-hub-vnet'

// Resources

resource hub_Resourcegroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: hubResourcegroupName
  location: location
}

module hub_vnet '../.modules/network/vnet.bicep' = {
  scope: hub_Resourcegroup
  name: 'hubVnet${dateTime}'
  params: {
    location: location
    addressPrefix: hubAddressPrefix
    vnetName: vnetName
  }
}

module subnet_management '../.modules/network/subnet.bicep' = {
  scope: hub_Resourcegroup
  dependsOn: [
    hub_vnet
  ]
  name: 'subnetManagenent${dateTime}'
  params: {
    paranetVnetName: vnetName
    subnetName: 'management'
    subnetAddressPrefix: '10.10.1.0/24'
  }
}

module subnet_servers '../.modules/network/subnet.bicep' = {
  scope: hub_Resourcegroup
  dependsOn: [
    hub_vnet
  ]
  name: 'subnetServers${dateTime}'
  params: {
    paranetVnetName: vnetName
    subnetName: 'servers'
    subnetAddressPrefix: '10.10.2.0/24'
  }
}
