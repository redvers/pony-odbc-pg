use "pony-odbc"

class PgEnv
  let odbcenv: ODBCHandleEnv tag
  var err: SQLReturn val
  var valid: Bool = false

  new create() =>
    (err, odbcenv) = ODBCHandleEnvs.alloc()
    set_valid(err)

  fun ref set_odbc3(): Bool =>
    err = ODBCHandleEnvs.set_odbc3(odbcenv)
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
