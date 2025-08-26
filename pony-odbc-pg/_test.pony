use "debug"
use "pony_test"
use "pony-odbc"
use "lib:odbc"

actor Main is TestList
  let env: Env

  new create(env': Env) =>
    env = env'
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestPostgreSQL)



class iso _TestPostgreSQL is UnitTest
  fun name(): String val => "_TestPostgreSQL"

  fun apply(h: TestHelper) =>
    (var status: SQLReturn, var pgenv: PgEnv) = ODBCHandleEnvs.alloc()
    h.assert_is[SQLReturn](SQLSuccess, status)
    h.assert_is[SQLReturn](SQLSuccess, pgenv.set_odbc3())

    var tnpass: _TestNotify = _TestNotify(h, true, "")
    var dbcpass: PgDbc = PgDbc(pgenv, "_TestPostgreSQL", "psqlred", tnpass)

    var tnfail: _TestNotify = _TestNotify(h, false, "IM002") // FIXME
    var dbcfail: PgDbc = PgDbc(pgenv, "_TestPostgreSQL", "i_want_to_fail", tnfail)

//    h.dispose_when_done(tnpass)
    h.dispose_when_done(tnfail)
    h.long_test(5_000_000_000)


actor _TestNotify is PgDbcClient
  let h: TestHelper
  let success_expected: Bool
  let expected_error: String val

  new create(h': TestHelper, success_expected': Bool, expected_error': String val) =>
    h = h'
    success_expected = success_expected'
    expected_error = expected_error'

  be pg_connected(rv: SQLReturn val) =>
    if (success_expected) then
      h.assert_true(true)
      h.complete(true)
    else
      h.fail("Failed on pg_connected()")
      h.complete(true)
    end

  be pg_connection_failed(rv: SQLReturn val) =>
    match rv
    | let x: SQLError val =>
      try
        h.assert_eq[String val](expected_error, x.records(0)?._2.sqlstate)
      else
        h.fail("\n".join(x.get_records().values()))
      end
    end
    h.complete(true)

  be dispose() => None





//    var hdbc: HandleDBC = HandleDBC.create(henv)?
//                          .>set_application_name("_TestPostgreSQL")?
//                          .>connect("psqlred")?
//                          .>get_commit_mode()


