Factories.nycRegionsResponse = ->
    status: 200,
    responseText: JSON.stringify Fixtures.nyc

Factories.worldsResponse = ->
    status: 200,
    responseText: JSON.stringify Fixtures.worlds

Factories.errorResponse = ->
    status: 400,
    responseText: "Error Schmerror"
