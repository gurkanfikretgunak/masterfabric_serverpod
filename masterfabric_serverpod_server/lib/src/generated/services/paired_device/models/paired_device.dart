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
import '../../../services/paired_device/models/device_mode.dart' as _i2;

/// Paired device model - stores device pairing information
abstract class PairedDevice
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PairedDevice._({
    this.id,
    required this.userId,
    required this.deviceId,
    required this.deviceName,
    required this.platform,
    this.deviceFingerprint,
    this.ipAddress,
    this.userAgent,
    required this.isActive,
    required this.isTrusted,
    required this.deviceMode,
    required this.lastSeenAt,
    required this.pairedAt,
    this.metadata,
  });

  factory PairedDevice({
    int? id,
    required String userId,
    required String deviceId,
    required String deviceName,
    required String platform,
    String? deviceFingerprint,
    String? ipAddress,
    String? userAgent,
    required bool isActive,
    required bool isTrusted,
    required _i2.DeviceMode deviceMode,
    required DateTime lastSeenAt,
    required DateTime pairedAt,
    String? metadata,
  }) = _PairedDeviceImpl;

  factory PairedDevice.fromJson(Map<String, dynamic> jsonSerialization) {
    return PairedDevice(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      deviceId: jsonSerialization['deviceId'] as String,
      deviceName: jsonSerialization['deviceName'] as String,
      platform: jsonSerialization['platform'] as String,
      deviceFingerprint: jsonSerialization['deviceFingerprint'] as String?,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      userAgent: jsonSerialization['userAgent'] as String?,
      isActive: jsonSerialization['isActive'] as bool,
      isTrusted: jsonSerialization['isTrusted'] as bool,
      deviceMode: _i2.DeviceMode.fromJson(
        (jsonSerialization['deviceMode'] as String),
      ),
      lastSeenAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastSeenAt'],
      ),
      pairedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['pairedAt'],
      ),
      metadata: jsonSerialization['metadata'] as String?,
    );
  }

  static final t = PairedDeviceTable();

  static const db = PairedDeviceRepository._();

  @override
  int? id;

  String userId;

  String deviceId;

  String deviceName;

  String platform;

  String? deviceFingerprint;

  String? ipAddress;

  String? userAgent;

  bool isActive;

  bool isTrusted;

  _i2.DeviceMode deviceMode;

  DateTime lastSeenAt;

  DateTime pairedAt;

  String? metadata;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PairedDevice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PairedDevice copyWith({
    int? id,
    String? userId,
    String? deviceId,
    String? deviceName,
    String? platform,
    String? deviceFingerprint,
    String? ipAddress,
    String? userAgent,
    bool? isActive,
    bool? isTrusted,
    _i2.DeviceMode? deviceMode,
    DateTime? lastSeenAt,
    DateTime? pairedAt,
    String? metadata,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PairedDevice',
      if (id != null) 'id': id,
      'userId': userId,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'platform': platform,
      if (deviceFingerprint != null) 'deviceFingerprint': deviceFingerprint,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (userAgent != null) 'userAgent': userAgent,
      'isActive': isActive,
      'isTrusted': isTrusted,
      'deviceMode': deviceMode.toJson(),
      'lastSeenAt': lastSeenAt.toJson(),
      'pairedAt': pairedAt.toJson(),
      if (metadata != null) 'metadata': metadata,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PairedDevice',
      if (id != null) 'id': id,
      'userId': userId,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'platform': platform,
      if (deviceFingerprint != null) 'deviceFingerprint': deviceFingerprint,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (userAgent != null) 'userAgent': userAgent,
      'isActive': isActive,
      'isTrusted': isTrusted,
      'deviceMode': deviceMode.toJson(),
      'lastSeenAt': lastSeenAt.toJson(),
      'pairedAt': pairedAt.toJson(),
      if (metadata != null) 'metadata': metadata,
    };
  }

  static PairedDeviceInclude include() {
    return PairedDeviceInclude._();
  }

  static PairedDeviceIncludeList includeList({
    _i1.WhereExpressionBuilder<PairedDeviceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PairedDeviceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PairedDeviceTable>? orderByList,
    PairedDeviceInclude? include,
  }) {
    return PairedDeviceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PairedDevice.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PairedDevice.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PairedDeviceImpl extends PairedDevice {
  _PairedDeviceImpl({
    int? id,
    required String userId,
    required String deviceId,
    required String deviceName,
    required String platform,
    String? deviceFingerprint,
    String? ipAddress,
    String? userAgent,
    required bool isActive,
    required bool isTrusted,
    required _i2.DeviceMode deviceMode,
    required DateTime lastSeenAt,
    required DateTime pairedAt,
    String? metadata,
  }) : super._(
         id: id,
         userId: userId,
         deviceId: deviceId,
         deviceName: deviceName,
         platform: platform,
         deviceFingerprint: deviceFingerprint,
         ipAddress: ipAddress,
         userAgent: userAgent,
         isActive: isActive,
         isTrusted: isTrusted,
         deviceMode: deviceMode,
         lastSeenAt: lastSeenAt,
         pairedAt: pairedAt,
         metadata: metadata,
       );

  /// Returns a shallow copy of this [PairedDevice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PairedDevice copyWith({
    Object? id = _Undefined,
    String? userId,
    String? deviceId,
    String? deviceName,
    String? platform,
    Object? deviceFingerprint = _Undefined,
    Object? ipAddress = _Undefined,
    Object? userAgent = _Undefined,
    bool? isActive,
    bool? isTrusted,
    _i2.DeviceMode? deviceMode,
    DateTime? lastSeenAt,
    DateTime? pairedAt,
    Object? metadata = _Undefined,
  }) {
    return PairedDevice(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      platform: platform ?? this.platform,
      deviceFingerprint: deviceFingerprint is String?
          ? deviceFingerprint
          : this.deviceFingerprint,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      userAgent: userAgent is String? ? userAgent : this.userAgent,
      isActive: isActive ?? this.isActive,
      isTrusted: isTrusted ?? this.isTrusted,
      deviceMode: deviceMode ?? this.deviceMode,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      pairedAt: pairedAt ?? this.pairedAt,
      metadata: metadata is String? ? metadata : this.metadata,
    );
  }
}

class PairedDeviceUpdateTable extends _i1.UpdateTable<PairedDeviceTable> {
  PairedDeviceUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> deviceId(String value) => _i1.ColumnValue(
    table.deviceId,
    value,
  );

  _i1.ColumnValue<String, String> deviceName(String value) => _i1.ColumnValue(
    table.deviceName,
    value,
  );

  _i1.ColumnValue<String, String> platform(String value) => _i1.ColumnValue(
    table.platform,
    value,
  );

  _i1.ColumnValue<String, String> deviceFingerprint(String? value) =>
      _i1.ColumnValue(
        table.deviceFingerprint,
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

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<bool, bool> isTrusted(bool value) => _i1.ColumnValue(
    table.isTrusted,
    value,
  );

  _i1.ColumnValue<_i2.DeviceMode, _i2.DeviceMode> deviceMode(
    _i2.DeviceMode value,
  ) => _i1.ColumnValue(
    table.deviceMode,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastSeenAt(DateTime value) =>
      _i1.ColumnValue(
        table.lastSeenAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> pairedAt(DateTime value) =>
      _i1.ColumnValue(
        table.pairedAt,
        value,
      );

  _i1.ColumnValue<String, String> metadata(String? value) => _i1.ColumnValue(
    table.metadata,
    value,
  );
}

class PairedDeviceTable extends _i1.Table<int?> {
  PairedDeviceTable({super.tableRelation})
    : super(tableName: 'paired_devices') {
    updateTable = PairedDeviceUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    deviceId = _i1.ColumnString(
      'deviceId',
      this,
    );
    deviceName = _i1.ColumnString(
      'deviceName',
      this,
    );
    platform = _i1.ColumnString(
      'platform',
      this,
    );
    deviceFingerprint = _i1.ColumnString(
      'deviceFingerprint',
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
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
    isTrusted = _i1.ColumnBool(
      'isTrusted',
      this,
    );
    deviceMode = _i1.ColumnEnum(
      'deviceMode',
      this,
      _i1.EnumSerialization.byName,
    );
    lastSeenAt = _i1.ColumnDateTime(
      'lastSeenAt',
      this,
    );
    pairedAt = _i1.ColumnDateTime(
      'pairedAt',
      this,
    );
    metadata = _i1.ColumnString(
      'metadata',
      this,
    );
  }

  late final PairedDeviceUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnString deviceId;

  late final _i1.ColumnString deviceName;

  late final _i1.ColumnString platform;

  late final _i1.ColumnString deviceFingerprint;

  late final _i1.ColumnString ipAddress;

  late final _i1.ColumnString userAgent;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnBool isTrusted;

  late final _i1.ColumnEnum<_i2.DeviceMode> deviceMode;

  late final _i1.ColumnDateTime lastSeenAt;

  late final _i1.ColumnDateTime pairedAt;

  late final _i1.ColumnString metadata;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    deviceId,
    deviceName,
    platform,
    deviceFingerprint,
    ipAddress,
    userAgent,
    isActive,
    isTrusted,
    deviceMode,
    lastSeenAt,
    pairedAt,
    metadata,
  ];
}

class PairedDeviceInclude extends _i1.IncludeObject {
  PairedDeviceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PairedDevice.t;
}

class PairedDeviceIncludeList extends _i1.IncludeList {
  PairedDeviceIncludeList._({
    _i1.WhereExpressionBuilder<PairedDeviceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PairedDevice.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PairedDevice.t;
}

class PairedDeviceRepository {
  const PairedDeviceRepository._();

  /// Returns a list of [PairedDevice]s matching the given query parameters.
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
  Future<List<PairedDevice>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PairedDeviceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PairedDeviceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PairedDeviceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PairedDevice>(
      where: where?.call(PairedDevice.t),
      orderBy: orderBy?.call(PairedDevice.t),
      orderByList: orderByList?.call(PairedDevice.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PairedDevice] matching the given query parameters.
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
  Future<PairedDevice?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PairedDeviceTable>? where,
    int? offset,
    _i1.OrderByBuilder<PairedDeviceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PairedDeviceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PairedDevice>(
      where: where?.call(PairedDevice.t),
      orderBy: orderBy?.call(PairedDevice.t),
      orderByList: orderByList?.call(PairedDevice.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PairedDevice] by its [id] or null if no such row exists.
  Future<PairedDevice?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PairedDevice>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PairedDevice]s in the list and returns the inserted rows.
  ///
  /// The returned [PairedDevice]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PairedDevice>> insert(
    _i1.Session session,
    List<PairedDevice> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PairedDevice>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PairedDevice] and returns the inserted row.
  ///
  /// The returned [PairedDevice] will have its `id` field set.
  Future<PairedDevice> insertRow(
    _i1.Session session,
    PairedDevice row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PairedDevice>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PairedDevice]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PairedDevice>> update(
    _i1.Session session,
    List<PairedDevice> rows, {
    _i1.ColumnSelections<PairedDeviceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PairedDevice>(
      rows,
      columns: columns?.call(PairedDevice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PairedDevice]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PairedDevice> updateRow(
    _i1.Session session,
    PairedDevice row, {
    _i1.ColumnSelections<PairedDeviceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PairedDevice>(
      row,
      columns: columns?.call(PairedDevice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PairedDevice] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PairedDevice?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PairedDeviceUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PairedDevice>(
      id,
      columnValues: columnValues(PairedDevice.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PairedDevice]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PairedDevice>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PairedDeviceUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PairedDeviceTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PairedDeviceTable>? orderBy,
    _i1.OrderByListBuilder<PairedDeviceTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PairedDevice>(
      columnValues: columnValues(PairedDevice.t.updateTable),
      where: where(PairedDevice.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PairedDevice.t),
      orderByList: orderByList?.call(PairedDevice.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PairedDevice]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PairedDevice>> delete(
    _i1.Session session,
    List<PairedDevice> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PairedDevice>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PairedDevice].
  Future<PairedDevice> deleteRow(
    _i1.Session session,
    PairedDevice row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PairedDevice>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PairedDevice>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PairedDeviceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PairedDevice>(
      where: where(PairedDevice.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PairedDeviceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PairedDevice>(
      where: where?.call(PairedDevice.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
