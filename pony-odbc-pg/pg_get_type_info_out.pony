use "debug"
use "pony-odbc"
use "pony-odbc/ctypes"
use "pony-odbc/attributes"
use "pony-odbc/instrumentation"

class PgGetTypeInfoIn is PgQueryParamsIn
  var a: I16 = 0
  var h: ODBCHandleStmt tag

  new create(id: I16 = 0, stmt: PgSth) =>
    a = id
    h = stmt.stmt

    /*
     * TYPE_NAME (ODBC 2.0)	1	Varchar not NULL
     * DATA_TYPE (ODBC 2.0)	2	Smallint not NULL	SQL data type.
     * COLUMN_SIZE (ODBC 2.0)	3	Integer
     * LITERAL_PREFIX (ODBC 2.0)	4	Varchar
     * LITERAL_SUFFIX (ODBC 2.0)	5	Varchar
     * CREATE_PARAMS (ODBC 2.0)	6	Varchar
     * NULLABLE (ODBC 2.0)	7	Smallint not NULL
     * CASE_SENSITIVE (ODBC 2.0)	8	Smallint not NULL
     * SEARCHABLE (ODBC 2.0)	9	Smallint not NULL
     * UNSIGNED_ATTRIBUTE (ODBC 2.0)	10	Smallint
     * FIXED_PREC_SCALE (ODBC 2.0)	11 Smallint NOT NULL
     * AUTO_UNIQUE_VALUE (ODBC 2.0)	12	Smallint
     * LOCAL_TYPE_NAME (ODBC 2.0)	13	Varchar
     * MINIMUM_SCALE (ODBC 2.0)	14	Smallint
     * MAXIMUM_SCALE (ODBC 2.0)	15	Smallint
     * SQL_DATA_TYPE (ODBC 3.0)	16	Smallint NOT NULL
     * SQL_DATETIME_SUB (ODBC 3.0)	17	Smallint
     * NUM_PREC_RADIX (ODBC 3.0)	18 Integer
     * INTERVAL_PRECISION (ODBC 3.0)	19 Smallint
*/
class PgGetTypeInfoOut is PgQueryParamsOut
  var h: ODBCHandleStmt tag

  var typename:           PgVarchar           = PgVarchar
//  var data_type:          PgSmallInt          = PgSmallInt
  var column_size:        PgInteger           = PgInteger
//  var literal_prefix:     (PgVarchar | None)  = PgVarchar
//  var literal_suffix:     (PgVarchar | None)  = PgVarchar
//  var create_params:      (PgVarchar | None)  = PgVarchar
//  var nullable:           PgSmallInt          = PgSmallInt
//  var case_sensitive:     PgSmallInt          = PgSmallInt
//  var searchable:         PgSmallInt          = PgSmallInt
//  var unsigned_attribute: (PgSmallInt | None) = PgSmallInt
//  var fixed_prec_scale:   PgSmallInt          = PgSmallInt
//  var auto_unique_value:  (PgSmallInt | None) = PgSmallInt
//  var local_type_name:    (PgVarchar | None)  = PgVarchar
//  var minimum_scale:      (PgSmallInt | None) = PgSmallInt
//  var maximum_scale:      (PgSmallInt | None) = PgSmallInt
//  var sql_data_type:      PgSmallInt          = PgSmallInt
//  var sql_datetime_sub:   (PgSmallInt | None) = PgSmallInt
//  var num_prec_radix:     (PgInteger | None)  = PgInteger
//  var interval_precision: (PgSmallInt | None) = PgSmallInt

  new create(stmt: PgSth) =>
    h = stmt.stmt
