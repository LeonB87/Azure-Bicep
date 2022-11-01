param location string

/// Virtual Machine
param name string
param osName string

param osUsername string
@secure()
param osUserPassword string
param size string = 'Standard_B2ms'

@description('The Windows version for the VM. This will pick a fully patched image of this given Windows version.')
@allowed([
  '2008-R2-SP1'
  '2008-R2-SP1-smalldisk'
  '2012-Datacenter'
  '2012-datacenter-gensecond'
  '2012-Datacenter-smalldisk'
  '2012-datacenter-smalldisk-g2'
  '2012-Datacenter-zhcn'
  '2012-datacenter-zhcn-g2'
  '2012-R2-Datacenter'
  '2012-r2-datacenter-gensecond'
  '2012-R2-Datacenter-smalldisk'
  '2012-r2-datacenter-smalldisk-g2'
  '2012-R2-Datacenter-zhcn'
  '2012-r2-datacenter-zhcn-g2'
  '2016-Datacenter'
  '2016-datacenter-gensecond'
  '2016-datacenter-gs'
  '2016-Datacenter-Server-Core'
  '2016-datacenter-server-core-g2'
  '2016-Datacenter-Server-Core-smalldisk'
  '2016-datacenter-server-core-smalldisk-g2'
  '2016-Datacenter-smalldisk'
  '2016-datacenter-smalldisk-g2'
  '2016-Datacenter-with-Containers'
  '2016-datacenter-with-containers-g2'
  '2016-datacenter-with-containers-gs'
  '2016-Datacenter-zhcn'
  '2016-datacenter-zhcn-g2'
  '2019-Datacenter'
  '2019-Datacenter-Core'
  '2019-datacenter-core-g2'
  '2019-Datacenter-Core-smalldisk'
  '2019-datacenter-core-smalldisk-g2'
  '2019-Datacenter-Core-with-Containers'
  '2019-datacenter-core-with-containers-g2'
  '2019-Datacenter-Core-with-Containers-smalldisk'
  '2019-datacenter-core-with-containers-smalldisk-g2'
  '2019-datacenter-gensecond'
  '2019-datacenter-gs'
  '2019-Datacenter-smalldisk'
  '2019-datacenter-smalldisk-g2'
  '2019-Datacenter-with-Containers'
  '2019-datacenter-with-containers-g2'
  '2019-datacenter-with-containers-gs'
  '2019-Datacenter-with-Containers-smalldisk'
  '2019-datacenter-with-containers-smalldisk-g2'
  '2019-Datacenter-zhcn'
  '2019-datacenter-zhcn-g2'
  '2022-datacenter'
  '2022-datacenter-azure-edition'
  '2022-datacenter-azure-edition-core'
  '2022-datacenter-azure-edition-core-smalldisk'
  '2022-datacenter-azure-edition-smalldisk'
  '2022-datacenter-core'
  '2022-datacenter-core-g2'
  '2022-datacenter-core-smalldisk'
  '2022-datacenter-core-smalldisk-g2'
  '2022-datacenter-g2'
  '2022-datacenter-smalldisk'
  '2022-datacenter-smalldisk-g2'
])
param OSVersion string = '2022-datacenter-azure-edition'

//Availability Set
param availabilitySetId string = ''

/// Network
param subnetId string
param privateAddress string = ''
param requirePublicIP bool = false

param diskType string = 'StandardSSD_LRS'

module networkInterface '../network/networkInterface.bicep' = {
  name: '${name}-nic'
  params: {
    location: location
    nicName: '${name}-nic'
    privateIPAddress: empty(privateAddress) ? '' : privateAddress
    privateIPAllocationMethod: empty(privateAddress) ? 'Dynamic' : 'Static'
    subnetId: subnetId
    requirePublicIP: requirePublicIP
  }
}

resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: size
    }
    osProfile: {
      computerName: osName
      adminUsername: osUsername
      adminPassword: osUserPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        name: '${name}-disk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: diskType
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.outputs.networkInterfaceId
        }
      ]
    }
    availabilitySet: {
      id: empty(availabilitySetId) ? null : availabilitySetId
    }
  }
}

output externalIp string = networkInterface.outputs.networkInterfacePublicIP
output internalIP string = networkInterface.outputs.networkInterfacePrivateIP
