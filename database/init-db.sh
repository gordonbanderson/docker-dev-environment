createdb -U postgres foodkitapi \
    && psql -U postgres -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;" foodkitapi
