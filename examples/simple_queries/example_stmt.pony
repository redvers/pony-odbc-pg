use "debug"
use "pony-odbc"
use "../../pony-odbc-pg"

class iso ExampleStmt is PgStmtNotify
  let stmt: ODBCHandleStmt tag = ODBCHandleStmt

  new iso create() => None
