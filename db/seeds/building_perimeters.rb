if ActiveRecord::Base.connection.table_exists? 'building_perimeters'
  ActiveRecord::Base.connection.execute(<<-SQL)
  DROP TABLE building_perimeters;
  SQL
end

sql_file =
  Rails.root.join("db", "data", "building_perimeters.sql").to_s

config = Rails.configuration.database_configuration
database = config[Rails.env]["database"]

`cat #{sql_file} | psql #{database}`
