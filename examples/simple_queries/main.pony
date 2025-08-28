use "debug"
use "pony-odbc"
use "../../pony-odbc-pg"

actor Main
  let env: Env
  let henv: PgEnv
  new create(env': Env) =>
    env = env'


    henv = PgEnv
    henv.set_odbc3()

    var dbc: PgDbc = PgDbc(henv)
                     .>set_application_name("simple_queries")
                     .>connect("psqlred")

//    var exdbcnotify: ExampleDbc iso = ExampleDbc(henv, "simple_queries", "psqlred")




