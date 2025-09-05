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

class \nodoc\ iso _TestInteger is UnitTest
  var dsn: String val
  fun name(): String val => "_TestInteger"

  new create(dsn': String val) => dsn = dsn'

  fun apply(h: TestHelper) =>
    var e: PgEnv = PgEnv
    h.assert_true(e.is_valid())
    h.assert_true(e.set_odbc3())
    h.assert_true(e.is_valid())

    var dbc: PgDbc = PgDbc(e)
    h.assert_true(dbc.is_valid())
    h.assert_true(dbc.set_application_name("TestInteger"))

    h.assert_true(dbc.connect(dsn))
    h.assert_eq[String]("SQLSuccess", dbc.err.string())

    var pcmp: _TestIntegerModel iso = _TestIntegerModel

    var stmta: PgSth = PgSth(dbc, consume pcmp)

    h.assert_is[SQLReturn val](SQLSuccess, stmta.err)

    h.assert_true(stmta.prepare())

    h.assert_true(stmta.execute[(I32, I32)]((10,16)))
    (var s: Bool, var cnt: USize) = stmta.result_count()
    show_error(stmta)
    h.assert_true(s)
    h.assert_eq[USize](7, cnt)

    (var bool: Bool, var result: PgResultOut) = stmta.fetch()
    h.assert_true(bool)
    try
      h.assert_eq[I32](10, (result as _PCMResultI).integer)
    else
      h.fail("Return datatype is incorrect")
    end
    (bool, result) = stmta.fetch()
    h.assert_true(bool)
    try
      h.assert_eq[I32](11, (result as _PCMResultI).integer)
    else
      h.fail("Return datatype is incorrect")
    end

  fun show_error(stmta: PgSth) =>
    var err: SQLReturn val = recover val SQLError.create_pstmt(stmta.stmt) end
    try
      if (false) then error end
      for f in (stmta.err as SQLError val).get_records().values() do
        Debug.out(f)
      end
      true
    end

