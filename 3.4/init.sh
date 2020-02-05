OSMFILE=$1
PGDIR=$2
THREADS=$3

mkdir -p /data/$PGDIR && \

chown postgres:postgres /data/$PGDIR && \

export  PGDATA=/data/$PGDIR  && \
sudo -u postgres /usr/lib/postgresql/11/bin/initdb -D /data/$PGDIR && \
sudo -u postgres /usr/lib/postgresql/11/bin/pg_ctl -D /data/$PGDIR start && \
# set data_directory in config for psql - delete current entry and add new one
sed -i '/^data_directory/d' /etc/postgresql/11/main/postgresql.conf && \
echo "data_directory = '/data/$PGDIR'" >> /etc/postgresql/11/main/postgresql.conf && \
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

sudo -u postgres /usr/lib/postgresql/11/bin/pg_ctl -D /data/$PGDIR stop && \
sed -i '/^data_directory/d' /etc/postgresql/11/main/postgresql.conf && \
sudo chown -R postgres:postgres /data/$PGDIR
