param paranetVnetName string
param subnetName string

param subnetAddressPrefix string

param networkSecurityGroupId string = ''

resource parent_vnet 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: paranetVnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  name: subnetName
  parent: parent_vnet
  properties: {
    addressPrefix: subnetAddressPrefix
    privateEndpointNetworkPolicies: 'disabled'
    networkSecurityGroup: {
      id: empty(networkSecurityGroupId) ? null : networkSecurityGroupId
    }
  }
}

output subnetId string = subnet.id
