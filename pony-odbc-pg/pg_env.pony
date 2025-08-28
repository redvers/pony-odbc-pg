use "pony-odbc"

class PgEnv
  let odbcenv: ODBCHandleEnv
  var err: SQLReturn val
  var valid: Bool = false

  new create() =>
    (err, odbcenv) = ODBCHandleEnvs.alloc()
    set_valid(err)

  fun ref set_odbc3(): Bool =>
    err = odbcenv.set_odbc3(err)
    set_valid(err)
    valid

  fun is_valid(): Bool => valid

  fun ref set_valid(sqlr: SQLReturn val) =>
    match err
    | let x: SQLSuccess val => valid = true
    | let x: SQLSuccessWithInfo val => valid = true
    else
      valid = false
    end
