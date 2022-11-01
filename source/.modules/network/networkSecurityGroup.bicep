param location string
param name string

param nsgRules array = [
  {
    name: 'deny-hop-outbound'
    properties: {
      priority: 200
      access: 'Deny'
      protocol: 'Tcp'
      direction: 'Outbound'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: '*'
      destinationPortRanges: [
        '3389'
        '22'
      ]
    }
  }
  {
    name: 'DenyAllInbound'
    properties: {
      description: 'Deny all other inbound traffic.'
      access: 'Deny'
      direction: 'Inbound'
      priority: 4000
      protocol: '*'
      sourcePortRange: '*'
      sourceAddressPrefix: '*'
      destinationPortRange: '*'
      destinationAddressPrefix: '*'
    }
  }
]

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: name
  location: location
  properties: {
    securityRules: nsgRules
  }
}

output Id string = networkSecurityGroup.id
