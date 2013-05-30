class Neighborhood < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_and_belongs_to_many :neighbors,
    class_name: "Neighborhood",
    join_table: :neighborhood_neighbors,
    association_foreign_key: :neighbor_id

  serialize :threejs, Hash

  validates_presence_of :name, :borough, :geometry, :slug

  class << self
    def intersects(geom)
      raise ArgumentError, "Must have SRID 3785" unless geom.srid == 3785

      where(<<-SQL, geom.as_text)
        ST_Intersects(ST_AsText(neighborhoods.geometry), ?)
      SQL
    end
  end

  def neighborhoods_with_intersecting_geometry
    Neighborhood.intersects(geometry).where('id != ?', id)
  end

  def building_perimeters
    JSON.parse(building_perimeters_json)
  end

  def building_perimeters_json
    raise StandardError, "Neighborhood must be persisted" unless persisted?

    # We only retrieve the first polygon of the building_perimeters table
    # MultiPolygon when collecting all the building perimeters.
    # This way, we can return one MultiPolygon.
    rval = ActiveRecord::Base.connection.execute(<<-SQL)
    CREATE TEMP TABLE temp_building_perimeters ON COMMIT DROP AS
      (SELECT ST_GeometryN(bp.geom, 1) perimeter FROM building_perimeters bp, neighborhoods n
        WHERE ST_Intersects(bp.geom, n.geometry) = true AND n.id = #{id});

    SELECT ST_AsGeoJSON(ST_Collect(perimeter)) FROM temp_building_perimeters;
    SQL

    rval.values[0][0]
  end

  def as_json(opts = {})
    hash = super(opts)
    hash.merge!('geometry' => RGeo::GeoJSON.encode(geometry)) if hash['geometry']
    hash.merge!('neighborIds' => neighbors.map(&:id))
    hash
  end
end
