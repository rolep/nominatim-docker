<?php
// Only import administrative boundaries and places.
@define('CONST_Import_Style', CONST_BasePath.'/settings/import-'.(getenv('NOMINATIM_IMPORT_STYLE') ? getenv('NOMINATIM_IMPORT_STYLE') : 'full').'.style');
// If you plan to import a large dataset (e.g. Europe, North America, planet), you should also enable flatnode storage of node locations. With this setting enabled, node coordinates are stored in a simple file instead of the database. This will save you import time and disk storage.
@define('CONST_Osm2pgsql_Flatnode_File', null);
@define('CONST_Use_Extra_US_Postcodes', false);
@define('CONST_Website_BaseURL', getenv('NOMINATIM_BASE_URL') ? getenv('NOMINATIM_BASE_URL') : 'http://'.php_uname('n').'/');
@define('CONST_Database_DSN', getenv('NOMINATIM_DB_DSN') ? getenv('NOMINATIM_DB_DSN') : (getenv('NOMINATIM_DB_REMOTE') ? 'pgsql://nominatim:password1234@nominatim:5432/nominatim' : 'pgsql:dbname=nominatim'));
