/*
 * smallint	2 bytes	small-range integer	-32768 to +32767
 * integer	4 bytes	typical choice for integer	-2147483648 to +2147483647
 * bigint	8 bytes	large-range integer	-9223372036854775808 to +9223372036854775807
 * decimal	variable	user-specified precision, exact	up to 131072 digits before the decimal point; up to 16383 digits after the decimal point
 * numeric	variable	user-specified precision, exact	up to 131072 digits before the decimal point; up to 16383 digits after the decimal point
 * real	4 bytes	variable-precision, inexact	6 decimal digits precision
 * double precision	8 bytes	variable-precision, inexact	15 decimal digits precision
 * smallserial	2 bytes	small autoincrementing integer	1 to 32767
 * serial	4 bytes	autoincrementing integer	1 to 2147483647
 * bigserial	8 bytes	large autoincrementing integer	1 to 9223372036854775807
 */
use "debug"
use "pony-odbc"
use "pony-odbc/ctypes"
use "pony-odbc/attributes"
use "pony-odbc/instrumentation"

//type PgSmallInt         is SQLCSShort
class PgInteger
  var v: CBoxedI32 = CBoxedI32
  var is_null: Bool = false
  new create(a: I32 = 0) => v.value = a

  fun bind_parameter(col: U16): SQLReturn val => SQLSuccess // FIXME

  fun bind_column(h: ODBCHandleStmt tag, col: U16): SQLReturn val =>
    var cold: SQLDescribeColOut = SQLDescribeColOut
    var err: SQLReturn val = ODBCStmt.describe_col(h, col, cold)

    try Debug.out("Column Name: " + cold.column_name.string()?) else Debug.out("Column Name: NULL") end
    Debug.out("Data Type: " + cold.datatype.value.string())
    Debug.out("Column Size: " + cold.colsize.value.string())
    Debug.out("Dec Digits: " + cold.decdigits.value.string())
    Debug.out("Nullable: " + cold.nullable.value.string())


    err
    // This does the i32 binding.  We should verify we match before
    // we bind:




//    h.bind_col_i32(col, v)


//   fun bind_parameter_i32(hstmt: ODBCHandleStmt tag, ipar: U16, fParamType: I16, fCType: I16, fSqlType: I16, cbColDef: U64, ibScale: I16, rgbValue: Pointer[None] tag, cbValueMax: I64, pcbValue: Pointer[I64] tag): SQLReturn val => SQLSuccess

//type PgBigInt           is CBoxedI64
//type PgDecimal          is SQLCNumeric
//type PgNumeric          is SQLCNumeric
//type PgReal             is F32
//type PgDoublePrecision  is F64
//type PgSmallSerial      is CBoxedU16
//type PgSerial           is CBoxedU32
//type PgBigSerial        is CBoxedU64

//type PgChar             is CBoxedArray
class PgVarchar
  var v: CBoxedArray
  var is_null: Bool = false
  new create(a: USize = 4096) => v = CBoxedArray(a)

  fun bind_parameter(col: U16): SQLReturn val => SQLSuccess // FIXME
  fun bind_column(h: ODBCHandleStmt tag, col: U16): SQLReturn val => SQLSuccess

//    h.bind_col_i32(col, v)
//type PgText             is CBoxedArray
