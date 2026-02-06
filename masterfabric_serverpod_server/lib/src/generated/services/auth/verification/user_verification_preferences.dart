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
import '../../../services/auth/verification/verification_channel.dart' as _i2;

/// User verification preferences for multi-channel code delivery
abstract class UserVerificationPreferences
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserVerificationPreferences._({
    this.id,
    required this.userId,
    required this.preferredChannel,
    this.phoneNumber,
    this.telegramChatId,
    required this.whatsappVerified,
    required this.telegramLinked,
    this.backupChannel,
    this.locale,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserVerificationPreferences({
    int? id,
    required String userId,
    required _i2.VerificationChannel preferredChannel,
    String? phoneNumber,
    String? telegramChatId,
    required bool whatsappVerified,
    required bool telegramLinked,
    _i2.VerificationChannel? backupChannel,
    String? locale,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserVerificationPreferencesImpl;

  factory UserVerificationPreferences.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UserVerificationPreferences(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      preferredChannel: _i2.VerificationChannel.fromJson(
        (jsonSerialization['preferredChannel'] as String),
      ),
      phoneNumber: jsonSerialization['phoneNumber'] as String?,
      telegramChatId: jsonSerialization['telegramChatId'] as String?,
      whatsappVerified: jsonSerialization['whatsappVerified'] as bool,
      telegramLinked: jsonSerialization['telegramLinked'] as bool,
      backupChannel: jsonSerialization['backupChannel'] == null
          ? null
          : _i2.VerificationChannel.fromJson(
              (jsonSerialization['backupChannel'] as String),
            ),
      locale: jsonSerialization['locale'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = UserVerificationPreferencesTable();

  static const db = UserVerificationPreferencesRepository._();

  @override
  int? id;

  /// User identifier (matches auth user id)
  String userId;

  /// Preferred verification channel
  _i2.VerificationChannel preferredChannel;

  /// Phone number for Telegram/WhatsApp verification (E.164 format)
  String? phoneNumber;

  /// Telegram chat ID (set when user starts conversation with bot)
  String? telegramChatId;

  /// Whether WhatsApp number has been verified
  bool whatsappVerified;

  /// Whether Telegram has been linked
  bool telegramLinked;

  /// Backup channel if primary fails
  _i2.VerificationChannel? backupChannel;

  /// Preferred locale for verification messages (e.g., 'en', 'tr', 'de', 'es')
  String? locale;

  /// Created timestamp
  DateTime createdAt;

  /// Last updated timestamp
  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserVerificationPreferences]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserVerificationPreferences copyWith({
    int? id,
    String? userId,
    _i2.VerificationChannel? preferredChannel,
    String? phoneNumber,
    String? telegramChatId,
    bool? whatsappVerified,
    bool? telegramLinked,
    _i2.VerificationChannel? backupChannel,
    String? locale,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserVerificationPreferences',
      if (id != null) 'id': id,
      'userId': userId,
      'preferredChannel': preferredChannel.toJson(),
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (telegramChatId != null) 'telegramChatId': telegramChatId,
      'whatsappVerified': whatsappVerified,
      'telegramLinked': telegramLinked,
      if (backupChannel != null) 'backupChannel': backupChannel?.toJson(),
      if (locale != null) 'locale': locale,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserVerificationPreferences',
      if (id != null) 'id': id,
      'userId': userId,
      'preferredChannel': preferredChannel.toJson(),
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (telegramChatId != null) 'telegramChatId': telegramChatId,
      'whatsappVerified': whatsappVerified,
      'telegramLinked': telegramLinked,
      if (backupChannel != null) 'backupChannel': backupChannel?.toJson(),
      if (locale != null) 'locale': locale,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static UserVerificationPreferencesInclude include() {
    return UserVerificationPreferencesInclude._();
  }

  static UserVerificationPreferencesIncludeList includeList({
    _i1.WhereExpressionBuilder<UserVerificationPreferencesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserVerificationPreferencesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserVerificationPreferencesTable>? orderByList,
    UserVerificationPreferencesInclude? include,
  }) {
    return UserVerificationPreferencesIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserVerificationPreferences.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserVerificationPreferences.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserVerificationPreferencesImpl extends UserVerificationPreferences {
  _UserVerificationPreferencesImpl({
    int? id,
    required String userId,
    required _i2.VerificationChannel preferredChannel,
    String? phoneNumber,
    String? telegramChatId,
    required bool whatsappVerified,
    required bool telegramLinked,
    _i2.VerificationChannel? backupChannel,
    String? locale,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         preferredChannel: preferredChannel,
         phoneNumber: phoneNumber,
         telegramChatId: telegramChatId,
         whatsappVerified: whatsappVerified,
         telegramLinked: telegramLinked,
         backupChannel: backupChannel,
         locale: locale,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserVerificationPreferences]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserVerificationPreferences copyWith({
    Object? id = _Undefined,
    String? userId,
    _i2.VerificationChannel? preferredChannel,
    Object? phoneNumber = _Undefined,
    Object? telegramChatId = _Undefined,
    bool? whatsappVerified,
    bool? telegramLinked,
    Object? backupChannel = _Undefined,
    Object? locale = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserVerificationPreferences(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      preferredChannel: preferredChannel ?? this.preferredChannel,
      phoneNumber: phoneNumber is String? ? phoneNumber : this.phoneNumber,
      telegramChatId: telegramChatId is String?
          ? telegramChatId
          : this.telegramChatId,
      whatsappVerified: whatsappVerified ?? this.whatsappVerified,
      telegramLinked: telegramLinked ?? this.telegramLinked,
      backupChannel: backupChannel is _i2.VerificationChannel?
          ? backupChannel
          : this.backupChannel,
      locale: locale is String? ? locale : this.locale,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserVerificationPreferencesUpdateTable
    extends _i1.UpdateTable<UserVerificationPreferencesTable> {
  UserVerificationPreferencesUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<_i2.VerificationChannel, _i2.VerificationChannel>
  preferredChannel(_i2.VerificationChannel value) => _i1.ColumnValue(
    table.preferredChannel,
    value,
  );

  _i1.ColumnValue<String, String> phoneNumber(String? value) => _i1.ColumnValue(
    table.phoneNumber,
    value,
  );

  _i1.ColumnValue<String, String> telegramChatId(String? value) =>
      _i1.ColumnValue(
        table.telegramChatId,
        value,
      );

  _i1.ColumnValue<bool, bool> whatsappVerified(bool value) => _i1.ColumnValue(
    table.whatsappVerified,
    value,
  );

  _i1.ColumnValue<bool, bool> telegramLinked(bool value) => _i1.ColumnValue(
    table.telegramLinked,
    value,
  );

  _i1.ColumnValue<_i2.VerificationChannel, _i2.VerificationChannel>
  backupChannel(_i2.VerificationChannel? value) => _i1.ColumnValue(
    table.backupChannel,
    value,
  );

  _i1.ColumnValue<String, String> locale(String? value) => _i1.ColumnValue(
    table.locale,
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

class UserVerificationPreferencesTable extends _i1.Table<int?> {
  UserVerificationPreferencesTable({super.tableRelation})
    : super(tableName: 'user_verification_preferences') {
    updateTable = UserVerificationPreferencesUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    preferredChannel = _i1.ColumnEnum(
      'preferredChannel',
      this,
      _i1.EnumSerialization.byName,
    );
    phoneNumber = _i1.ColumnString(
      'phoneNumber',
      this,
    );
    telegramChatId = _i1.ColumnString(
      'telegramChatId',
      this,
    );
    whatsappVerified = _i1.ColumnBool(
      'whatsappVerified',
      this,
    );
    telegramLinked = _i1.ColumnBool(
      'telegramLinked',
      this,
    );
    backupChannel = _i1.ColumnEnum(
      'backupChannel',
      this,
      _i1.EnumSerialization.byName,
    );
    locale = _i1.ColumnString(
      'locale',
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

  late final UserVerificationPreferencesUpdateTable updateTable;

  /// User identifier (matches auth user id)
  late final _i1.ColumnString userId;

  /// Preferred verification channel
  late final _i1.ColumnEnum<_i2.VerificationChannel> preferredChannel;

  /// Phone number for Telegram/WhatsApp verification (E.164 format)
  late final _i1.ColumnString phoneNumber;

  /// Telegram chat ID (set when user starts conversation with bot)
  late final _i1.ColumnString telegramChatId;

  /// Whether WhatsApp number has been verified
  late final _i1.ColumnBool whatsappVerified;

  /// Whether Telegram has been linked
  late final _i1.ColumnBool telegramLinked;

  /// Backup channel if primary fails
  late final _i1.ColumnEnum<_i2.VerificationChannel> backupChannel;

  /// Preferred locale for verification messages (e.g., 'en', 'tr', 'de', 'es')
  late final _i1.ColumnString locale;

  /// Created timestamp
  late final _i1.ColumnDateTime createdAt;

  /// Last updated timestamp
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    preferredChannel,
    phoneNumber,
    telegramChatId,
    whatsappVerified,
    telegramLinked,
    backupChannel,
    locale,
    createdAt,
    updatedAt,
  ];
}

class UserVerificationPreferencesInclude extends _i1.IncludeObject {
  UserVerificationPreferencesInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserVerificationPreferences.t;
}

class UserVerificationPreferencesIncludeList extends _i1.IncludeList {
  UserVerificationPreferencesIncludeList._({
    _i1.WhereExpressionBuilder<UserVerificationPreferencesTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserVerificationPreferences.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserVerificationPreferences.t;
}

class UserVerificationPreferencesRepository {
  const UserVerificationPreferencesRepository._();

  /// Returns a list of [UserVerificationPreferences]s matching the given query parameters.
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
  Future<List<UserVerificationPreferences>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserVerificationPreferencesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserVerificationPreferencesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserVerificationPreferencesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserVerificationPreferences>(
      where: where?.call(UserVerificationPreferences.t),
      orderBy: orderBy?.call(UserVerificationPreferences.t),
      orderByList: orderByList?.call(UserVerificationPreferences.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserVerificationPreferences] matching the given query parameters.
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
  Future<UserVerificationPreferences?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserVerificationPreferencesTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserVerificationPreferencesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserVerificationPreferencesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserVerificationPreferences>(
      where: where?.call(UserVerificationPreferences.t),
      orderBy: orderBy?.call(UserVerificationPreferences.t),
      orderByList: orderByList?.call(UserVerificationPreferences.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserVerificationPreferences] by its [id] or null if no such row exists.
  Future<UserVerificationPreferences?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserVerificationPreferences>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserVerificationPreferences]s in the list and returns the inserted rows.
  ///
  /// The returned [UserVerificationPreferences]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserVerificationPreferences>> insert(
    _i1.Session session,
    List<UserVerificationPreferences> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserVerificationPreferences>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserVerificationPreferences] and returns the inserted row.
  ///
  /// The returned [UserVerificationPreferences] will have its `id` field set.
  Future<UserVerificationPreferences> insertRow(
    _i1.Session session,
    UserVerificationPreferences row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserVerificationPreferences>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserVerificationPreferences]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserVerificationPreferences>> update(
    _i1.Session session,
    List<UserVerificationPreferences> rows, {
    _i1.ColumnSelections<UserVerificationPreferencesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserVerificationPreferences>(
      rows,
      columns: columns?.call(UserVerificationPreferences.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserVerificationPreferences]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserVerificationPreferences> updateRow(
    _i1.Session session,
    UserVerificationPreferences row, {
    _i1.ColumnSelections<UserVerificationPreferencesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserVerificationPreferences>(
      row,
      columns: columns?.call(UserVerificationPreferences.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserVerificationPreferences] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserVerificationPreferences?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserVerificationPreferencesUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserVerificationPreferences>(
      id,
      columnValues: columnValues(UserVerificationPreferences.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserVerificationPreferences]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserVerificationPreferences>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserVerificationPreferencesUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<UserVerificationPreferencesTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserVerificationPreferencesTable>? orderBy,
    _i1.OrderByListBuilder<UserVerificationPreferencesTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserVerificationPreferences>(
      columnValues: columnValues(UserVerificationPreferences.t.updateTable),
      where: where(UserVerificationPreferences.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserVerificationPreferences.t),
      orderByList: orderByList?.call(UserVerificationPreferences.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserVerificationPreferences]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserVerificationPreferences>> delete(
    _i1.Session session,
    List<UserVerificationPreferences> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserVerificationPreferences>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserVerificationPreferences].
  Future<UserVerificationPreferences> deleteRow(
    _i1.Session session,
    UserVerificationPreferences row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserVerificationPreferences>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserVerificationPreferences>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserVerificationPreferencesTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserVerificationPreferences>(
      where: where(UserVerificationPreferences.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserVerificationPreferencesTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserVerificationPreferences>(
      where: where?.call(UserVerificationPreferences.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
