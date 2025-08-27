use "pony-odbc"

actor PgStmt
  let pgstmtnotify: PgStmtNotify ref
  new create(pgstmtnotify': PgStmtNotify iso) =>
    pgstmtnotify = consume pgstmtnotify'

/*
primitive PgStmts
  fun prepare(dbc: ODBCHandleDbc tag, sql: String val): (SQLReturn val, PgStmt tag) =>
    (var rv: SQLReturn val, var stmt: ODBCHandleStmt tag) = ODBCHandleDbcs.prepare(dbc, sql)
    match rv
    | let x: SQLSuccess val => return (x, PgStmt(stmt))
    | let x: SQLSuccessWithInfo val => return (x, PgStmt(stmt))
    else
      return (rv, PgStmt.none())
    end
    */
