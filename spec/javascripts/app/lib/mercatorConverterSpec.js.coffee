describe "MercatorConverter", ->
  describe ".ll2m", ->
    it "should convert from longlat to mercator", ->
      long = -72.0
      lat = 49.0
      expectation = { x: -8015003.337115697, y: 6242595.999953201 }
      expect(MercatorConverter.ll2m(long, lat).x).toEqual(expectation.x)
      expect(MercatorConverter.ll2m(long, lat).y).toEqual(expectation.y)

  describe ".m2ll", ->
    it "should convert from mercator to longlat", ->
      mercator_x = -8015003.337115697
      mercator_y = 6242595.999953201
      expectation = { lon: -72.0, lat: 49.0 }

      expect(MercatorConverter.m2ll(mercator_x, mercator_y).lon.toFixed(2))
        .toEqual(expectation.lon.toFixed(2))
      expect(MercatorConverter.m2ll(mercator_x, mercator_y).lat.toFixed(0))
        .toEqual(expectation.lat.toFixed(0))
