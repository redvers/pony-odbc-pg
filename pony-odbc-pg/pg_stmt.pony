use "pony-odbc"

actor PgStmt
  let pgstmtnotify: PgStmtNotify ref
  let stmt: ODBCHandleStmt ref
  let dbc: ODBCHandleDbc tag
  var valid: Bool = false

  new create(pgstmtnotify': PgStmtNotify iso, dbc': ODBCHandleDbc tag, stmt': ODBCHandleStmt iso) =>
    pgstmtnotify = consume pgstmtnotify'
    dbc = dbc'
    stmt = consume stmt'
    valid = true

    pgstmtnotify.prepare(this)


  new none(pgstmtnotify': PgStmtNotify iso) =>
    pgstmtnotify = consume pgstmtnotify'
    dbc = ODBCHandleDbc
    stmt = ODBCHandleStmt

  fun ref bind_col_i32(colnum: U16, target: CBoxedI32 tag, prev: SQLReturn val): SQLReturn val=>
    stmt.bind_col_i32(colnum, target, prev)

  be execute(prev: SQLReturn val) =>
    stmt.execute(prev)

  be fetch(prev': SQLReturn val) => None
    var prev: SQLReturn val = prev'
    stmt.fetch(prev)
    pgstmtnotify.fetch(prev)

  fun prepare(statement: String val, prev: SQLReturn val): SQLReturn val =>
    stmt.prepare(statement, prev)



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
