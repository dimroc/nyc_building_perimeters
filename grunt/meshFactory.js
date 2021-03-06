var THREE = require('three');
var _ = require('underscore');

// Generated by CoffeeScript 1.6.2
var fallbackMercatorToWorld, projectPoint, projectRing;

var MeshFactory = (function() {
  function MeshFactory() {}

  MeshFactory.shapesFromGeoJson = function(geoJson) {
    if (geoJson.type != "MultiPolygon") throw "Not a MultiPolgyon"
    var coordinates = geoJson.coordinates;
    var geoms, polygon;

    geoms = (function() {
      var _i, _len, _results;

      _results = [];
      for (_i = 0, _len = coordinates.length; _i < _len; _i++) {
        polygon = coordinates[_i];
        _results.push(MeshFactory.shapeFromPolygon(polygon));
      }
      return _results;
    })();

    return _(geoms).flatten();
  };

  MeshFactory.shapeFromPolygon = function(polygon) {
    var hole, shape;

    shape = new THREE.Shape(projectRing(polygon[0]));
    shape.holes = (function() {
      var _i, _len, _ref, _results;

      _ref = polygon.slice(1);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        hole = _ref[_i];
        _results.push(new THREE.Shape(projectRing(hole)));
      }
      return _results;
    })();

    return new THREE.ShapeGeometry(shape);
  }

  MeshFactory.generateFromGeoJson = function(geoJson, options) {
    switch (geoJson.type) {
      case "MultiPolygon":
        return MeshFactory.generateFromMultiPolygon(geoJson.coordinates, options);
      default:
        throw "Cannot generate line from GeoJSON type " + geoJson.type;
    }
  };

  MeshFactory.generateFromMultiPolygon = function(coordinates, options) {
    var geoms, polygon;

    geoms = (function() {
      var _i, _len, _results;

      _results = [];
      for (_i = 0, _len = coordinates.length; _i < _len; _i++) {
        polygon = coordinates[_i];
        _results.push(MeshFactory.generateFromPolygon(polygon, options));
      }
      return _results;
    })();
    return _(geoms).flatten();
  };

  MeshFactory.generateFromPolygon = function(polygon, options) {
    var extrudeOptions, hole, shape;

    options = options || {};
    _.defaults(options, {
      extrude: 0.1,
      ignoreLidFaces: false
    });
    shape = new THREE.Shape(projectRing(polygon[0]));
    shape.holes = (function() {
      var _i, _len, _ref, _results;

      _ref = polygon.slice(1);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        hole = _ref[_i];
        _results.push(new THREE.Shape(projectRing(hole)));
      }
      return _results;
    })();
    extrudeOptions = {
      amount: options.extrude,
      bevelEnabled: false,
      ignoreLidFaces: options.ignoreLidFaces
    };
    return new THREE.ExtrudeGeometry(shape, extrudeOptions);
  };

  MeshFactory.mergeMeshes = function(geoms) {
    var geometry;

    geometry = new THREE.Geometry();
    _(geoms).each(function(geom) {
      return THREE.GeometryUtils.merge(geometry, geom);
    });
    return geometry;
  };

  return MeshFactory;

})();

projectRing = function(ring) {
  return _(ring).map(projectPoint);
};

projectPoint = function(coord) {
  var point;

  point = {
    x: coord[0],
    y: coord[1]
  };
  return fallbackMercatorToWorld(point);
};

fallbackMercatorToWorld = function(point) {
  var x, y;

  x = (point.x - -8266094.619172799) * 0.00142857142857143;
  y = (point.y - 4910511.427062279) * 0.00142857142857143;
  return new THREE.Vector3(x, y, 0);
};

module.exports = MeshFactory;
