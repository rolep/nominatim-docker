OSMFILE=$1
THREADS=$3

if [ -n "$NOMINATIM_REVERSE_ONLY" ]; then
  sudo -u nominatim ./src/build/utils/setup.php \
    --osm-file $OSMFILE \
    -- all \
    --threads $THREADS \
    --reverse-only
else
  sudo -u nominatim ./src/build/utils/setup.php \
    --osm-file $OSMFILE \
    -- all \
    --threads $THREADS
fi

if [ -n "$DROP_ADTER_IMPORT" ]; then
  sudo -u nominatim ./src/build/utils/setup.php --drop
fi
