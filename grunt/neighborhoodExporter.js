// Node REQUIRES
var THREE = require('three');
var _ = require('underscore');
var GeometryExporter = require('./geometryExporter');
var MeshFactory = require('./meshFactory');
var fs = require('fs');
var PATH = require('path');

// Constructor
var NeighborhoodExporter = function(options) {
  options = options || {};
  _.defaults(options, {
    inputPath: "./public/static/neighborhoods.json",
    batchOutputPath: "./public/static/threejs/neighborhoodsBatch.json",
    shapeOutputPath: "./public/static/threejs/neighborhoodShapes.json"
  });

  this.batchOutputPath = options.batchOutputPath;
  this.shapeOutputPath = options.shapeOutputPath;
  this.inputPath = options.inputPath;

  var dir = PATH.dirname(this.batchOutputPath);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir);
  }
};

_.extend(NeighborhoodExporter.prototype, {
  exportBatch: function() {
    var neighborhoods = JSON.parse(fs.readFileSync(this.inputPath));

    var geoms = _(neighborhoods).map(function(n) {
      return MeshFactory.generateFromGeoJson(n.geometry, {ignoreLidFaces: true});
    });

    geoms = _(geoms).flatten();
    var mergedGeom = MeshFactory.mergeMeshes(geoms);

    var geomExporter = new GeometryExporter();
    var exported3js = geomExporter.parse(mergedGeom);

    fs.writeFileSync(this.batchOutputPath, JSON.stringify(exported3js));
  },

  exportShapes: function() {
    var neighborhoods = JSON.parse(fs.readFileSync(this.inputPath));

    var slugs = [];
    console.log("Neighborhood.exportShapes: Creating shapes from GeoJSON.");
    var geoms = _(neighborhoods).reduce(function(memo, n) {
      slugs.push(n.slug);
      memo[n.slug] = MeshFactory.shapesFromGeoJson(n.geometry);
      return memo;
    }, {});

    var geomExporter = new GeometryExporter();

    console.log("Neighborhood.exportShapes: Writing as THREE JS File Format.");
    var exported3js = _(slugs).reduce(function(memo, slug) {
      var shapes = _(geoms[slug]).flatten();
      var mergedGeom = MeshFactory.mergeMeshes(shapes);
      memo[slug] = geomExporter.parse(mergedGeom);
      return memo;
    }, {});

    fs.writeFileSync(this.shapeOutputPath, JSON.stringify(exported3js));
  }
});

module.exports = NeighborhoodExporter;

//var exporter = new NeighborhoodExporter();
//exporter.exportShapes();
