#!/bin/bash

SHPFILE=$1

if [ -z $SHPFILE ]
then
  echo 'No shapefile. args: <shpfile>'
  exit
fi

shp2pgsql -c -D -s 3785 -I $SHPFILE public.building_perimeters  > building_perimeters.sql

# After creating .sql file, pipe it into psql
# eg: cat building_perimeters.sql | psql nbc_development
