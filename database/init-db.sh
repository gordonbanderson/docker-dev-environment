createdb -U postgres gis \
    && psql -U postgres -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;" gis
