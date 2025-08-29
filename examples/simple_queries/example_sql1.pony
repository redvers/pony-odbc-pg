use "pony-odbc"
use "../../pony-odbc-pg"
use "pony-odbc/ctypes"
use "pony-odbc/attributes"
use "pony-odbc/instrumentation"



class iso ExampleSQL1 is PgQueryModel
  var valid: Bool = true
  fun sql(): String val => "select * from generate_series(?,?) num"

  fun ref bind_params(i: PgQueryParamsIn): SQLReturn val =>
    match consume i
    | let x: ExIn1 => SQLSuccess
//      x.a.bind_parameter(1)
    else
      valid = false
      PonyDriverError
    end

  fun ref bind_columns(i: PgQueryParamsOut): SQLReturn val => SQLSuccess

class ExIn1 is PgQueryParamsIn
  var a: PgInteger
  var b: PgInteger

  new iso create(a': I32, b': I32) =>
    a = PgInteger(a')
    b = PgInteger(b')

class ExOut1
  var a: I32 = 0



































