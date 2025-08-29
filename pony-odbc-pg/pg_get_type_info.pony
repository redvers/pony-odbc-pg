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
      err = x.column_size.bind_column(x.h, 0)
      err = x.column_size.bind_column(x.h, 1)
      err = x.column_size.bind_column(x.h, 2)
      err = x.column_size.bind_column(x.h, 3)
      err = x.column_size.bind_column(x.h, 4)
      err = x.column_size.bind_column(x.h, 5)
      err = x.column_size.bind_column(x.h, 6)
      err = x.column_size.bind_column(x.h, 7)
      err = x.column_size.bind_column(x.h, 8)
      err = x.column_size.bind_column(x.h, 9)
      err = x.column_size.bind_column(x.h, 10)
      err = x.column_size.bind_column(x.h, 11)
      err = x.column_size.bind_column(x.h, 12)
      err = x.column_size.bind_column(x.h, 13)
      err = x.column_size.bind_column(x.h, 14)
      err = x.column_size.bind_column(x.h, 15)
      err = x.column_size.bind_column(x.h, 16)
      err = x.column_size.bind_column(x.h, 17)
      err = x.column_size.bind_column(x.h, 18)
      err = x.column_size.bind_column(x.h, 19)
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


