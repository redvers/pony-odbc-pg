use "debug"
use "pony-odbc"

actor PgDbc
  let pgdbcnotify: PgDbcNotify ref
  let dbc: ODBCHandleDbc

  new create(pgdbcnotify': PgDbcNotify iso) =>
    pgdbcnotify = consume pgdbcnotify'

    (var rv: SQLReturn val, var dbc': ODBCHandleDbc) = ODBCHandleDbcs.alloc(pgdbcnotify.get_pgenv())
    dbc = dbc'
    match rv
    | let x: SQLSuccess val => set_application_name(pgdbcnotify.get_appname())
    | let x: SQLSuccessWithInfo val => set_application_name(pgdbcnotify.get_appname())
    | let x: SQLError val => pgdbcnotify.pg_connection_failed(x)
    | let x: SQLInvalidHandle val => pgdbcnotify.pg_connection_failed(x)
    else
      pgdbcnotify.pg_connection_failed(PonyDriverError)
    end


  fun ref set_application_name(appname: String val) =>
    match dbc.set_application_name(appname)
    | let x: SQLSuccess val => start_connection()
    | let x: SQLSuccessWithInfo val => start_connection()
    | let x: SQLError val => pgdbcnotify.pg_connection_failed(x)
    | let x: SQLInvalidHandle val => pgdbcnotify.pg_connection_failed(x)
    else
      pgdbcnotify.pg_connection_failed(PonyDriverError)
    end


  fun ref start_connection() =>
    match dbc.connect(pgdbcnotify.get_dsn())
    | let x: SQLSuccess val => pgdbcnotify.pg_connected(x, this)
    | let x: SQLSuccessWithInfo val => pgdbcnotify.pg_connected(x, this)
    | let x: SQLError val => pgdbcnotify.pg_connection_failed(x)
    | let x: SQLInvalidHandle val => pgdbcnotify.pg_connection_failed(x)
    else
      pgdbcnotify.pg_connection_failed(PonyDriverError)
    end

  fun ref prepare(pgstmtnotify: PgStmtNotify iso): (SQLReturn val, PgStmt) =>
    (var rv: SQLReturn val, var stmt: ODBCHandleStmt iso) = ODBCHandleStmts.alloc(dbc)
    match rv
    | let x: SQLSuccess val => (rv, PgStmt(consume pgstmtnotify, dbc, consume stmt))
    | let x: SQLSuccessWithInfo val => (rv, PgStmt(consume pgstmtnotify, dbc, consume stmt))
    else
      (rv, PgStmt.none(consume pgstmtnotify))
    end





