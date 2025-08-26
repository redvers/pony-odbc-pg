use "pony-odbc"

interface tag PgDbcClient
  be pg_connected(rv: SQLReturn val) => None
  be pg_connection_failed(rv: SQLReturn val) => None
