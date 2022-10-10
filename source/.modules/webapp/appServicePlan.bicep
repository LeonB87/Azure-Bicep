param location string

param appServicePlanName string
param appServicePlanSkuName string = 'D1'

resource appServicePlan 'Microsoft.Web/serverFarms@2021-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

output appServicePlanId string = appServicePlan.id
