param paranetVnetName string

param subnetName string

resource parent_vnet 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: paranetVnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  name: subnetName
  parent: parent_vnet
  properties: {
    addressPrefix: '10.10.1.0/24'
  }
}
