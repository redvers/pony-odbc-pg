use "pony-odbc"

actor PgStmt
  var hstmt: ODBCHandleStmt tag
  var valid: Bool = false

  new create(hstmt': ODBCHandleStmt tag) =>
    hstmt = hstmt'
    valid = true

  new none() =>
    hstmt = ODBCHandleStmt


primitive PgStmts
  fun prepare(dbc: ODBCHandleDbc tag, sql: String val): (SQLReturn val, PgStmt tag) =>
    (var rv: SQLReturn val, var stmt: ODBCHandleStmt tag) = ODBCHandleDbcs.prepare(dbc, sql)
    match rv
    | let x: SQLSuccess val => return (x, PgStmt(stmt))
    | let x: SQLSuccessWithInfo val => return (x, PgStmt(stmt))
    else
      return (rv, PgStmt.none())
    end
