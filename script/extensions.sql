SELECT name, default_version,installed_version 
FROM pg_available_extensions WHERE name LIKE 'postgis%';

CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;

SELECT name, default_version,installed_version 
FROM pg_available_extensions WHERE name LIKE 'postgis%';
