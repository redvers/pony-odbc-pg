use "debug"
use "pony-odbc"
use "../../pony-odbc-pg"

class iso ExampleStmtA is PgStmtNotify
  var stmt: (PgStmt ref | None) = None
  let statement: String val = "select 42::int4"
  let col1: CBoxedI32 = CBoxedI32

  fun ref prepare(stmt': PgStmt ref): SQLReturn val =>
    stmt = stmt'
    try
      var rv: SQLReturn val = (stmt as PgStmt ref).prepare(statement, SQLSuccess)
      (stmt as PgStmt ref).bind_col_i32(1, col1, rv)
    else
      PonyDriverError
    end

  fun fetch(prev: SQLReturn val) =>
    Debug.out("Got value: " + col1.value.string())
    Debug.out(prev.string())
    prev
