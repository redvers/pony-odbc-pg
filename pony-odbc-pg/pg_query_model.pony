use "pony-odbc"
use "pony-odbc/ctypes"
use "pony-odbc/attributes"
use "pony-odbc/instrumentation"

trait PgQueryModel
  fun sql(): (String val | SQLReturn val)
  fun ref bind_params(h: ODBCHandleStmt tag, i: PgQueryParamsIn): SQLReturn val
  fun ref bind_columns(i: PgQueryParamsIn): SQLReturn val


interface PgQueryParamsIn

interface PgQueryParamsOut
