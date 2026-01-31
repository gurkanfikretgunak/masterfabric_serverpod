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

/// Translation database table
/// Stores translations per locale and namespace
abstract class TranslationEntry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TranslationEntry._({
    this.id,
    required this.locale,
    this.namespace,
    required this.translationsJson,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory TranslationEntry({
    int? id,
    required String locale,
    String? namespace,
    required String translationsJson,
    required int version,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isActive,
  }) = _TranslationEntryImpl;

  factory TranslationEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return TranslationEntry(
      id: jsonSerialization['id'] as int?,
      locale: jsonSerialization['locale'] as String,
      namespace: jsonSerialization['namespace'] as String?,
      translationsJson: jsonSerialization['translationsJson'] as String,
      version: jsonSerialization['version'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      isActive: jsonSerialization['isActive'] as bool,
    );
  }

  static final t = TranslationEntryTable();

  static const db = TranslationEntryRepository._();

  @override
  int? id;

  /// Locale code (e.g., 'en', 'tr', 'de')
  String locale;

  /// Namespace identifier (optional, for organizing translations)
  String? namespace;

  /// Translations data as JSON string (slang format)
  String translationsJson;

  /// Version number for cache invalidation
  int version;

  /// When this translation was created
  DateTime createdAt;

  /// When this translation was last updated
  DateTime updatedAt;

  /// Whether this translation is active
  bool isActive;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TranslationEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TranslationEntry copyWith({
    int? id,
    String? locale,
    String? namespace,
    String? translationsJson,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TranslationEntry',
      if (id != null) 'id': id,
      'locale': locale,
      if (namespace != null) 'namespace': namespace,
      'translationsJson': translationsJson,
      'version': version,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TranslationEntry',
      if (id != null) 'id': id,
      'locale': locale,
      if (namespace != null) 'namespace': namespace,
      'translationsJson': translationsJson,
      'version': version,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'isActive': isActive,
    };
  }

  static TranslationEntryInclude include() {
    return TranslationEntryInclude._();
  }

  static TranslationEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<TranslationEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TranslationEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TranslationEntryTable>? orderByList,
    TranslationEntryInclude? include,
  }) {
    return TranslationEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TranslationEntry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TranslationEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TranslationEntryImpl extends TranslationEntry {
  _TranslationEntryImpl({
    int? id,
    required String locale,
    String? namespace,
    required String translationsJson,
    required int version,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isActive,
  }) : super._(
         id: id,
         locale: locale,
         namespace: namespace,
         translationsJson: translationsJson,
         version: version,
         createdAt: createdAt,
         updatedAt: updatedAt,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [TranslationEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TranslationEntry copyWith({
    Object? id = _Undefined,
    String? locale,
    Object? namespace = _Undefined,
    String? translationsJson,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return TranslationEntry(
      id: id is int? ? id : this.id,
      locale: locale ?? this.locale,
      namespace: namespace is String? ? namespace : this.namespace,
      translationsJson: translationsJson ?? this.translationsJson,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class TranslationEntryUpdateTable
    extends _i1.UpdateTable<TranslationEntryTable> {
  TranslationEntryUpdateTable(super.table);

  _i1.ColumnValue<String, String> locale(String value) => _i1.ColumnValue(
    table.locale,
    value,
  );

  _i1.ColumnValue<String, String> namespace(String? value) => _i1.ColumnValue(
    table.namespace,
    value,
  );

  _i1.ColumnValue<String, String> translationsJson(String value) =>
      _i1.ColumnValue(
        table.translationsJson,
        value,
      );

  _i1.ColumnValue<int, int> version(int value) => _i1.ColumnValue(
    table.version,
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

class TranslationEntryTable extends _i1.Table<int?> {
  TranslationEntryTable({super.tableRelation})
    : super(tableName: 'translation_entry') {
    updateTable = TranslationEntryUpdateTable(this);
    locale = _i1.ColumnString(
      'locale',
      this,
    );
    namespace = _i1.ColumnString(
      'namespace',
      this,
    );
    translationsJson = _i1.ColumnString(
      'translationsJson',
      this,
    );
    version = _i1.ColumnInt(
      'version',
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

  late final TranslationEntryUpdateTable updateTable;

  /// Locale code (e.g., 'en', 'tr', 'de')
  late final _i1.ColumnString locale;

  /// Namespace identifier (optional, for organizing translations)
  late final _i1.ColumnString namespace;

  /// Translations data as JSON string (slang format)
  late final _i1.ColumnString translationsJson;

  /// Version number for cache invalidation
  late final _i1.ColumnInt version;

  /// When this translation was created
  late final _i1.ColumnDateTime createdAt;

  /// When this translation was last updated
  late final _i1.ColumnDateTime updatedAt;

  /// Whether this translation is active
  late final _i1.ColumnBool isActive;

  @override
  List<_i1.Column> get columns => [
    id,
    locale,
    namespace,
    translationsJson,
    version,
    createdAt,
    updatedAt,
    isActive,
  ];
}

class TranslationEntryInclude extends _i1.IncludeObject {
  TranslationEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TranslationEntry.t;
}

class TranslationEntryIncludeList extends _i1.IncludeList {
  TranslationEntryIncludeList._({
    _i1.WhereExpressionBuilder<TranslationEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TranslationEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TranslationEntry.t;
}

class TranslationEntryRepository {
  const TranslationEntryRepository._();

  /// Returns a list of [TranslationEntry]s matching the given query parameters.
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
  Future<List<TranslationEntry>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TranslationEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TranslationEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TranslationEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TranslationEntry>(
      where: where?.call(TranslationEntry.t),
      orderBy: orderBy?.call(TranslationEntry.t),
      orderByList: orderByList?.call(TranslationEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TranslationEntry] matching the given query parameters.
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
  Future<TranslationEntry?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TranslationEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<TranslationEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TranslationEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TranslationEntry>(
      where: where?.call(TranslationEntry.t),
      orderBy: orderBy?.call(TranslationEntry.t),
      orderByList: orderByList?.call(TranslationEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TranslationEntry] by its [id] or null if no such row exists.
  Future<TranslationEntry?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TranslationEntry>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TranslationEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [TranslationEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TranslationEntry>> insert(
    _i1.Session session,
    List<TranslationEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TranslationEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TranslationEntry] and returns the inserted row.
  ///
  /// The returned [TranslationEntry] will have its `id` field set.
  Future<TranslationEntry> insertRow(
    _i1.Session session,
    TranslationEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TranslationEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TranslationEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TranslationEntry>> update(
    _i1.Session session,
    List<TranslationEntry> rows, {
    _i1.ColumnSelections<TranslationEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TranslationEntry>(
      rows,
      columns: columns?.call(TranslationEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TranslationEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TranslationEntry> updateRow(
    _i1.Session session,
    TranslationEntry row, {
    _i1.ColumnSelections<TranslationEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TranslationEntry>(
      row,
      columns: columns?.call(TranslationEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TranslationEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TranslationEntry?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TranslationEntryUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TranslationEntry>(
      id,
      columnValues: columnValues(TranslationEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TranslationEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TranslationEntry>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TranslationEntryUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<TranslationEntryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TranslationEntryTable>? orderBy,
    _i1.OrderByListBuilder<TranslationEntryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TranslationEntry>(
      columnValues: columnValues(TranslationEntry.t.updateTable),
      where: where(TranslationEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TranslationEntry.t),
      orderByList: orderByList?.call(TranslationEntry.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TranslationEntry]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TranslationEntry>> delete(
    _i1.Session session,
    List<TranslationEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TranslationEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TranslationEntry].
  Future<TranslationEntry> deleteRow(
    _i1.Session session,
    TranslationEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TranslationEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TranslationEntry>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TranslationEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TranslationEntry>(
      where: where(TranslationEntry.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TranslationEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TranslationEntry>(
      where: where?.call(TranslationEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
