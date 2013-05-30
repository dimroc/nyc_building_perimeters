ActiveRecord::Base.connection.execute(<<-SQL) #postgres specific
TRUNCATE zip_code_maps RESTART IDENTITY;
SQL

Loader::ZipCodeMap.from_socrata('db/data/ZipCodeMaps.json')
