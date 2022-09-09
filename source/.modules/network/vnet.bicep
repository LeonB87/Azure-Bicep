param location string = resourceGroup().location
param vnetName string
param addressPrefix string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
  }
}

output networkResourceId string = virtualNetwork.id
