
use "pony-odbc"

interface iso PgDbcNotify
  fun get_pgenv():   PgEnv tag
  fun get_appname(): String val
  fun get_dsn():     String val

  fun pg_connection_failed(err: SQLReturn val)
  fun ref pg_connected(err: SQLReturn val, dbc: PgDbc ref)

