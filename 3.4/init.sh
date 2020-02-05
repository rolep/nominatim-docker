OSMFILE=$1
PGDIR=$2
THREADS=$3

sudo -u postgres /usr/lib/postgresql/11/bin/initdb && \
sudo -u postgres /usr/lib/postgresql/11/bin/pg_ctl start && \
# set data_directory in config for psql - delete current entry and add new one
sudo -u postgres psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='nominatim'" | grep -q 1 || sudo -u postgres createuser -s nominatim && \
sudo -u postgres psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='www-data'" | grep -q 1 || sudo -u postgres createuser -SDR www-data && \
sudo -u postgres psql postgres -c "DROP DATABASE IF EXISTS nominatim" && \
useradd -m -p password1234 nominatim && \
chown -R nominatim:nominatim ./src

if [ -n "$NOMINATIM_REVERSE_ONLY" ]; then
  sudo -u nominatim ./src/build/utils/setup.php --osm-file $OSMFILE --all --threads $THREADS --reverse-only
else
  sudo -u nominatim ./src/build/utils/setup.php --osm-file $OSMFILE --all --threads $THREADS
fi

sudo -u postgres /usr/lib/postgresql/11/bin/pg_ctl stop && \
sudo chown -R postgres:postgres $PGDATA
