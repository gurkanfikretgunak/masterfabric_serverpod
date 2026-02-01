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

/// Verification code for profile updates
abstract class VerificationCode
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  VerificationCode._({
    this.id,
    required this.userId,
    required this.code,
    required this.purpose,
    required this.expiresAt,
    required this.used,
    required this.createdAt,
  });

  factory VerificationCode({
    int? id,
    required String userId,
    required String code,
    required String purpose,
    required DateTime expiresAt,
    required bool used,
    required DateTime createdAt,
  }) = _VerificationCodeImpl;

  factory VerificationCode.fromJson(Map<String, dynamic> jsonSerialization) {
    return VerificationCode(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      code: jsonSerialization['code'] as String,
      purpose: jsonSerialization['purpose'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      used: jsonSerialization['used'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = VerificationCodeTable();

  static const db = VerificationCodeRepository._();

  @override
  int? id;

  String userId;

  String code;

  String purpose;

  DateTime expiresAt;

  bool used;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [VerificationCode]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VerificationCode copyWith({
    int? id,
    String? userId,
    String? code,
    String? purpose,
    DateTime? expiresAt,
    bool? used,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VerificationCode',
      if (id != null) 'id': id,
      'userId': userId,
      'code': code,
      'purpose': purpose,
      'expiresAt': expiresAt.toJson(),
      'used': used,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VerificationCode',
      if (id != null) 'id': id,
      'userId': userId,
      'code': code,
      'purpose': purpose,
      'expiresAt': expiresAt.toJson(),
      'used': used,
      'createdAt': createdAt.toJson(),
    };
  }

  static VerificationCodeInclude include() {
    return VerificationCodeInclude._();
  }

  static VerificationCodeIncludeList includeList({
    _i1.WhereExpressionBuilder<VerificationCodeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VerificationCodeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VerificationCodeTable>? orderByList,
    VerificationCodeInclude? include,
  }) {
    return VerificationCodeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VerificationCode.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(VerificationCode.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VerificationCodeImpl extends VerificationCode {
  _VerificationCodeImpl({
    int? id,
    required String userId,
    required String code,
    required String purpose,
    required DateTime expiresAt,
    required bool used,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         code: code,
         purpose: purpose,
         expiresAt: expiresAt,
         used: used,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [VerificationCode]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VerificationCode copyWith({
    Object? id = _Undefined,
    String? userId,
    String? code,
    String? purpose,
    DateTime? expiresAt,
    bool? used,
    DateTime? createdAt,
  }) {
    return VerificationCode(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      code: code ?? this.code,
      purpose: purpose ?? this.purpose,
      expiresAt: expiresAt ?? this.expiresAt,
      used: used ?? this.used,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class VerificationCodeUpdateTable
    extends _i1.UpdateTable<VerificationCodeTable> {
  VerificationCodeUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> purpose(String value) => _i1.ColumnValue(
    table.purpose,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<bool, bool> used(bool value) => _i1.ColumnValue(
    table.used,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class VerificationCodeTable extends _i1.Table<int?> {
  VerificationCodeTable({super.tableRelation})
    : super(tableName: 'verification_codes') {
    updateTable = VerificationCodeUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    code = _i1.ColumnString(
      'code',
      this,
    );
    purpose = _i1.ColumnString(
      'purpose',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    used = _i1.ColumnBool(
      'used',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final VerificationCodeUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnString code;

  late final _i1.ColumnString purpose;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnBool used;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    code,
    purpose,
    expiresAt,
    used,
    createdAt,
  ];
}

class VerificationCodeInclude extends _i1.IncludeObject {
  VerificationCodeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => VerificationCode.t;
}

class VerificationCodeIncludeList extends _i1.IncludeList {
  VerificationCodeIncludeList._({
    _i1.WhereExpressionBuilder<VerificationCodeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(VerificationCode.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => VerificationCode.t;
}

class VerificationCodeRepository {
  const VerificationCodeRepository._();

  /// Returns a list of [VerificationCode]s matching the given query parameters.
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
  Future<List<VerificationCode>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<VerificationCodeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VerificationCodeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VerificationCodeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<VerificationCode>(
      where: where?.call(VerificationCode.t),
      orderBy: orderBy?.call(VerificationCode.t),
      orderByList: orderByList?.call(VerificationCode.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [VerificationCode] matching the given query parameters.
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
  Future<VerificationCode?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<VerificationCodeTable>? where,
    int? offset,
    _i1.OrderByBuilder<VerificationCodeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<VerificationCodeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<VerificationCode>(
      where: where?.call(VerificationCode.t),
      orderBy: orderBy?.call(VerificationCode.t),
      orderByList: orderByList?.call(VerificationCode.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [VerificationCode] by its [id] or null if no such row exists.
  Future<VerificationCode?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<VerificationCode>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [VerificationCode]s in the list and returns the inserted rows.
  ///
  /// The returned [VerificationCode]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<VerificationCode>> insert(
    _i1.Session session,
    List<VerificationCode> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<VerificationCode>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [VerificationCode] and returns the inserted row.
  ///
  /// The returned [VerificationCode] will have its `id` field set.
  Future<VerificationCode> insertRow(
    _i1.Session session,
    VerificationCode row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<VerificationCode>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [VerificationCode]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<VerificationCode>> update(
    _i1.Session session,
    List<VerificationCode> rows, {
    _i1.ColumnSelections<VerificationCodeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<VerificationCode>(
      rows,
      columns: columns?.call(VerificationCode.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VerificationCode]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<VerificationCode> updateRow(
    _i1.Session session,
    VerificationCode row, {
    _i1.ColumnSelections<VerificationCodeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<VerificationCode>(
      row,
      columns: columns?.call(VerificationCode.t),
      transaction: transaction,
    );
  }

  /// Updates a single [VerificationCode] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<VerificationCode?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<VerificationCodeUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<VerificationCode>(
      id,
      columnValues: columnValues(VerificationCode.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [VerificationCode]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<VerificationCode>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<VerificationCodeUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<VerificationCodeTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<VerificationCodeTable>? orderBy,
    _i1.OrderByListBuilder<VerificationCodeTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<VerificationCode>(
      columnValues: columnValues(VerificationCode.t.updateTable),
      where: where(VerificationCode.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(VerificationCode.t),
      orderByList: orderByList?.call(VerificationCode.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [VerificationCode]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<VerificationCode>> delete(
    _i1.Session session,
    List<VerificationCode> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<VerificationCode>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [VerificationCode].
  Future<VerificationCode> deleteRow(
    _i1.Session session,
    VerificationCode row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<VerificationCode>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<VerificationCode>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<VerificationCodeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<VerificationCode>(
      where: where(VerificationCode.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<VerificationCodeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<VerificationCode>(
      where: where?.call(VerificationCode.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
