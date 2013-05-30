class World < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged

  has_many :regions, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :slug

  def as_json(options={})
    # Opted for manual merge rather than
    # passing regions: { only: :name } for performance with region queries.
    region_names = regions.map(&:slug)
    includes = {
      region_names: region_names,
      mercator_bounding_box: mercator_bounding_box_as_json,
      mesh_bounding_box: mesh_bounding_box_as_json,
    }

    final_options = {
      only: [:id, :name, :slug, :mesh_scale],
      except: [:created_at, :updated_at]
    }.merge options
    super(final_options).merge(includes)
  end

  def contains?(point)
    regions.any? { |region| region.contains? point }
  end

  def generate_bounding_box
    bb = Cartesian::BoundingBox.new(Mercator::FACTORY.projection_factory)
    bounding_boxes = regions.each do |region|
      bb.add(region.generate_bounding_box)
    end
    bb
  end

  def generate_mesh_bounding_box
    bb = Cartesian::BoundingBox.new(Cartesian::preferred_factory())
    outlines = regions.map(&:threejs).map { |threejs| threejs[:outlines] }.flatten

    outlines.each_slice(2) do |slice|
      point = Cartesian::preferred_factory().point(slice[0], slice[1])
      bb.add point
    end

    bb
  end

  private

  def mercator_bounding_box_as_json
    bb = Cartesian::BoundingBox.new(Mercator::FACTORY.projection_factory())
    bb.add mercator_bounding_box_geometry
    bounding_box_as_json bb
  end

  def mesh_bounding_box_as_json
    bb = Cartesian::BoundingBox.new(Cartesian::preferred_factory())
    bb.add mesh_bounding_box_geometry
    bounding_box_as_json bb
  end

  def bounding_box_as_json(bb)
    mash = Hashie::Mash.new bb.as_json
    mash.slice(:min_x, :min_y, :max_x, :max_y).as_json
  end
end
