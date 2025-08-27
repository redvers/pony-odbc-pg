use "debug"
use "pony-odbc"
use "../../pony-odbc-pg"

actor Main
  let env: Env
  let henv: ODBCHandleEnv
  new create(env': Env) =>
    env = env'


    (var status: SQLReturn val, henv) = ODBCHandleEnvs.alloc()

    henv.set_odbc3(status)

    var exdbcnotify: ExampleDbc iso = ExampleDbc(henv, "simple_queries", "psqlred")
    var dbc: PgDbc = PgDbc(consume exdbcnotify)

