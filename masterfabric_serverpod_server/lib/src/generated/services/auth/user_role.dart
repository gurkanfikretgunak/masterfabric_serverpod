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

abstract class UserRole
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserRole._({
    this.id,
    required this.userId,
    required this.roleId,
    required this.assignedAt,
    this.assignedBy,
  });

  factory UserRole({
    int? id,
    required String userId,
    required int roleId,
    required DateTime assignedAt,
    String? assignedBy,
  }) = _UserRoleImpl;

  factory UserRole.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserRole(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      roleId: jsonSerialization['roleId'] as int,
      assignedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['assignedAt'],
      ),
      assignedBy: jsonSerialization['assignedBy'] as String?,
    );
  }

  static final t = UserRoleTable();

  static const db = UserRoleRepository._();

  @override
  int? id;

  String userId;

  int roleId;

  DateTime assignedAt;

  String? assignedBy;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserRole]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserRole copyWith({
    int? id,
    String? userId,
    int? roleId,
    DateTime? assignedAt,
    String? assignedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserRole',
      if (id != null) 'id': id,
      'userId': userId,
      'roleId': roleId,
      'assignedAt': assignedAt.toJson(),
      if (assignedBy != null) 'assignedBy': assignedBy,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserRole',
      if (id != null) 'id': id,
      'userId': userId,
      'roleId': roleId,
      'assignedAt': assignedAt.toJson(),
      if (assignedBy != null) 'assignedBy': assignedBy,
    };
  }

  static UserRoleInclude include() {
    return UserRoleInclude._();
  }

  static UserRoleIncludeList includeList({
    _i1.WhereExpressionBuilder<UserRoleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserRoleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserRoleTable>? orderByList,
    UserRoleInclude? include,
  }) {
    return UserRoleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserRole.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserRole.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserRoleImpl extends UserRole {
  _UserRoleImpl({
    int? id,
    required String userId,
    required int roleId,
    required DateTime assignedAt,
    String? assignedBy,
  }) : super._(
         id: id,
         userId: userId,
         roleId: roleId,
         assignedAt: assignedAt,
         assignedBy: assignedBy,
       );

  /// Returns a shallow copy of this [UserRole]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserRole copyWith({
    Object? id = _Undefined,
    String? userId,
    int? roleId,
    DateTime? assignedAt,
    Object? assignedBy = _Undefined,
  }) {
    return UserRole(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      roleId: roleId ?? this.roleId,
      assignedAt: assignedAt ?? this.assignedAt,
      assignedBy: assignedBy is String? ? assignedBy : this.assignedBy,
    );
  }
}

class UserRoleUpdateTable extends _i1.UpdateTable<UserRoleTable> {
  UserRoleUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> roleId(int value) => _i1.ColumnValue(
    table.roleId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> assignedAt(DateTime value) =>
      _i1.ColumnValue(
        table.assignedAt,
        value,
      );

  _i1.ColumnValue<String, String> assignedBy(String? value) => _i1.ColumnValue(
    table.assignedBy,
    value,
  );
}

class UserRoleTable extends _i1.Table<int?> {
  UserRoleTable({super.tableRelation}) : super(tableName: 'user_role') {
    updateTable = UserRoleUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    roleId = _i1.ColumnInt(
      'roleId',
      this,
    );
    assignedAt = _i1.ColumnDateTime(
      'assignedAt',
      this,
    );
    assignedBy = _i1.ColumnString(
      'assignedBy',
      this,
    );
  }

  late final UserRoleUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnInt roleId;

  late final _i1.ColumnDateTime assignedAt;

  late final _i1.ColumnString assignedBy;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    roleId,
    assignedAt,
    assignedBy,
  ];
}

class UserRoleInclude extends _i1.IncludeObject {
  UserRoleInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserRole.t;
}

class UserRoleIncludeList extends _i1.IncludeList {
  UserRoleIncludeList._({
    _i1.WhereExpressionBuilder<UserRoleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserRole.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserRole.t;
}

class UserRoleRepository {
  const UserRoleRepository._();

  /// Returns a list of [UserRole]s matching the given query parameters.
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
  Future<List<UserRole>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserRoleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserRoleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserRoleTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserRole>(
      where: where?.call(UserRole.t),
      orderBy: orderBy?.call(UserRole.t),
      orderByList: orderByList?.call(UserRole.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserRole] matching the given query parameters.
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
  Future<UserRole?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserRoleTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserRoleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserRoleTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserRole>(
      where: where?.call(UserRole.t),
      orderBy: orderBy?.call(UserRole.t),
      orderByList: orderByList?.call(UserRole.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserRole] by its [id] or null if no such row exists.
  Future<UserRole?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserRole>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserRole]s in the list and returns the inserted rows.
  ///
  /// The returned [UserRole]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserRole>> insert(
    _i1.Session session,
    List<UserRole> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserRole>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserRole] and returns the inserted row.
  ///
  /// The returned [UserRole] will have its `id` field set.
  Future<UserRole> insertRow(
    _i1.Session session,
    UserRole row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserRole>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserRole]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserRole>> update(
    _i1.Session session,
    List<UserRole> rows, {
    _i1.ColumnSelections<UserRoleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserRole>(
      rows,
      columns: columns?.call(UserRole.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserRole]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserRole> updateRow(
    _i1.Session session,
    UserRole row, {
    _i1.ColumnSelections<UserRoleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserRole>(
      row,
      columns: columns?.call(UserRole.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserRole] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserRole?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserRoleUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserRole>(
      id,
      columnValues: columnValues(UserRole.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserRole]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserRole>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserRoleUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserRoleTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserRoleTable>? orderBy,
    _i1.OrderByListBuilder<UserRoleTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserRole>(
      columnValues: columnValues(UserRole.t.updateTable),
      where: where(UserRole.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserRole.t),
      orderByList: orderByList?.call(UserRole.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserRole]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserRole>> delete(
    _i1.Session session,
    List<UserRole> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserRole>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserRole].
  Future<UserRole> deleteRow(
    _i1.Session session,
    UserRole row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserRole>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserRole>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserRoleTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserRole>(
      where: where(UserRole.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserRoleTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserRole>(
      where: where?.call(UserRole.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
