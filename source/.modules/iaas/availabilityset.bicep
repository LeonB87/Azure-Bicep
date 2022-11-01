param name string
param location string

@maxValue(3)
@minValue(1)
param faultDomainCount int = 2

@minValue(1)
@maxValue(20)
param updateDomainCount int = 2

resource availabilityset 'Microsoft.Compute/availabilitySets@2022-08-01' = {
  name: name
  location: location
  sku: {
    name: 'Aligned'
  }
  properties: {
    platformFaultDomainCount: faultDomainCount
    platformUpdateDomainCount: updateDomainCount
  }
}

output availabilitySetId string = availabilityset.id
