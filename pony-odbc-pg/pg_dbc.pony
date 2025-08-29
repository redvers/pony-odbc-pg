use "debug"
use "pony-odbc"
use "pony-odbc/ctypes"
use "pony-odbc/attributes"
use "pony-odbc/instrumentation"

class PgDbc
  let dbc: ODBCHandleDbc tag
  let henv: PgEnv
  var err: SQLReturn val
  var valid: Bool = true

  new create(henv': PgEnv) =>
    henv = henv'

    (err, dbc) = ODBCHandleDbcs.alloc(henv.odbcenv)
    set_valid(err)

  fun ref set_application_name(appname: String val): Bool =>
    err = ODBCHandleDbcs.set_application_name(dbc, appname)
    set_valid(err)
    valid

  fun ref connect(dsn: String val): Bool =>
    err = ODBCHandleDbcs.connect(dbc, dsn)
    set_valid(err)
    valid

  fun is_valid(): Bool => valid

  fun ref set_valid(sqlr: SQLReturn val): Bool =>
    match sqlr
    | let x: SQLSuccess val => valid = true ; return true
    | let x: SQLSuccessWithInfo val => valid = true ; return true
    else
      valid = false ; return false
    end

