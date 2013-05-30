# Initial draft taken from:
# http://wiki.openstreetmap.org/wiki/Mercator#JavaScript
window.MercatorConverter = (
  r_major: 6378137.0 #Equatorial Radius, WGS84
  r_minor: 6356752.314245179 #defined as constant
  f: 298.257223563 #1/f=(a-b)/a , a=r_major, b=r_minor
  deg2rad: (d) ->
    r = d * (Math.PI / 180.0)
    r

  rad2deg: (r) ->
    d = r / (Math.PI / 180.0)
    d

  ll2m: (lon, lat) -> #lat lon to mercator

    #lat, lon in rad
    x = @r_major * @deg2rad(lon)
    lat = 89.5  if lat > 89.5
    lat = -89.5  if lat < -89.5
    temp = @r_minor / @r_major
    es = 1.0 - (temp * temp)
    eccent = Math.sqrt(es)
    phi = @deg2rad(lat)
    sinphi = Math.sin(phi)
    con = eccent * sinphi
    com = .5 * eccent
    con2 = Math.pow((1.0 - con) / (1.0 + con), com)
    ts = Math.tan(.5 * (Math.PI * 0.5 - phi)) / con2
    y = 0 - @r_major * Math.log(ts)
    ret =
      x: x
      y: y

    ret

  m2ll: (x, y) -> #mercator to lat lon
    lon = @rad2deg((x / @r_major))
    temp = @r_minor / @r_major
    e = Math.sqrt(1.0 - (temp * temp))
    lat = @rad2deg(@pj_phi2(Math.exp(0 - (y / @r_major)), e))
    ret =
      lon: lon
      lat: lat

    ret

  pj_phi2: (ts, e) ->
    N_ITER = 15
    HALFPI = Math.PI / 2
    TOL = 0.0000000001
    eccnth = .5 * e
    phi = HALFPI - 2.0 * Math.atan(ts)
    i = N_ITER
    loop
      con = e * Math.sin(phi)
      dphi = HALFPI - 2.0 * Math.atan(ts * Math.pow((1.0 - con) / (1.0 + con), eccnth)) - phi
      phi += dphi
      break unless Math.abs(dphi) > TOL and --i
    phi
)
