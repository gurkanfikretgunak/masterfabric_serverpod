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

/// App configuration database table
/// Stores app configuration per environment and platform
abstract class AppConfigEntry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AppConfigEntry._({
    this.id,
    required this.environment,
    this.platform,
    required this.configJson,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory AppConfigEntry({
    int? id,
    required String environment,
    String? platform,
    required String configJson,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isActive,
  }) = _AppConfigEntryImpl;

  factory AppConfigEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppConfigEntry(
      id: jsonSerialization['id'] as int?,
      environment: jsonSerialization['environment'] as String,
      platform: jsonSerialization['platform'] as String?,
      configJson: jsonSerialization['configJson'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      isActive: jsonSerialization['isActive'] as bool,
    );
  }

  static final t = AppConfigEntryTable();

  static const db = AppConfigEntryRepository._();

  @override
  int? id;

  /// Environment name (development/staging/production)
  String environment;

  /// Platform identifier (ios/android/web/null for all platforms)
  String? platform;

  /// Configuration data as JSON string
  String configJson;

  /// When this configuration was created
  DateTime createdAt;

  /// When this configuration was last updated
  DateTime updatedAt;

  /// Whether this configuration is active
  bool isActive;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AppConfigEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppConfigEntry copyWith({
    int? id,
    String? environment,
    String? platform,
    String? configJson,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppConfigEntry',
      if (id != null) 'id': id,
      'environment': environment,
      if (platform != null) 'platform': platform,
      'configJson': configJson,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppConfigEntry',
      if (id != null) 'id': id,
      'environment': environment,
      if (platform != null) 'platform': platform,
      'configJson': configJson,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'isActive': isActive,
    };
  }

  static AppConfigEntryInclude include() {
    return AppConfigEntryInclude._();
  }

  static AppConfigEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<AppConfigEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppConfigEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppConfigEntryTable>? orderByList,
    AppConfigEntryInclude? include,
  }) {
    return AppConfigEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppConfigEntry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AppConfigEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppConfigEntryImpl extends AppConfigEntry {
  _AppConfigEntryImpl({
    int? id,
    required String environment,
    String? platform,
    required String configJson,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isActive,
  }) : super._(
         id: id,
         environment: environment,
         platform: platform,
         configJson: configJson,
         createdAt: createdAt,
         updatedAt: updatedAt,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [AppConfigEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppConfigEntry copyWith({
    Object? id = _Undefined,
    String? environment,
    Object? platform = _Undefined,
    String? configJson,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return AppConfigEntry(
      id: id is int? ? id : this.id,
      environment: environment ?? this.environment,
      platform: platform is String? ? platform : this.platform,
      configJson: configJson ?? this.configJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class AppConfigEntryUpdateTable extends _i1.UpdateTable<AppConfigEntryTable> {
  AppConfigEntryUpdateTable(super.table);

  _i1.ColumnValue<String, String> environment(String value) => _i1.ColumnValue(
    table.environment,
    value,
  );

  _i1.ColumnValue<String, String> platform(String? value) => _i1.ColumnValue(
    table.platform,
    value,
  );

  _i1.ColumnValue<String, String> configJson(String value) => _i1.ColumnValue(
    table.configJson,
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

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );
}

class AppConfigEntryTable extends _i1.Table<int?> {
  AppConfigEntryTable({super.tableRelation})
    : super(tableName: 'app_config_entry') {
    updateTable = AppConfigEntryUpdateTable(this);
    environment = _i1.ColumnString(
      'environment',
      this,
    );
    platform = _i1.ColumnString(
      'platform',
      this,
    );
    configJson = _i1.ColumnString(
      'configJson',
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
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
  }

  late final AppConfigEntryUpdateTable updateTable;

  /// Environment name (development/staging/production)
  late final _i1.ColumnString environment;

  /// Platform identifier (ios/android/web/null for all platforms)
  late final _i1.ColumnString platform;

  /// Configuration data as JSON string
  late final _i1.ColumnString configJson;

  /// When this configuration was created
  late final _i1.ColumnDateTime createdAt;

  /// When this configuration was last updated
  late final _i1.ColumnDateTime updatedAt;

  /// Whether this configuration is active
  late final _i1.ColumnBool isActive;

  @override
  List<_i1.Column> get columns => [
    id,
    environment,
    platform,
    configJson,
    createdAt,
    updatedAt,
    isActive,
  ];
}

class AppConfigEntryInclude extends _i1.IncludeObject {
  AppConfigEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AppConfigEntry.t;
}

class AppConfigEntryIncludeList extends _i1.IncludeList {
  AppConfigEntryIncludeList._({
    _i1.WhereExpressionBuilder<AppConfigEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppConfigEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AppConfigEntry.t;
}

class AppConfigEntryRepository {
  const AppConfigEntryRepository._();

  /// Returns a list of [AppConfigEntry]s matching the given query parameters.
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
  Future<List<AppConfigEntry>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppConfigEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppConfigEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppConfigEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AppConfigEntry>(
      where: where?.call(AppConfigEntry.t),
      orderBy: orderBy?.call(AppConfigEntry.t),
      orderByList: orderByList?.call(AppConfigEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AppConfigEntry] matching the given query parameters.
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
  Future<AppConfigEntry?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppConfigEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<AppConfigEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppConfigEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AppConfigEntry>(
      where: where?.call(AppConfigEntry.t),
      orderBy: orderBy?.call(AppConfigEntry.t),
      orderByList: orderByList?.call(AppConfigEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AppConfigEntry] by its [id] or null if no such row exists.
  Future<AppConfigEntry?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AppConfigEntry>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AppConfigEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [AppConfigEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AppConfigEntry>> insert(
    _i1.Session session,
    List<AppConfigEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AppConfigEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AppConfigEntry] and returns the inserted row.
  ///
  /// The returned [AppConfigEntry] will have its `id` field set.
  Future<AppConfigEntry> insertRow(
    _i1.Session session,
    AppConfigEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppConfigEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AppConfigEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AppConfigEntry>> update(
    _i1.Session session,
    List<AppConfigEntry> rows, {
    _i1.ColumnSelections<AppConfigEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AppConfigEntry>(
      rows,
      columns: columns?.call(AppConfigEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppConfigEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppConfigEntry> updateRow(
    _i1.Session session,
    AppConfigEntry row, {
    _i1.ColumnSelections<AppConfigEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppConfigEntry>(
      row,
      columns: columns?.call(AppConfigEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppConfigEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AppConfigEntry?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AppConfigEntryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AppConfigEntry>(
      id,
      columnValues: columnValues(AppConfigEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppConfigEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AppConfigEntry>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AppConfigEntryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AppConfigEntryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppConfigEntryTable>? orderBy,
    _i1.OrderByListBuilder<AppConfigEntryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AppConfigEntry>(
      columnValues: columnValues(AppConfigEntry.t.updateTable),
      where: where(AppConfigEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppConfigEntry.t),
      orderByList: orderByList?.call(AppConfigEntry.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AppConfigEntry]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AppConfigEntry>> delete(
    _i1.Session session,
    List<AppConfigEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AppConfigEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AppConfigEntry].
  Future<AppConfigEntry> deleteRow(
    _i1.Session session,
    AppConfigEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppConfigEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AppConfigEntry>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AppConfigEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AppConfigEntry>(
      where: where(AppConfigEntry.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppConfigEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AppConfigEntry>(
      where: where?.call(AppConfigEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
