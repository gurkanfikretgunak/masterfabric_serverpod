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

/// User app settings model (stored per user in database)
abstract class UserAppSettings
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserAppSettings._({
    this.id,
    required this.userId,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.notificationSound,
    required this.analytics,
    required this.crashReports,
    required this.twoFactorEnabled,
    this.accountDeletionRequested,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserAppSettings({
    int? id,
    required String userId,
    required bool pushNotifications,
    required bool emailNotifications,
    required bool notificationSound,
    required bool analytics,
    required bool crashReports,
    required bool twoFactorEnabled,
    bool? accountDeletionRequested,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserAppSettingsImpl;

  factory UserAppSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserAppSettings(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      pushNotifications: jsonSerialization['pushNotifications'] as bool,
      emailNotifications: jsonSerialization['emailNotifications'] as bool,
      notificationSound: jsonSerialization['notificationSound'] as bool,
      analytics: jsonSerialization['analytics'] as bool,
      crashReports: jsonSerialization['crashReports'] as bool,
      twoFactorEnabled: jsonSerialization['twoFactorEnabled'] as bool,
      accountDeletionRequested:
          jsonSerialization['accountDeletionRequested'] as bool?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = UserAppSettingsTable();

  static const db = UserAppSettingsRepository._();

  @override
  int? id;

  String userId;

  bool pushNotifications;

  bool emailNotifications;

  bool notificationSound;

  bool analytics;

  bool crashReports;

  bool twoFactorEnabled;

  bool? accountDeletionRequested;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserAppSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserAppSettings copyWith({
    int? id,
    String? userId,
    bool? pushNotifications,
    bool? emailNotifications,
    bool? notificationSound,
    bool? analytics,
    bool? crashReports,
    bool? twoFactorEnabled,
    bool? accountDeletionRequested,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserAppSettings',
      if (id != null) 'id': id,
      'userId': userId,
      'pushNotifications': pushNotifications,
      'emailNotifications': emailNotifications,
      'notificationSound': notificationSound,
      'analytics': analytics,
      'crashReports': crashReports,
      'twoFactorEnabled': twoFactorEnabled,
      if (accountDeletionRequested != null)
        'accountDeletionRequested': accountDeletionRequested,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserAppSettings',
      if (id != null) 'id': id,
      'userId': userId,
      'pushNotifications': pushNotifications,
      'emailNotifications': emailNotifications,
      'notificationSound': notificationSound,
      'analytics': analytics,
      'crashReports': crashReports,
      'twoFactorEnabled': twoFactorEnabled,
      if (accountDeletionRequested != null)
        'accountDeletionRequested': accountDeletionRequested,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static UserAppSettingsInclude include() {
    return UserAppSettingsInclude._();
  }

  static UserAppSettingsIncludeList includeList({
    _i1.WhereExpressionBuilder<UserAppSettingsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserAppSettingsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserAppSettingsTable>? orderByList,
    UserAppSettingsInclude? include,
  }) {
    return UserAppSettingsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserAppSettings.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserAppSettings.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserAppSettingsImpl extends UserAppSettings {
  _UserAppSettingsImpl({
    int? id,
    required String userId,
    required bool pushNotifications,
    required bool emailNotifications,
    required bool notificationSound,
    required bool analytics,
    required bool crashReports,
    required bool twoFactorEnabled,
    bool? accountDeletionRequested,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         pushNotifications: pushNotifications,
         emailNotifications: emailNotifications,
         notificationSound: notificationSound,
         analytics: analytics,
         crashReports: crashReports,
         twoFactorEnabled: twoFactorEnabled,
         accountDeletionRequested: accountDeletionRequested,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserAppSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserAppSettings copyWith({
    Object? id = _Undefined,
    String? userId,
    bool? pushNotifications,
    bool? emailNotifications,
    bool? notificationSound,
    bool? analytics,
    bool? crashReports,
    bool? twoFactorEnabled,
    Object? accountDeletionRequested = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserAppSettings(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      notificationSound: notificationSound ?? this.notificationSound,
      analytics: analytics ?? this.analytics,
      crashReports: crashReports ?? this.crashReports,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      accountDeletionRequested: accountDeletionRequested is bool?
          ? accountDeletionRequested
          : this.accountDeletionRequested,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserAppSettingsUpdateTable extends _i1.UpdateTable<UserAppSettingsTable> {
  UserAppSettingsUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<bool, bool> pushNotifications(bool value) => _i1.ColumnValue(
    table.pushNotifications,
    value,
  );

  _i1.ColumnValue<bool, bool> emailNotifications(bool value) => _i1.ColumnValue(
    table.emailNotifications,
    value,
  );

  _i1.ColumnValue<bool, bool> notificationSound(bool value) => _i1.ColumnValue(
    table.notificationSound,
    value,
  );

  _i1.ColumnValue<bool, bool> analytics(bool value) => _i1.ColumnValue(
    table.analytics,
    value,
  );

  _i1.ColumnValue<bool, bool> crashReports(bool value) => _i1.ColumnValue(
    table.crashReports,
    value,
  );

  _i1.ColumnValue<bool, bool> twoFactorEnabled(bool value) => _i1.ColumnValue(
    table.twoFactorEnabled,
    value,
  );

  _i1.ColumnValue<bool, bool> accountDeletionRequested(bool? value) =>
      _i1.ColumnValue(
        table.accountDeletionRequested,
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

class UserAppSettingsTable extends _i1.Table<int?> {
  UserAppSettingsTable({super.tableRelation})
    : super(tableName: 'user_app_settings') {
    updateTable = UserAppSettingsUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    pushNotifications = _i1.ColumnBool(
      'pushNotifications',
      this,
    );
    emailNotifications = _i1.ColumnBool(
      'emailNotifications',
      this,
    );
    notificationSound = _i1.ColumnBool(
      'notificationSound',
      this,
    );
    analytics = _i1.ColumnBool(
      'analytics',
      this,
    );
    crashReports = _i1.ColumnBool(
      'crashReports',
      this,
    );
    twoFactorEnabled = _i1.ColumnBool(
      'twoFactorEnabled',
      this,
    );
    accountDeletionRequested = _i1.ColumnBool(
      'accountDeletionRequested',
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

  late final UserAppSettingsUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnBool pushNotifications;

  late final _i1.ColumnBool emailNotifications;

  late final _i1.ColumnBool notificationSound;

  late final _i1.ColumnBool analytics;

  late final _i1.ColumnBool crashReports;

  late final _i1.ColumnBool twoFactorEnabled;

  late final _i1.ColumnBool accountDeletionRequested;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    pushNotifications,
    emailNotifications,
    notificationSound,
    analytics,
    crashReports,
    twoFactorEnabled,
    accountDeletionRequested,
    createdAt,
    updatedAt,
  ];
}

class UserAppSettingsInclude extends _i1.IncludeObject {
  UserAppSettingsInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserAppSettings.t;
}

class UserAppSettingsIncludeList extends _i1.IncludeList {
  UserAppSettingsIncludeList._({
    _i1.WhereExpressionBuilder<UserAppSettingsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserAppSettings.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserAppSettings.t;
}

class UserAppSettingsRepository {
  const UserAppSettingsRepository._();

  /// Returns a list of [UserAppSettings]s matching the given query parameters.
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
  Future<List<UserAppSettings>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserAppSettingsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserAppSettingsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserAppSettingsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserAppSettings>(
      where: where?.call(UserAppSettings.t),
      orderBy: orderBy?.call(UserAppSettings.t),
      orderByList: orderByList?.call(UserAppSettings.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserAppSettings] matching the given query parameters.
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
  Future<UserAppSettings?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserAppSettingsTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserAppSettingsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserAppSettingsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserAppSettings>(
      where: where?.call(UserAppSettings.t),
      orderBy: orderBy?.call(UserAppSettings.t),
      orderByList: orderByList?.call(UserAppSettings.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserAppSettings] by its [id] or null if no such row exists.
  Future<UserAppSettings?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserAppSettings>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserAppSettings]s in the list and returns the inserted rows.
  ///
  /// The returned [UserAppSettings]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserAppSettings>> insert(
    _i1.Session session,
    List<UserAppSettings> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserAppSettings>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserAppSettings] and returns the inserted row.
  ///
  /// The returned [UserAppSettings] will have its `id` field set.
  Future<UserAppSettings> insertRow(
    _i1.Session session,
    UserAppSettings row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserAppSettings>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserAppSettings]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserAppSettings>> update(
    _i1.Session session,
    List<UserAppSettings> rows, {
    _i1.ColumnSelections<UserAppSettingsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserAppSettings>(
      rows,
      columns: columns?.call(UserAppSettings.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserAppSettings]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserAppSettings> updateRow(
    _i1.Session session,
    UserAppSettings row, {
    _i1.ColumnSelections<UserAppSettingsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserAppSettings>(
      row,
      columns: columns?.call(UserAppSettings.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserAppSettings] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserAppSettings?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserAppSettingsUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserAppSettings>(
      id,
      columnValues: columnValues(UserAppSettings.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserAppSettings]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserAppSettings>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserAppSettingsUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<UserAppSettingsTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserAppSettingsTable>? orderBy,
    _i1.OrderByListBuilder<UserAppSettingsTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserAppSettings>(
      columnValues: columnValues(UserAppSettings.t.updateTable),
      where: where(UserAppSettings.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserAppSettings.t),
      orderByList: orderByList?.call(UserAppSettings.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserAppSettings]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserAppSettings>> delete(
    _i1.Session session,
    List<UserAppSettings> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserAppSettings>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserAppSettings].
  Future<UserAppSettings> deleteRow(
    _i1.Session session,
    UserAppSettings row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserAppSettings>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserAppSettings>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserAppSettingsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserAppSettings>(
      where: where(UserAppSettings.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserAppSettingsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserAppSettings>(
      where: where?.call(UserAppSettings.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
