use "debug"
use ".."
use "pony-odbc"
use "pony-odbc/env"
use "pony-odbc/dbc"
use "pony-odbc/stmt"
use "pony-odbc/ctypes"
use "pony-odbc/attributes"
use "pony-odbc/instrumentation"

class \nodoc\ _PCMInI is PgQueryParamsIn
  var integera: PgInteger = PgInteger(0)

class \nodoc\ _PCMOutI is PgQueryParamsOut
  var integer: PgInteger = PgInteger(0)

class \nodoc\ _PCMResultI is PgResultOut
  var integer: I32 = 0

class \nodoc\ iso _TestIntegerModel is PgQueryModel
  var err: SQLReturn val = SQLSuccess
  var pin: _PCMInI = _PCMInI
  var pout: _PCMOutI = _PCMOutI
  var result: _PCMResultI = _PCMResultI

  fun sql(): String val => "select * from integer_tests where i >= ?"

  fun ref bind_params(h: ODBCHandleStmt tag): SQLReturn val => SQLSuccess
    err = pin.integera.bind_parameter(h, 1)
    if (not is_success()) then return err end
    err

  fun ref execute[A: Any val](h: ODBCHandleStmt tag, i: A): SQLReturn val =>
    match i
    | let x: I32 => pin.integera.v.value = x
    else
      err = PonyDriverError
    end
    err

  fun ref bind_columns(h: ODBCHandleStmt tag): SQLReturn val =>
    err = pout.integer.bind_column(h, 1, "i")
    err

  fun ref fetch(h: ODBCHandleStmt tag): (SQLReturn val, _PCMResultI) =>
    err = ODBCStmtFFI.fetch(h)
    if (not is_success()) then return (err, result) end

    result.integer = pout.integer.native()
    (err, result)

  fun is_success(): Bool =>
    match err
    | let x: SQLSuccess => true
    else
      false
    end
