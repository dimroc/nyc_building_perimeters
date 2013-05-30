Factories.nycWorld = ->
  nyc = new App.World(Fixtures.worlds[0])
  nyc.fetchRegions()
  mostRecentAjaxRequest().response(Factories.nycRegionsResponse())
  nyc
