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

class \nodoc\ iso _TestExecDirect is UnitTest
  var dsn: String val

  new create(dsn': String val) => dsn = dsn'

  fun name(): String val => "_TestExecDirect"

  fun apply(h: TestHelper) =>
    var e: PgEnv = PgEnv
    h.assert_true(e.is_valid())
    h.assert_true(e.set_odbc3())
    h.assert_true(e.is_valid())

    var dbc: PgDbc = PgDbc(e)
    h.assert_true(dbc.is_valid())
    h.assert_true(dbc.set_application_name("TestExecDirect"))

    h.assert_true(dbc.connect(dsn))
    h.assert_eq[String]("SQLSuccess", dbc.err.string())


    /* Create a temporary table */
    var stmt: PgSth = PgSth(dbc)
    h.assert_true(stmt.exec_direct("create temp table test_exec_direct (foo integer)"))

    (var bool: Bool, var cnt: USize) = stmt.result_count()
    h.assert_true(bool)
    h.assert_eq[USize](0, cnt)


    /* Attempt to create the same table again - this WILL fail */
    h.assert_false(stmt.exec_direct("create temp table test_exec_direct (foo integer)"))
    var er: SQLError val = recover val SQLError.create_pstmt(stmt.stmt) end
    try
      // [STM][42P07]: ERROR: relation "test_exec_direct" already exists;
      h.assert_eq[String val]("42P07", er.get_tuples()(0)?._2)
    else
      h.fail("We got an empty SQLError - this should never happen™")
    end


    /* Insert a single value into the table */
    h.assert_true(stmt.exec_direct("insert into test_exec_direct values (0)"))


    /* This select will execute, but there is no facility for getting the
     * results.  We just use result_count() to ensure we have the correct
     * number (1)                                                         */
    h.assert_true(stmt.exec_direct("select * from test_exec_direct"))
    (bool, cnt) = stmt.result_count()
    h.assert_true(bool)
    h.assert_eq[USize](1, cnt)

    /* Attempt to use the same stmt handle with an open cursor.
     * This should fail                                         */
    h.assert_false(stmt.exec_direct("insert into test_exec_direct values (0)"))

    er = recover val SQLError.create_pstmt(stmt.stmt) end
    try
      // [STM][HY010]: The cursor is open.
      h.assert_eq[String val]("HY010", er.get_tuples()(0)?._2)
    else
      h.fail("We got an empty SQLError - this should never happen™")
    end

    /* Close the cursor */
    h.assert_true(stmt.finish())

    /* Insert another three rows */
    h.assert_true(stmt.exec_direct("insert into test_exec_direct values (0)"))
    h.assert_true(stmt.exec_direct("insert into test_exec_direct values (1)"))
    h.assert_true(stmt.exec_direct("insert into test_exec_direct values (2)"))

    /* Select all the rows, count should be 4 */
    h.assert_true(stmt.exec_direct("select * from test_exec_direct"))
    (bool, cnt) = stmt.result_count()
    h.assert_true(bool)
    h.assert_eq[USize](4, cnt)
    h.assert_true(stmt.finish())

    /* Delete all rows from the table.  result_count() will report how
     * many rows were affected (ie, deleted) (4)                        */
    h.assert_true(stmt.exec_direct("delete from test_exec_direct"))
    (bool, cnt) = stmt.result_count()
    h.assert_true(bool)
    h.assert_eq[USize](4, cnt)

    /* Select to ensure there are no rows left */
    h.assert_true(stmt.exec_direct("select * from test_exec_direct"))
    (bool, cnt) = stmt.result_count()
    h.assert_true(bool)
    h.assert_eq[USize](0, cnt)
    h.assert_true(stmt.finish())


  fun show_error(stmta: PgSth) =>
    var err: SQLReturn val = recover val SQLError.create_pstmt(stmta.stmt) end
    try
      if (false) then error end
      for f in (stmta.err as SQLError val).get_records().values() do
        Debug.out(f)
      end
      true
    end

