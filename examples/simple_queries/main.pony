use "debug"
use "pony-odbc"
use "../../pony-odbc-pg"
use "pony-odbc/ctypes"
use "pony-odbc/attributes"
use "pony-odbc/instrumentation"

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

    var ex1: ExampleSQL1 iso = ExampleSQL1
    var stmt: PgSth = PgSth(dbc, consume ex1)
    if (not stmt.prepare()) then Debug.out("failed") end
    stmt.bind_params(ExIn1(4096))
//    stmt.bind_columns(PgGetTypeInfoOut(stmt))




//    stmt.execute()
//    match stmt.err
//    | let x: SQLError val => Debug("We have an error")
//        for f in x.get_records().values() do
//          Debug.out(f)
//        end
//    end

//    stmt.err.get_records()




