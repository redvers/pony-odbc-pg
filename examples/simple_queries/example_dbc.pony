use "debug"
use "pony-odbc"
use "../../pony-odbc-pg"

class iso ExampleDbc is PgDbcNotify
  let pgenv: PgEnv tag
  let appname: String val
  let dsn: String val

  fun get_pgenv():   PgEnv tag  => pgenv
  fun get_appname(): String val => appname
  fun get_dsn():     String val => dsn

  new iso create(pgenv': PgEnv tag, appname': String val, dsn': String val) =>
    pgenv = pgenv'
    appname = appname'
    dsn = dsn'

  fun pg_connection_failed(err: SQLReturn val) =>
    Debug.out("My Database Connection Failed")

  fun ref pg_connected(err: SQLReturn val, pgdbc: PgDbc ref) =>
    Debug.out("My Database Connection Succeeded")

    let examplestmt: ExampleStmt iso = ExampleStmt
    pgdbc.prepare("select 42:text")




