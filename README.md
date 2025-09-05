# Current Status: Unstable

We are still experimenting with the (default) APIs to make the user experience as safe and clean as possible.

## Priorities

- Implement the column results > buffersize issue
- Implement remaining (core) types
- Implement asychronous API (ODBC default is synchronous)
- Implement helper functions for fetchrow, fetchrow\_array, fetchrow\_hashref and friends
- Test all the things against a MySQL database to find differences.  Any commonality, push out to pony-odbc.

## High Level API

ODBC has three object types that we use to define, connect, and query a database.  They are "Environment", "Database Connection", and "Statement".

A "Statement" requires a "Database Connection", which requires an "Environment".

### Environment

Used to define global attributes for all database connections in this environment

#### Environment API

| Implemented   | Class      | Function Signature | Description                                                              |
|---------------|------------|--------------------|--------------------------------------------------------------------------|
| Yes           | PgEnv      | create()           | Creates our base PostgreSQL "Environment".                               |
| Yes           | PgEnv      | set\_odbc3(): Bool | Instructs the ODBC drivers that we will be using the ODBC Version 3 API. |

#### Environment Core Attributes

| Implemented   | Class      | Attribute                      | Description                                 |
|---------------|------------|--------------------------------|---------------------------------------------|
| Yes           | PgEnv      | SQL\_ATTR\_ODBC\_VERSION       | Creates our base PostgreSQL "Environment".  |
| No            | PgEnv      | SQL\_ATTR\_CONNECTION\_POOLING | Whether to enable database pooling support. |
| No            | PgEnv      | SQL\_ATTR\_OUTPUT\_NTS         | Whether output strings are NULL terminated. |

### Database Connection

Each new instance of this should result in up to one database connection.

#### Database API

| Implemented   | Class      | Function Signature                             | Description                                                             |
|---------------|------------|------------------------------------------------|-------------------------------------------------------------------------|
| Yes           | PgDbc      | create(env: PgEnv)                             | Creates our base PostgreSQL "Database Connection".                      |
| Yes           | PgDbc      | set\_application\_name(name: String val): Bool | Informs the ODBC driver (and database?) of the name of our application. |
| Yes           | PgDbc      | connect(dsn: String val): Bool                 | Makes the actual connection to the database via the provided dsn.       |

#### Database Core Attributes

| Implemented   | Class      | Attribute                    | Description                                                                                                 |
|---------------|------------|------------------------------|-----------------------------------------|
| No            | PgDbc      | SQL\_ATTR\_ACCESS\_MODE      | read-only or read-write mode.           |
| No            | PgDbc      | SQL\_ATTR\_AUTOCOMMIT        | on/off for transaction autocommit)      |
| No            | PgDbc      | SQL\_ATTR\_LOGIN\_TIMEOUT    | timeout in seconds before login fails.  |
| No            | PgDbc      | SQL\_ATTR\_TXN\_ISOLATION    | transaction isolation level.            |
| No            | PgDbc      | SQL\_ATTR\_METADATA\_ID      | metadata handling.                      |
| No            | PgDbc      | SQL\_ATTR\_ASYNC\_ENABLE     | support for asynchronous execution.     |
| No            | PgDbc      | SQL\_ATTR\_TRACE             | for tracing/debug.                      |
| No            | PgDbc      | SQL\_ATTR\_TRACEFILE         | for tracing/debug.                      |
| No            | PgDbc      | SQL\_ATTR\_QUIET\_MODE       | disable driver messages.                |
| No            | PgDbc      | SQL\_ATTR\_TRANSLATE\_LIB    | data translation libraries and options. |
| No            | PgDbc      | SQL\_ATTR\_TRANSLATE\_OPTION | data translation libraries and options. |
| No            | PgDbc      | SQL\_ATTR\_ODBC\_CURSORS     | cursor use by the driver.               |

### Statement

Each instance of this is equivalent to a "prepared statement".  In our current API implementation, we require a class to represent the model to map between SQL and Pony types for the provided SQL statement.

- We should rename this PgStmt at some point

#### Statement API

| Implemented   | Class      | Function Signature                       | Description                                                                                                                          |
|---------------|------------|------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| Yes           | PgSth      | create(dbc: PgDbc, model: PgQueryModel)  | Creates our base PostgreSQL "Statement Object". (Note: If you're going to just be using exec_direct(), provide no PgQueryModel arg). |
| Yes           | PgSth      | prepare(): Bool                          | Creates our base PostgreSQL "Statement Object", and binds the parameters and columns as defined by the provided PgQueryModel.        |
| Yes           | PgSth      | execute\[A: Any val\](i: A): Bool        | Executes the statement with the provided (optional) values to be populated as parameters.                                            |
| Yes           | PgSth      | exec_direct(query: String val): Bool     | Executes the provided SQL statememnt.                                                                                                |
| Yes           | PgSth      | result\_count(): (Bool, USize)           | Returns the number of affected rows for the query.                                                                                   |
| Yes           | PgSth      | fetch(): (Bool, PgResultOut)             | Returns a single row of data as specified in PgResultOut.                                                                            |
| Yes           | PgSth      | finish(): Bool                           | Finishes a query by deleting the active cursor (thus destroying the active rowset).                                                  |

#### Statement Core Attributes

| Implemented   | Class      | Attribute                   | Description                             |
|---------------|------------|-----------------------------|-----------------------------------------|
| No            | PgSth      | SQL\_ATTR\_APP\_ROW\_DESC   | Application row descriptor handle.      |
| No            | PgSth      | SQL\_ATTR\_APP\_PARAM\_DESC | Application parameter descriptor handle |

## Currently Supported (Core) types

| Implemented   | SQL Type   | C Type                 | Description                                 | Min Value                     | Max Value                     |
|---------------|------------|------------------------|---------------------------------------------|-------------------------------|-------------------------------|
| Yes¹²         | CHAR       | SQL\_C\_CHAR           | Fixed-length character string               | —                             | —                             |
| Yes¹²         | VARCHAR    | SQL\_C\_CHAR           | Variable-length character string            | —                             | —                             |
| Yes¹²         | WCHAR      | SQL\_C\_WCHAR          | Fixed-length Unicode string                 | —                             | —                             |
| Yes¹²         | WVARCHAR   | SQL\_C\_WCHAR          | Variable-length Unicode string              | —                             | —                             |
| Needs Tests¹²³| BINARY     | SQL\_C\_BINARY         | Fixed-length binary data                    | —                             | —                             |
| Needs Tests¹²³| VARBINARY  | SQL\_C\_BINARY         | Variable-length binary data                 | —                             | —                             |
|               | BIT        | SQL\_C\_BIT            | Boolean value (0 or 1)                      | 0                             | 1                             |
|               | TINYINT    | SQL\_C\_TINYINT        | 1-byte signed integer                       | -128                          | 127                           |
|               | SMALLINT   | SQL\_C\_SHORT          | 2-byte signed integer                       | -32,768                       | 32,767                        |
| Yes           | INTEGER    | SQL\_C\_LONG           | 4-byte signed integer                       | -2,147,483,648                | 2,147,483,647                 |
|               | BIGINT     | SQL\_C\_SBIGINT        | 8-byte signed integer                       | -9,223,372,036,854,775,808    | 9,223,372,036,854,775,807     |
|               | FLOAT      | SQL\_C\_DOUBLE         | Double-precision floating point             | ~±2.23E-308                   | ~±1.79E+308                   |
|               | REAL       | SQL\_C\_FLOAT          | Single-precision floating point             | ~±1.18E-38                    | ~±3.40E+38                    |
|               | DOUBLE     | SQL\_C\_DOUBLE         | Double-precision floating point             | ~±2.23E-308                   | ~±1.79E+308                   |
|               | NUMERIC    | SQL\_C\_NUMERIC        | Exact numeric; user-defined precision/scale | Implementation-defined        | Implementation-defined        |
|               | DECIMAL    | SQL\_C\_NUMERIC        | Exact numeric; user-defined precision/scale | Implementation-defined        | Implementation-defined        |
|               | DATE       | SQL\_C\_TYPE\_DATE     | Date (year, month, day)                     | —                             | —                             |
|               | TIME       | SQL\_C\_TYPE\_TIME     | Time (hours, minutes, seconds)              | —                             | —                             |
|               | TIMESTAMP  | SQL\_C\_TYPE\_TIMESTAMP| Date and time (year to fractions)           | —                             | —                             |

- ¹ Currently aborts if you read in a column larger than the buffer.
- ² Does not have orNULL implemented yet
- ³ Does not abort correctly if you provide a param out of the range of the type. (Note - we should aim to catch this at the binding point by comparing the SQLDescribeColumn data against the buffer allocation)

## Currently Supported APIs

(This should only be of interest to those intending to do development on this package)

| Implemented       | API Function            | Brief Description                                                                                      |
|-------------------|-------------------------|--------------------------------------------------------------------------------------------------------|
| Yes               | SQLAllocHandle          | Allocates an environment, connection, statement, or descriptor handle.                                 |
| Yes               | SQLBindCol              | Binds application buffers to columns in result set rows.                                               |
| Yes               | SQLBindParameter        | Binds application buffers to parameters in an SQL statement.                                           |
| No                | SQLBrowseConnect        | Returns attributes/values needed for connecting to the data source, building up as values are supplied.|
| No                | SQLBulkOperations       | Performs bulk Insert, Update, Delete, or Fetch by bookmark.                                            |
| No                | SQLCancel               | Cancels statement execution or processing of a result set.                                             |
| Yes               | SQLCloseCursor          | Closes an open cursor on a statement handle.                                                           |
| No                | SQLColAttribute         | Gets attributes for a result set column.                                                               |
| No                | SQLColumnPrivileges     | Gets privileges for columns in specified tables.                                                       |
| No                | SQLColumns              | Returns info about columns in a specified set of tables.                                               |
| Yes               | SQLConnect              | Connects to a data source using a DSN, user ID, and password.                                          |
| No                | SQLCopyDesc             | Copies descriptor information from one descriptor handle to another.                                   |
| Yes               | SQLDescribeCol          | Gets description (type/size/name) of a column in a result set.                                         |
| Yes               | SQLDescribeParam        | Gets description (type/size) of statement parameters.                                                  |
| No                | SQLDisconnect           | Ends a connection to the data source.                                                                  |
| No                | SQLDriverConnect        | Connects to a driver using a connection string or connection dialogs.                                  |
| No                | SQLEndTran              | Commits or rolls back a transaction (at connection or environment level).                              |
| Yes               | SQLExecDirect           | Directly executes an SQL statement without prior preparation.                                          |
| Yes               | SQLExecute              | Executes a previously prepared statement.                                                              |
| Yes               | SQLFetch                | Fetches the next row of data from a result set.                                                        |
| No                | SQLFetchScroll          | Fetches a row from a result set based on a specific orientation (scrollable cursors).                  |
| No                | SQLForeignKeys          | Information about foreign keys in tables.                                                              |
| No                | SQLFreeHandle           | Releases resources for handles allocated using SQLAllocHandle.                                         |
| No                | SQLFreeStmt             | Releases statement resources or closes active cursors for a statement.                                 |
| No                | SQLGetConnectAttr       | Retrieves the value of a connection attribute.                                                         |
| No                | SQLGetCursorName        | Gets the name of the cursor for a statement handle.                                                    |
| No                | SQLGetData              | Retrieves data for a single column, useful for long data values.                                       |
| No                | SQLGetDescField         | Gets an individual field from a descriptor.                                                            |
| No                | SQLGetDescRec           | Gets multiple fields from a descriptor.                                                                |
| No                | SQLGetDiagField         | Gets diagnostic information (such as error codes) for operations.                                      |
| No                | SQLGetDiagRec           | Gets detailed diagnostic records.                                                                      |
| No                | SQLGetEnvAttr           | Retrieves the value of an environment attribute.                                                       |
| No                | SQLGetInfo              | Retrieves details about the behavior/capabilities of a specific driver and data source.                |
| No                | SQLGetStmtAttr          | Gets a statement attribute value.                                                                      |
| No                | SQLGetTypeInfo          | Gets information about supported SQL data types by the driver.                                         |
| No                | SQLMoreResults          | Advances to the next result set for statements that produce multiple results.                          |
| No                | SQLNativeSQL            | Retrieves the SQL statement as it is sent to the data source.                                          |
| No                | SQLNumParams            | Gets the number of parameters in a statement.                                                          |
| No                | SQLNumResultCols        | Returns the number of columns in a result set.                                                         |
| No                | SQLParamData            | Used during execution to provide parameter data, useful for large values.                              |
| Yes               | SQLPrepare              | Prepares an SQL statement for subsequent execution.                                                    |
| No                | SQLPrimaryKeys          | Gets the columns that comprise the primary key for a table.                                            |
| No                | SQLProcedureColumns     | Returns info about procedure parameters.                                                               |
| No                | SQLProcedures           | Lists stored procedures in the data source.                                                            |
| No                | SQLPutData              | Sends additional parameter data, typically for large or long data.                                     |
| Yes               | SQLRowCount             | Retrieves number of rows affected by operations.                                                       |
| No                | SQLSetConnectAttr       | Sets a connection attribute.                                                                           |
| No                | SQLSetCursorName        | Sets a cursor name for a statement handle.                                                             |
| No                | SQLSetDescField         | Sets an individual field in a descriptor.                                                              |
| No                | SQLSetDescRec           | Sets multiple fields in a descriptor.                                                                  |
| Yes               | SQLSetEnvAttr           | Sets an environment-level attribute.                                                                   |
| No                | SQLSetPos               | Positions within a block of fetched data (for updates/deletes/adds).                                   |
| No                | SQLSetStmtAttr          | Sets a statement attribute (e.g., row array size, concurrency).                                        |
| No                | SQLSpecialColumns       | Gets optimal columns for identifying a row or automatically updated columns.                           |
| No                | SQLStatistics           | Retrieves info/statistics about tables or indexes.                                                     |
| No                | SQLTablePrivileges      | Gets privileges for tables in the data source.                                                         |
| No                | SQLTables               | Returns a list of tables, schemas, or table types in the data source.                                  |
