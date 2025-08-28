use "debug"
use "pony-odbc"

class PgDbc
  let dbc: ODBCHandleDbc
  let henv: PgEnv
  var err: SQLReturn val
  var valid: Bool = true

  new create(henv': PgEnv) =>
    henv = henv'

    (err, dbc) = ODBCHandleDbcs.alloc(henv.odbcenv)
    set_valid(err)

  fun ref set_application_name(appname: String val): Bool =>
    err = dbc.set_application_name(appname)
    set_valid(err)
    valid

  fun ref connect(dsn: String val) =>
    err = dbc.connect(dsn)
    set_valid(err)
    valid





    /*
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
*/




  fun is_valid(): Bool => valid

  fun ref set_valid(sqlr: SQLReturn val) =>
    match err
    | let x: SQLSuccess val => valid = true
    | let x: SQLSuccessWithInfo val => valid = true
    else
      valid = false
    end

