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

abstract class Permission
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Permission._({
    this.id,
    required this.name,
    this.description,
    required this.resource,
    required this.action,
    required this.createdAt,
  });

  factory Permission({
    int? id,
    required String name,
    String? description,
    required String resource,
    required String action,
    required DateTime createdAt,
  }) = _PermissionImpl;

  factory Permission.fromJson(Map<String, dynamic> jsonSerialization) {
    return Permission(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      resource: jsonSerialization['resource'] as String,
      action: jsonSerialization['action'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = PermissionTable();

  static const db = PermissionRepository._();

  @override
  int? id;

  String name;

  String? description;

  String resource;

  String action;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Permission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Permission copyWith({
    int? id,
    String? name,
    String? description,
    String? resource,
    String? action,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Permission',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'resource': resource,
      'action': action,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Permission',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'resource': resource,
      'action': action,
      'createdAt': createdAt.toJson(),
    };
  }

  static PermissionInclude include() {
    return PermissionInclude._();
  }

  static PermissionIncludeList includeList({
    _i1.WhereExpressionBuilder<PermissionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PermissionTable>? orderByList,
    PermissionInclude? include,
  }) {
    return PermissionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Permission.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Permission.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PermissionImpl extends Permission {
  _PermissionImpl({
    int? id,
    required String name,
    String? description,
    required String resource,
    required String action,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         resource: resource,
         action: action,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Permission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Permission copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    String? resource,
    String? action,
    DateTime? createdAt,
  }) {
    return Permission(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      resource: resource ?? this.resource,
      action: action ?? this.action,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class PermissionUpdateTable extends _i1.UpdateTable<PermissionTable> {
  PermissionUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> resource(String value) => _i1.ColumnValue(
    table.resource,
    value,
  );

  _i1.ColumnValue<String, String> action(String value) => _i1.ColumnValue(
    table.action,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class PermissionTable extends _i1.Table<int?> {
  PermissionTable({super.tableRelation}) : super(tableName: 'permission') {
    updateTable = PermissionUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    resource = _i1.ColumnString(
      'resource',
      this,
    );
    action = _i1.ColumnString(
      'action',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final PermissionUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnString resource;

  late final _i1.ColumnString action;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    description,
    resource,
    action,
    createdAt,
  ];
}

class PermissionInclude extends _i1.IncludeObject {
  PermissionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Permission.t;
}

class PermissionIncludeList extends _i1.IncludeList {
  PermissionIncludeList._({
    _i1.WhereExpressionBuilder<PermissionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Permission.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Permission.t;
}

class PermissionRepository {
  const PermissionRepository._();

  /// Returns a list of [Permission]s matching the given query parameters.
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
  Future<List<Permission>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PermissionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PermissionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Permission>(
      where: where?.call(Permission.t),
      orderBy: orderBy?.call(Permission.t),
      orderByList: orderByList?.call(Permission.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Permission] matching the given query parameters.
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
  Future<Permission?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PermissionTable>? where,
    int? offset,
    _i1.OrderByBuilder<PermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PermissionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Permission>(
      where: where?.call(Permission.t),
      orderBy: orderBy?.call(Permission.t),
      orderByList: orderByList?.call(Permission.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Permission] by its [id] or null if no such row exists.
  Future<Permission?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Permission>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Permission]s in the list and returns the inserted rows.
  ///
  /// The returned [Permission]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Permission>> insert(
    _i1.Session session,
    List<Permission> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Permission>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Permission] and returns the inserted row.
  ///
  /// The returned [Permission] will have its `id` field set.
  Future<Permission> insertRow(
    _i1.Session session,
    Permission row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Permission>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Permission]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Permission>> update(
    _i1.Session session,
    List<Permission> rows, {
    _i1.ColumnSelections<PermissionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Permission>(
      rows,
      columns: columns?.call(Permission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Permission]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Permission> updateRow(
    _i1.Session session,
    Permission row, {
    _i1.ColumnSelections<PermissionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Permission>(
      row,
      columns: columns?.call(Permission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Permission] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Permission?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PermissionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Permission>(
      id,
      columnValues: columnValues(Permission.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Permission]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Permission>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PermissionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PermissionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PermissionTable>? orderBy,
    _i1.OrderByListBuilder<PermissionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Permission>(
      columnValues: columnValues(Permission.t.updateTable),
      where: where(Permission.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Permission.t),
      orderByList: orderByList?.call(Permission.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Permission]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Permission>> delete(
    _i1.Session session,
    List<Permission> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Permission>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Permission].
  Future<Permission> deleteRow(
    _i1.Session session,
    Permission row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Permission>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Permission>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PermissionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Permission>(
      where: where(Permission.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PermissionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Permission>(
      where: where?.call(Permission.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
