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
import 'package:masterfabric_serverpod_server/src/generated/protocol.dart'
    as _i2;

abstract class TwoFactorSecret
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TwoFactorSecret._({
    this.id,
    required this.userId,
    required this.secret,
    required this.backupCodes,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TwoFactorSecret({
    int? id,
    required String userId,
    required String secret,
    required List<String> backupCodes,
    required bool enabled,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TwoFactorSecretImpl;

  factory TwoFactorSecret.fromJson(Map<String, dynamic> jsonSerialization) {
    return TwoFactorSecret(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      secret: jsonSerialization['secret'] as String,
      backupCodes: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['backupCodes'],
      ),
      enabled: jsonSerialization['enabled'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = TwoFactorSecretTable();

  static const db = TwoFactorSecretRepository._();

  @override
  int? id;

  String userId;

  String secret;

  List<String> backupCodes;

  bool enabled;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TwoFactorSecret]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TwoFactorSecret copyWith({
    int? id,
    String? userId,
    String? secret,
    List<String>? backupCodes,
    bool? enabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TwoFactorSecret',
      if (id != null) 'id': id,
      'userId': userId,
      'secret': secret,
      'backupCodes': backupCodes.toJson(),
      'enabled': enabled,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TwoFactorSecret',
      if (id != null) 'id': id,
      'userId': userId,
      'secret': secret,
      'backupCodes': backupCodes.toJson(),
      'enabled': enabled,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static TwoFactorSecretInclude include() {
    return TwoFactorSecretInclude._();
  }

  static TwoFactorSecretIncludeList includeList({
    _i1.WhereExpressionBuilder<TwoFactorSecretTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TwoFactorSecretTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TwoFactorSecretTable>? orderByList,
    TwoFactorSecretInclude? include,
  }) {
    return TwoFactorSecretIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TwoFactorSecret.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TwoFactorSecret.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TwoFactorSecretImpl extends TwoFactorSecret {
  _TwoFactorSecretImpl({
    int? id,
    required String userId,
    required String secret,
    required List<String> backupCodes,
    required bool enabled,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         secret: secret,
         backupCodes: backupCodes,
         enabled: enabled,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [TwoFactorSecret]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TwoFactorSecret copyWith({
    Object? id = _Undefined,
    String? userId,
    String? secret,
    List<String>? backupCodes,
    bool? enabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TwoFactorSecret(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      secret: secret ?? this.secret,
      backupCodes: backupCodes ?? this.backupCodes.map((e0) => e0).toList(),
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class TwoFactorSecretUpdateTable extends _i1.UpdateTable<TwoFactorSecretTable> {
  TwoFactorSecretUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> secret(String value) => _i1.ColumnValue(
    table.secret,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> backupCodes(List<String> value) =>
      _i1.ColumnValue(
        table.backupCodes,
        value,
      );

  _i1.ColumnValue<bool, bool> enabled(bool value) => _i1.ColumnValue(
    table.enabled,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class TwoFactorSecretTable extends _i1.Table<int?> {
  TwoFactorSecretTable({super.tableRelation})
    : super(tableName: 'two_factor_secret') {
    updateTable = TwoFactorSecretUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    secret = _i1.ColumnString(
      'secret',
      this,
    );
    backupCodes = _i1.ColumnSerializable<List<String>>(
      'backupCodes',
      this,
    );
    enabled = _i1.ColumnBool(
      'enabled',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final TwoFactorSecretUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnString secret;

  late final _i1.ColumnSerializable<List<String>> backupCodes;

  late final _i1.ColumnBool enabled;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    secret,
    backupCodes,
    enabled,
    createdAt,
    updatedAt,
  ];
}

class TwoFactorSecretInclude extends _i1.IncludeObject {
  TwoFactorSecretInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TwoFactorSecret.t;
}

class TwoFactorSecretIncludeList extends _i1.IncludeList {
  TwoFactorSecretIncludeList._({
    _i1.WhereExpressionBuilder<TwoFactorSecretTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TwoFactorSecret.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TwoFactorSecret.t;
}

class TwoFactorSecretRepository {
  const TwoFactorSecretRepository._();

  /// Returns a list of [TwoFactorSecret]s matching the given query parameters.
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
  Future<List<TwoFactorSecret>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TwoFactorSecretTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TwoFactorSecretTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TwoFactorSecretTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TwoFactorSecret>(
      where: where?.call(TwoFactorSecret.t),
      orderBy: orderBy?.call(TwoFactorSecret.t),
      orderByList: orderByList?.call(TwoFactorSecret.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TwoFactorSecret] matching the given query parameters.
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
  Future<TwoFactorSecret?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TwoFactorSecretTable>? where,
    int? offset,
    _i1.OrderByBuilder<TwoFactorSecretTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TwoFactorSecretTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TwoFactorSecret>(
      where: where?.call(TwoFactorSecret.t),
      orderBy: orderBy?.call(TwoFactorSecret.t),
      orderByList: orderByList?.call(TwoFactorSecret.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TwoFactorSecret] by its [id] or null if no such row exists.
  Future<TwoFactorSecret?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TwoFactorSecret>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TwoFactorSecret]s in the list and returns the inserted rows.
  ///
  /// The returned [TwoFactorSecret]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TwoFactorSecret>> insert(
    _i1.Session session,
    List<TwoFactorSecret> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TwoFactorSecret>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TwoFactorSecret] and returns the inserted row.
  ///
  /// The returned [TwoFactorSecret] will have its `id` field set.
  Future<TwoFactorSecret> insertRow(
    _i1.Session session,
    TwoFactorSecret row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TwoFactorSecret>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TwoFactorSecret]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TwoFactorSecret>> update(
    _i1.Session session,
    List<TwoFactorSecret> rows, {
    _i1.ColumnSelections<TwoFactorSecretTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TwoFactorSecret>(
      rows,
      columns: columns?.call(TwoFactorSecret.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TwoFactorSecret]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TwoFactorSecret> updateRow(
    _i1.Session session,
    TwoFactorSecret row, {
    _i1.ColumnSelections<TwoFactorSecretTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TwoFactorSecret>(
      row,
      columns: columns?.call(TwoFactorSecret.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TwoFactorSecret] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TwoFactorSecret?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TwoFactorSecretUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TwoFactorSecret>(
      id,
      columnValues: columnValues(TwoFactorSecret.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TwoFactorSecret]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TwoFactorSecret>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TwoFactorSecretUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<TwoFactorSecretTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TwoFactorSecretTable>? orderBy,
    _i1.OrderByListBuilder<TwoFactorSecretTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TwoFactorSecret>(
      columnValues: columnValues(TwoFactorSecret.t.updateTable),
      where: where(TwoFactorSecret.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TwoFactorSecret.t),
      orderByList: orderByList?.call(TwoFactorSecret.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TwoFactorSecret]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TwoFactorSecret>> delete(
    _i1.Session session,
    List<TwoFactorSecret> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TwoFactorSecret>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TwoFactorSecret].
  Future<TwoFactorSecret> deleteRow(
    _i1.Session session,
    TwoFactorSecret row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TwoFactorSecret>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TwoFactorSecret>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TwoFactorSecretTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TwoFactorSecret>(
      where: where(TwoFactorSecret.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TwoFactorSecretTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TwoFactorSecret>(
      where: where?.call(TwoFactorSecret.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
