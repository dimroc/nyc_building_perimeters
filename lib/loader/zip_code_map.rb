class Loader::ZipCodeMap
  class << self
    def from_socrata(socrata_file)
      Socrata::Loader.new(File.read(socrata_file)).each do |row|
        build_from_row(row).save!
      end
    end

    def build_from_row(row)
      shape = Socrata::Shape.new(row[9])
      zip_code_map = ZipCodeMap.new(
        zip: row[10],
        po_name: row[11],
        county: row[13],
        point: shape.point.projection,
        geometry: shape.geometry.projection,
        shape_length: row[17],
        shape_area: row[18])

      zip_code_map.id = row[0]
      zip_code_map
    end
  end
end
