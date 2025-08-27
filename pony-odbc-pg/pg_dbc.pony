use "debug"
use "pony-odbc"

actor PgDbc
  let he: PgEnv tag
  let dbc: ODBCHandleDbc
  let dsn: String val
  let dbcclient: PgDbcClient tag

  new create(he': PgEnv tag, appname: String val, dsn': String val, dbcclient': PgDbcClient tag) =>
    he = he'
    dsn = dsn'
    dbcclient = dbcclient'

    (var rv: SQLReturn val, var dbc': ODBCHandleDbc) = ODBCHandleDbcs.alloc(he)
    dbc = dbc'
    match rv
    | let x: SQLSuccess val => set_application_name(appname)
    | let x: SQLSuccessWithInfo val => set_application_name(appname)
    | let x: SQLError val => dbcclient.pg_connection_failed(x)
    | let x: SQLInvalidHandle val => dbcclient.pg_connection_failed(x)
    else
      PonyDriverError
    end

  fun set_application_name(appname: String val) =>
    match dbc.set_application_name(appname)
    | let x: SQLSuccess val => start_connection()
    | let x: SQLSuccessWithInfo val => start_connection()
    | let x: SQLError val => dbcclient.pg_connection_failed(x)
    | let x: SQLInvalidHandle val => dbcclient.pg_connection_failed(x)
    else
      dbcclient.pg_connection_failed(PonyDriverError)
    end

  fun start_connection() =>
    match dbc.connect(dsn)
    | let x: SQLSuccess val => dbcclient.pg_connected(x, this, dbc)
    | let x: SQLSuccessWithInfo val => dbcclient.pg_connected(x, this, dbc)
    | let x: SQLError val => dbcclient.pg_connection_failed(x)
    | let x: SQLInvalidHandle val => dbcclient.pg_connection_failed(x)
    else
      dbcclient.pg_connection_failed(PonyDriverError)
    end


