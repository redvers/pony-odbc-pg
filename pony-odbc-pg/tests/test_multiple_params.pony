use "debug"
use ".."
use "pony_test"
use "pony-odbc"
use "pony-odbc/env"
use "pony-odbc/dbc"
use "pony-odbc/stmt"
use "pony-odbc/ctypes"
use "pony-odbc/attributes"
use "pony-odbc/instrumentation"

class \nodoc\ iso _TestMultipleParams is UnitTest
  var dsn: String val

  new create(dsn': String val) => dsn = dsn'
  fun name(): String val => "_TestMultipleParams"

  fun apply(h: TestHelper) =>
    var e: PgEnv = PgEnv
    h.assert_true(e.is_valid())
    h.assert_true(e.set_odbc3())
    h.assert_true(e.is_valid())

    var dbc: PgDbc = PgDbc(e)
    h.assert_true(dbc.is_valid())
    h.assert_true(dbc.set_application_name("TestMultipleParams"))

    h.assert_true(dbc.connect(dsn))
    h.assert_eq[String]("SQLSuccess", dbc.err.string())

    var pcmp: _TestMultipleParamsModel iso = _TestMultipleParamsModel

    var stmta: PgSth = PgSth(dbc, consume pcmp)

    h.assert_is[SQLReturn val](SQLSuccess, stmta.err)
    h.assert_true(stmta.prepare())

    h.assert_true(stmta.execute[(String val)]("application_name"))
    (var s: Bool, var cnt: USize) = stmta.result_count()
    h.assert_true(s)
    h.assert_eq[USize](1, cnt)

    (var bool: Bool, var result: PgResultOut) = stmta.fetch()
    h.assert_true(bool)
    try
      h.assert_eq[String val]("application_name", (result as _PCMResultSSS).name)
    else
      h.fail("Return datatype is incorrect")
    end

//    h.assert_false(stmta.fetch())
//    h.assert_is[SQLReturn val](SQLNoData, stmta.err)

//    h.assert_true(stmta.finish())

//    h.assert_true(stmta.execute[(String val)]("authentication_timeout"))
//    h.assert_eq[USize](1, cnt)
//    h.assert_true(stmta.fetch())
//    var err: SQLReturn val = recover val SQLError.create_pstmt(stmta.stmt) end
//    try
//      if (false) then error end
//      for f in (stmta.err as SQLError val).get_records().values() do
//        Debug.out(f)
//      end
//    Debug.out("dewded: " + stmta.err.string())
//      true
//    end

