use "debug"
use "pony-odbc"
use "../../pony-odbc-pg"
use "pony-odbc/ctypes"
use "pony-odbc/attributes"
use "pony-odbc/instrumentation"



class iso ExampleSQL1 is PgQueryModel
  var valid: Bool = true
  fun sql(): String val => "select name, setting, category from pg_settings where name = ?"

  fun ref bind_params(h: ODBCHandleStmt tag, i: PgQueryParamsIn): SQLReturn val =>
    match consume i
    | let x: ExIn1 =>
      x.a.bind_parameter(h, 1)
    else
      valid = false
      PonyDriverError
    end

  fun ref bind_columns(i: PgQueryParamsOut): SQLReturn val =>
    Debug.out("Stmt.bind_columns")
    SQLSuccess



class ExIn1 is PgQueryParamsIn
  var a: PgVarchar

  new iso create(size: USize) =>
    a = PgVarchar(size)

class ExOut1
  var a: PgVarchar = PgVarchar(4096)
  var b: PgVarchar = PgVarchar(4096)
  var c: PgVarchar = PgVarchar(4096)


