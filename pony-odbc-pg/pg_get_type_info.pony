use "debug"
use "pony-odbc"

class PgGetTypeInfo is PgQueryModel
  var valid: Bool = true
  var err: SQLReturn val = SQLSuccess

  fun sql(): (String val | SQLReturn val) =>
    Debug.out("PgGetTypeInfo Override")
    SQLSuccess

  fun ref bind_params(i: PgQueryParamsIn): SQLReturn val =>
    match consume i
    | let x: PgGetTypeInfoIn =>
      err = x.h.get_type_info(x.a)
      set_valid(err)
    else
      err = PonyDriverError
      set_valid(err)
    end
    err

  fun ref bind_columns(i: PgQueryParamsOut): SQLReturn val =>
    match i
    | let x: PgGetTypeInfoOut =>
      Debug.out("Assigning PgGetTypeInfoOut")
      err = x.column_size.bind_column(x.h, 3)
      set_valid(err)
    else
      err = PonyDriverError
      set_valid(err)
    end
    err



  fun is_valid(): Bool => valid

  fun ref set_valid(sqlr: SQLReturn val): Bool =>
    match sqlr
    | let x: SQLSuccess val => valid = true ; return true
    | let x: SQLSuccessWithInfo val => valid = true ; return true
    else
      valid = false ; return false
    end


