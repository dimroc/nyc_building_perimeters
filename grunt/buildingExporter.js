// Node REQUIRES
var THREE = require('three');
var _ = require('underscore');
var GeometryExporter = require('./geometryExporter');
var MeshFactory = require('./meshFactory');
var fs = require('fs');
var PATH = require('path');

// Constructor
var BuildingExporter = function(options) {
  options = options || {};
  _.defaults(options, {
    inputPath: "./public/static/neighborhoods",
    outputPath: "./public/static/threejs"
  });

  this.outputPath = options.outputPath;
  this.inputPath = options.inputPath;

  if (!fs.existsSync(this.outputPath)) {
    fs.mkdirSync(this.outputPath);
  }
};

// Member functions
_.extend(BuildingExporter.prototype, {

  // List of files to export
  buildingsToExport: function() {
    var paths = fs.readdirSync(this.inputPath);
    var matchingPaths = _(paths).select(function(p) {
      return p.match(/\.*json$/)
    });

    return _(matchingPaths).map(function(p) {
      return PATH.join(this.inputPath, p);
    }, this);
  },

  parse: function(arg) {
    console.log("* Exporting buildings at " + arg);

    var building = JSON.parse(fs.readFileSync(arg));
    var geoms = MeshFactory.generateFromGeoJson(building);
    var mergedGeom = MeshFactory.mergeMeshes(geoms);

    var geomExporter = new GeometryExporter();
    var exported3js = geomExporter.parse(mergedGeom);

    fs.writeFileSync(
      PATH.join(this.outputPath, PATH.basename(arg)),
      JSON.stringify(exported3js)
    );
  },

  parseAll: function() {
    _(this.buildingsToExport()).each(function(arg) {
      this.parse(arg);
    }, this);
  }
});

module.exports = BuildingExporter;

//var be = new BuildingExporter();
//be.parseAll();
