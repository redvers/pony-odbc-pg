use "debug"
use ".."
use "pony-odbc"
use "pony-odbc/env"
use "pony-odbc/dbc"
use "pony-odbc/stmt"
use "pony-odbc/ctypes"
use "pony-odbc/attributes"
use "pony-odbc/instrumentation"

class \nodoc\ _PCMInS is PgQueryParamsIn
  var name: PgVarchar = PgVarchar.>alloc(2048)

class \nodoc\ _PCMOutSSS is PgQueryParamsOut
  var name: PgVarchar = PgVarchar.>alloc(8190)
  var setting: PgVarchar = PgVarchar.>alloc(8190)
  var category: PgVarchar = PgVarchar.>alloc(8190)

class \nodoc\ _PCMResultSSS is PgResultOut
  var name: String val = ""
  var setting: String val = ""
  var category: String val = ""

class \nodoc\ iso _TestMultipleParamsModel is PgQueryModel
  var err: SQLReturn val = SQLSuccess
  var pin: _PCMInS = _PCMInS
  var pout: _PCMOutSSS = _PCMOutSSS
  var result: _PCMResultSSS = _PCMResultSSS

  fun sql(): String val => "select name, setting, category, sourceline from pg_settings where name = ?"


  fun ref bind_params(h: ODBCHandleStmt tag): SQLReturn val => SQLSuccess
    err = pin.name.bind_parameter(h, 1)
    err

  fun ref execute[A: Any val](h: ODBCHandleStmt tag, i: A): SQLReturn val => SQLSuccess
    match i
    | (let x: String val) =>
      if (pin.name.write(x)) then
        err = SQLSuccess
      else
        err = PonyDriverError
      end
    else
      err = PonyDriverError
    end
    err

  fun ref bind_columns(h: ODBCHandleStmt tag): SQLReturn val =>
    err = pout.name.bind_column(h, 1, "name")
    if (not is_success()) then return err end
    err = pout.setting.bind_column(h, 2, "setting")
    if (not is_success()) then return err end
    err = pout.category.bind_column(h, 3, "category")
    if (not is_success()) then return err end
    err

  fun ref fetch(h: ODBCHandleStmt tag): (SQLReturn val, PgResultOut) =>
    err = ODBCStmt.fetch(h)
    if (not is_success()) then return (err, result) end

    result.name = pout.name.native()
    result.setting = pout.setting.native()
    result.category = pout.category.native()
    (err, result)

  fun is_success(): Bool =>
    match err
    | let x: SQLSuccess => true
    else
      false
    end
