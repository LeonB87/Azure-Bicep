targetScope = 'subscription'
param location string = 'westeurope'
// add template spec

module webapp 'ts/coreSpecs:DotNetWebApp:0.0.2' = {
  name: 'test'
  params: {
    resourcegroupname: 'rg-webapp-02'
  }
}
