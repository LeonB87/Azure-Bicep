param nicName string
param location string

param subnetId string

@allowed([
  'Dynamic'
  'Static'
])
param privateIPAllocationMethod string
param privateIPAddress string

param requirePublicIP bool = false

param NetworkSecurityGroupId string = ''

resource publicIP 'Microsoft.Network/publicIPAddresses@2022-05-01' = if (requirePublicIP) {
  name: '${nicName}-pip'
  location: location
  properties: {
    publicIPAllocationMethod: 'static'
  }
  sku: {
    name: 'Standard'
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2022-05-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: nicName
        properties: {
          privateIPAllocationMethod: privateIPAllocationMethod
          privateIPAddress: (privateIPAllocationMethod == 'Dynamic') ? null : privateIPAddress
          subnet: {
            id: subnetId
          }
          publicIPAddress: (requirePublicIP) ? {
            id: publicIP.id
          } : null
        }
      }
    ]
  }
}

output networkInterfaceId string = networkInterface.id
output networkInterfacePrivateIP string = networkInterface.properties.ipConfigurations[0].properties.privateIPAddress
output networkInterfacePublicIP string = requirePublicIP ? publicIP.properties.ipAddress : 'n/a'
