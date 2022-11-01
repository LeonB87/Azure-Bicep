param location string
param name string

param nsgRules array = []

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: name
  location: location
  properties: {
    securityRules: nsgRules
  }
}

output Id string = networkSecurityGroup.id
