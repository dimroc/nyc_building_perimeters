class THREEJS::Encoder
  class << self
    def generate(geometry, offset, scale)
      return nil unless geometry

      model = THREEJS::Encoder.model_from_geometry(geometry)
      model = THREEJS::Encoder.offset_model(model, offset, scale)

      outlines = THREEJS::Encoder.outlines(geometry)
      outlines = THREEJS::Encoder.offset_outlines(outlines, offset, scale)

      { model: model, outlines: outlines, scale: scale, offset: offset }
    end

    def outlines(geometry)
      return nil unless geometry

      coerce_to_geometries(geometry).map do |geometry|
        ring = geometry.exterior_ring
        outline = ring.points.flat_map { |point| [point.x, point.y] }
      end
    end

    def model_from_geometry(geometry)
      return nil unless geometry

      models = coerce_to_geometries(geometry).map do |geometry|
        triangles = triangulate(geometry)
        create_model_from_triangles(triangles)
      end

      converge_models(models)
    end

    def offset_model(model, offset, scale)
      offset = Hashie::Mash.new(offset)
      vertices = model[:vertices].map { |coordinate| coordinate * scale }

      model[:vertices] = []
      vertices.each_with_index do |coordinate, index|
        if index % 3 == 0 # X COORDINATE
          model[:vertices] << coordinate + (offset.x ? offset.x * scale : 0)
        elsif (index-1) % 3 == 0 # Y COORDINATE
          model[:vertices] << coordinate + (offset.y ? offset.y * scale : 0)
        else
          model[:vertices] << coordinate + (offset.z ? offset.z * scale : 0)
        end
      end

      model
    end

    def offset_outlines(outlines, offset, scale)
      outlines.map { |outline| offset_outline outline, offset, scale }
    end

    private

    def offset_outline(vertices, offset, scale)
      # Outline is 2D
      output = []
      offset = Hashie::Mash.new(offset)
      vertices.each_with_index do |coordinate, index|
        coordinate *= scale

        if index.even?
          output << coordinate + (offset.x ? offset.x * scale : 0)
        else
          output << coordinate + (offset.y ? offset.y * scale : 0)
        end
      end

      output
    end

    def converge_models(models)
      final = template

      models.each do |model|
        current_vertex_offset = final[:vertices].count / 3

        final[:faces].concat offset_faces(model[:faces], current_vertex_offset)
        final[:vertices].concat model[:vertices]
      end
      final
    end

    def offset_faces(faces, offset)
      amended_faces = []
      faces.each_with_index do |face, index|
        # Skip over shape identifier, which is every 4th entry starting at 0
        if index % 4 == 0
          amended_faces << face
        else
          amended_faces << face + offset
        end
      end

      amended_faces
    end

    def create_model_from_triangles(triangles)
      model = template

      triangles.each_with_index do |triangle, triangle_index|
        # example triangle: [[-8, 4], [-8, 5], [-4, 4]]

        triangle.each_with_index do |point, point_index|
          index = point_index * 3 + triangle_index * 9
          model[:vertices].push(point[0], point[1], 0)
        end

        index = triangle_index * 3
        # mark face type as triangle with 0
        model[:faces].push(0, index, index + 1, index + 2)
      end

      model
    end

    def coerce_to_geometries(geometry)
      # Handle multipolygons as well as polygons
      geometries = geometry.respond_to?(:geometry_n) ? geometry : [geometry]
      geometries
    end

    # Crashes if there are any repeated points!
    # Shouldn't be possible with shapefile geometries of NYC
    def triangulate(geometry)
      ring = geometry.exterior_ring

      input = ring.points.map { |point| [point.x, point.y] }
      input.pop if input.first == input.last

      cdt = Poly2Tri::CDT.new(input)
      cdt.triangulate!
      cdt.triangles
    end

    def template
      {
        metadata: { formatVersion: 3.1, generatedBy: "NewBlockCity" },

        materials: [],
        vertices:  [],
        normals:   [],
        colors:    [],
        uvs:       [],
        faces:     []
      }
    end
  end
end
