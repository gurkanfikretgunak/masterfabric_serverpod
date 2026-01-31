/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class AuthAuditLog
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AuthAuditLog._({
    this.id,
    this.userId,
    required this.eventType,
    required this.eventData,
    this.ipAddress,
    this.userAgent,
    required this.timestamp,
  });

  factory AuthAuditLog({
    int? id,
    String? userId,
    required String eventType,
    required String eventData,
    String? ipAddress,
    String? userAgent,
    required DateTime timestamp,
  }) = _AuthAuditLogImpl;

  factory AuthAuditLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthAuditLog(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String?,
      eventType: jsonSerialization['eventType'] as String,
      eventData: jsonSerialization['eventData'] as String,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      userAgent: jsonSerialization['userAgent'] as String?,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
    );
  }

  static final t = AuthAuditLogTable();

  static const db = AuthAuditLogRepository._();

  @override
  int? id;

  String? userId;

  String eventType;

  String eventData;

  String? ipAddress;

  String? userAgent;

  DateTime timestamp;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AuthAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthAuditLog copyWith({
    int? id,
    String? userId,
    String? eventType,
    String? eventData,
    String? ipAddress,
    String? userAgent,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuthAuditLog',
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      'eventType': eventType,
      'eventData': eventData,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (userAgent != null) 'userAgent': userAgent,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuthAuditLog',
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      'eventType': eventType,
      'eventData': eventData,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (userAgent != null) 'userAgent': userAgent,
      'timestamp': timestamp.toJson(),
    };
  }

  static AuthAuditLogInclude include() {
    return AuthAuditLogInclude._();
  }

  static AuthAuditLogIncludeList includeList({
    _i1.WhereExpressionBuilder<AuthAuditLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthAuditLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthAuditLogTable>? orderByList,
    AuthAuditLogInclude? include,
  }) {
    return AuthAuditLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthAuditLog.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AuthAuditLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthAuditLogImpl extends AuthAuditLog {
  _AuthAuditLogImpl({
    int? id,
    String? userId,
    required String eventType,
    required String eventData,
    String? ipAddress,
    String? userAgent,
    required DateTime timestamp,
  }) : super._(
         id: id,
         userId: userId,
         eventType: eventType,
         eventData: eventData,
         ipAddress: ipAddress,
         userAgent: userAgent,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [AuthAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthAuditLog copyWith({
    Object? id = _Undefined,
    Object? userId = _Undefined,
    String? eventType,
    String? eventData,
    Object? ipAddress = _Undefined,
    Object? userAgent = _Undefined,
    DateTime? timestamp,
  }) {
    return AuthAuditLog(
      id: id is int? ? id : this.id,
      userId: userId is String? ? userId : this.userId,
      eventType: eventType ?? this.eventType,
      eventData: eventData ?? this.eventData,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      userAgent: userAgent is String? ? userAgent : this.userAgent,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class AuthAuditLogUpdateTable extends _i1.UpdateTable<AuthAuditLogTable> {
  AuthAuditLogUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String? value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> eventType(String value) => _i1.ColumnValue(
    table.eventType,
    value,
  );

  _i1.ColumnValue<String, String> eventData(String value) => _i1.ColumnValue(
    table.eventData,
    value,
  );

  _i1.ColumnValue<String, String> ipAddress(String? value) => _i1.ColumnValue(
    table.ipAddress,
    value,
  );

  _i1.ColumnValue<String, String> userAgent(String? value) => _i1.ColumnValue(
    table.userAgent,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> timestamp(DateTime value) =>
      _i1.ColumnValue(
        table.timestamp,
        value,
      );
}

class AuthAuditLogTable extends _i1.Table<int?> {
  AuthAuditLogTable({super.tableRelation})
    : super(tableName: 'auth_audit_log') {
    updateTable = AuthAuditLogUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    eventType = _i1.ColumnString(
      'eventType',
      this,
    );
    eventData = _i1.ColumnString(
      'eventData',
      this,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
    userAgent = _i1.ColumnString(
      'userAgent',
      this,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
    );
  }

  late final AuthAuditLogUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnString eventType;

  late final _i1.ColumnString eventData;

  late final _i1.ColumnString ipAddress;

  late final _i1.ColumnString userAgent;

  late final _i1.ColumnDateTime timestamp;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    eventType,
    eventData,
    ipAddress,
    userAgent,
    timestamp,
  ];
}

class AuthAuditLogInclude extends _i1.IncludeObject {
  AuthAuditLogInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AuthAuditLog.t;
}

class AuthAuditLogIncludeList extends _i1.IncludeList {
  AuthAuditLogIncludeList._({
    _i1.WhereExpressionBuilder<AuthAuditLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AuthAuditLog.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AuthAuditLog.t;
}

class AuthAuditLogRepository {
  const AuthAuditLogRepository._();

  /// Returns a list of [AuthAuditLog]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<AuthAuditLog>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthAuditLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthAuditLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthAuditLogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AuthAuditLog>(
      where: where?.call(AuthAuditLog.t),
      orderBy: orderBy?.call(AuthAuditLog.t),
      orderByList: orderByList?.call(AuthAuditLog.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AuthAuditLog] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<AuthAuditLog?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthAuditLogTable>? where,
    int? offset,
    _i1.OrderByBuilder<AuthAuditLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthAuditLogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AuthAuditLog>(
      where: where?.call(AuthAuditLog.t),
      orderBy: orderBy?.call(AuthAuditLog.t),
      orderByList: orderByList?.call(AuthAuditLog.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AuthAuditLog] by its [id] or null if no such row exists.
  Future<AuthAuditLog?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AuthAuditLog>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AuthAuditLog]s in the list and returns the inserted rows.
  ///
  /// The returned [AuthAuditLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AuthAuditLog>> insert(
    _i1.Session session,
    List<AuthAuditLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AuthAuditLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AuthAuditLog] and returns the inserted row.
  ///
  /// The returned [AuthAuditLog] will have its `id` field set.
  Future<AuthAuditLog> insertRow(
    _i1.Session session,
    AuthAuditLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuthAuditLog>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AuthAuditLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AuthAuditLog>> update(
    _i1.Session session,
    List<AuthAuditLog> rows, {
    _i1.ColumnSelections<AuthAuditLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AuthAuditLog>(
      rows,
      columns: columns?.call(AuthAuditLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuthAuditLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuthAuditLog> updateRow(
    _i1.Session session,
    AuthAuditLog row, {
    _i1.ColumnSelections<AuthAuditLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuthAuditLog>(
      row,
      columns: columns?.call(AuthAuditLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuthAuditLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AuthAuditLog?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AuthAuditLogUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AuthAuditLog>(
      id,
      columnValues: columnValues(AuthAuditLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AuthAuditLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AuthAuditLog>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AuthAuditLogUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AuthAuditLogTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthAuditLogTable>? orderBy,
    _i1.OrderByListBuilder<AuthAuditLogTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AuthAuditLog>(
      columnValues: columnValues(AuthAuditLog.t.updateTable),
      where: where(AuthAuditLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthAuditLog.t),
      orderByList: orderByList?.call(AuthAuditLog.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AuthAuditLog]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AuthAuditLog>> delete(
    _i1.Session session,
    List<AuthAuditLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AuthAuditLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AuthAuditLog].
  Future<AuthAuditLog> deleteRow(
    _i1.Session session,
    AuthAuditLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuthAuditLog>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AuthAuditLog>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AuthAuditLogTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AuthAuditLog>(
      where: where(AuthAuditLog.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthAuditLogTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AuthAuditLog>(
      where: where?.call(AuthAuditLog.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
