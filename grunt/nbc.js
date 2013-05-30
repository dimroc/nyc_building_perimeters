var BuildingExporter = require('./buildingExporter')
var NeighborhoodExporter = require('./neighborhoodExporter')

module.exports = function(grunt) {
  grunt.registerTask('exportBuildings', 'Converts Building GeoJSON to THREEjs', function() {
    var buildingExporter = new BuildingExporter();
    buildingExporter.parseAll();
  });

  grunt.registerTask('exportNeighborhoods', 'Converts Neighborhood outline GeoJSON to THREEjs', function() {
    var neighborhoodExporter = new NeighborhoodExporter();
    neighborhoodExporter.exportBatch();
    neighborhoodExporter.exportShapes();
  });
};
