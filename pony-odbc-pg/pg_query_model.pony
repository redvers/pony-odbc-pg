use "pony-odbc"

trait PgQueryModel
  fun sql(): (String val | SQLReturn val)
  fun ref bind_params(i: PgQueryParamsIn): SQLReturn val
  fun ref bind_columns(i: PgQueryParamsIn): SQLReturn val


interface PgQueryParamsIn

interface PgQueryParamsOut
