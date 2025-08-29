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

    var ex1: PgGetTypeInfo iso = PgGetTypeInfo
    var stmt: PgSth = PgSth(dbc, consume ex1)
    stmt.prepare()
    stmt.bind_params(PgGetTypeInfoIn(0, stmt))
    stmt.bind_columns(PgGetTypeInfoOut(stmt))




//    stmt.execute()
//    match stmt.err
//    | let x: SQLError val => Debug("We have an error")
//        for f in x.get_records().values() do
//          Debug.out(f)
//        end
//    end

//    stmt.err.get_records()




