targetScope = 'subscription'
// General parameters

param location string = 'westeurope'
param dateTime string = utcNow('ddMMyyyyHHmm')

@description('The resourcegroup where to deploy')
@minLength(3)
@maxLength(14)
param resourcegroupname string

// vms
param availabilitySetName string
param vm001Name string
param vm001OSName string
param vm002Name string
param vm002OSName string
param vm002internalIP string

/// network
param virtualnetworkName string
param virtualNetworkAddressPrefix string

param subnetName string
param subnetPrefix string

resource resourcegroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourcegroupname
  location: location
}

module vnet '../.modules/network/vnet.bicep' = {
  scope: resourcegroup
  name: 'vnet${dateTime}'
  params: {
    addressPrefix: virtualNetworkAddressPrefix
    location: location
    vnetName: virtualnetworkName
  }
}

module networkSecurityGroup '../.modules/network/networkSecurityGroup.bicep' = {
  scope: resourcegroup
  name: 'nsg${dateTime}'
  params: {
    location: location
    name: '${virtualnetworkName}-nsg'
    nsgRules: loadJsonContent('nsgrules.json')
  }
}

module subnet '../.modules/network/subnet.bicep' = {
  scope: resourcegroup
  name: 'subnet${dateTime}'
  dependsOn: [
    vnet
  ]
  params: {
    paranetVnetName: virtualnetworkName
    subnetAddressPrefix: subnetPrefix
    subnetName: subnetName
    networkSecurityGroupId: networkSecurityGroup.outputs.Id
  }
}

module availabilityset '../.modules/iaas/availabilityset.bicep' = {
  scope: resourcegroup
  name: 'availabilitySet${dateTime}'
  params: {
    location: location
    name: availabilitySetName
  }
}

module vm001 '../.modules/iaas/virtualMachine.bicep' = {
  scope: resourcegroup
  name: '${vm001Name}${dateTime}'
  params: {
    location: location
    name: vm001Name
    subnetId: subnet.outputs.subnetId
    osName: vm001OSName
    osUsername: 'sb_boers'
    osUserPassword: 'Th!s1sV3ryS3cret!'
    requirePublicIP: true
    availabilitySetId: availabilityset.outputs.availabilitySetId
  }
}

module vm002 '../.modules/iaas/virtualMachine.bicep' = {
  scope: resourcegroup
  name: '${vm002Name}${dateTime}'
  params: {
    location: location
    name: vm002Name
    subnetId: subnet.outputs.subnetId
    osName: vm002OSName
    osUsername: 'sb_boers'
    osUserPassword: 'Th!s1sV3ryS3cret!'
    requirePublicIP: false
    privateAddress: vm002internalIP
    availabilitySetId: availabilityset.outputs.availabilitySetId
  }
}

output vm01PublicIP string = vm001.outputs.externalIp
output vm01InternalIP string = vm001.outputs.internalIP
output vm02InternalIP string = vm002.outputs.internalIP
