
use "pony-odbc"
use "pony-odbc/ctypes"
use "pony-odbc/attributes"
use "pony-odbc/instrumentation"

type PgEnv is ODBCEnv
type PgDbc is ODBCDbc
type PgSth is ODBCSth

type PgInteger is SQLInteger
type PgVarchar is SQLVarchar


type PgQueryModel is ODBCQueryModel
type PgQueryParamsIn is ODBCQueryParamsIn
type PgQueryParamsOut is ODBCQueryParamsOut
type PgResultOut is ODBCResultOut

