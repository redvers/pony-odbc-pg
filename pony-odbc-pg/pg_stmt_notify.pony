use "pony-odbc"

interface iso PgStmtNotify

  fun ref prepare(stmt: PgStmt ref): SQLReturn val
  fun fetch(prev: SQLReturn val): None
