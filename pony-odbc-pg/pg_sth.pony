use "debug"
use "pony-odbc"

class PgSth
  let stmt: ODBCHandleStmt tag
  let tablemodel: PgQueryModel
  var err: SQLReturn val
  var valid: Bool = false

  new create(dbc: PgDbc, qm: PgQueryModel iso) =>
    (err, stmt) = ODBCHandleStmts.alloc(dbc.dbc)
    tablemodel = consume qm
    set_valid(err)

  fun ref prepare(): Bool =>
    match tablemodel.sql()
    | let x: String val => err = ODBCHandleStmts.prepare(stmt, x)
    | let x: SQLReturn val => err = x
    end
    set_valid(err)

  fun ref bind_params(i: PgQueryParamsIn): Bool =>
    err = tablemodel.bind_params(consume i)
    set_valid(err)

  fun ref bind_columns(i: PgQueryParamsOut): Bool =>
    err = tablemodel.bind_columns(i)
    set_valid(err)

  fun ref execute(): Bool =>
    err = ODBCHandleStmts.execute(stmt)
    set_valid(err)






  fun is_valid(): Bool => valid

  fun ref set_valid(sqlr: SQLReturn val): Bool =>
    match sqlr
    | let x: SQLSuccess val => valid = true ; return true
    | let x: SQLSuccessWithInfo val => valid = true ; return true
    else
      valid = false ; return false
    end




