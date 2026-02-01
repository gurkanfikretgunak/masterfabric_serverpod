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
import '../../../services/auth/user/gender.dart' as _i2;

/// Extended user profile data (stored in database)
abstract class UserProfileExtended
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserProfileExtended._({
    this.id,
    required this.userId,
    this.birthDate,
    this.gender,
  });

  factory UserProfileExtended({
    int? id,
    required String userId,
    DateTime? birthDate,
    _i2.Gender? gender,
  }) = _UserProfileExtendedImpl;

  factory UserProfileExtended.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfileExtended(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      birthDate: jsonSerialization['birthDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['birthDate']),
      gender: jsonSerialization['gender'] == null
          ? null
          : _i2.Gender.fromJson((jsonSerialization['gender'] as String)),
    );
  }

  static final t = UserProfileExtendedTable();

  static const db = UserProfileExtendedRepository._();

  @override
  int? id;

  String userId;

  DateTime? birthDate;

  _i2.Gender? gender;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserProfileExtended]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfileExtended copyWith({
    int? id,
    String? userId,
    DateTime? birthDate,
    _i2.Gender? gender,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserProfileExtended',
      if (id != null) 'id': id,
      'userId': userId,
      if (birthDate != null) 'birthDate': birthDate?.toJson(),
      if (gender != null) 'gender': gender?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserProfileExtended',
      if (id != null) 'id': id,
      'userId': userId,
      if (birthDate != null) 'birthDate': birthDate?.toJson(),
      if (gender != null) 'gender': gender?.toJson(),
    };
  }

  static UserProfileExtendedInclude include() {
    return UserProfileExtendedInclude._();
  }

  static UserProfileExtendedIncludeList includeList({
    _i1.WhereExpressionBuilder<UserProfileExtendedTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileExtendedTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileExtendedTable>? orderByList,
    UserProfileExtendedInclude? include,
  }) {
    return UserProfileExtendedIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfileExtended.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserProfileExtended.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileExtendedImpl extends UserProfileExtended {
  _UserProfileExtendedImpl({
    int? id,
    required String userId,
    DateTime? birthDate,
    _i2.Gender? gender,
  }) : super._(
         id: id,
         userId: userId,
         birthDate: birthDate,
         gender: gender,
       );

  /// Returns a shallow copy of this [UserProfileExtended]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfileExtended copyWith({
    Object? id = _Undefined,
    String? userId,
    Object? birthDate = _Undefined,
    Object? gender = _Undefined,
  }) {
    return UserProfileExtended(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      birthDate: birthDate is DateTime? ? birthDate : this.birthDate,
      gender: gender is _i2.Gender? ? gender : this.gender,
    );
  }
}

class UserProfileExtendedUpdateTable
    extends _i1.UpdateTable<UserProfileExtendedTable> {
  UserProfileExtendedUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> birthDate(DateTime? value) =>
      _i1.ColumnValue(
        table.birthDate,
        value,
      );

  _i1.ColumnValue<_i2.Gender, _i2.Gender> gender(_i2.Gender? value) =>
      _i1.ColumnValue(
        table.gender,
        value,
      );
}

class UserProfileExtendedTable extends _i1.Table<int?> {
  UserProfileExtendedTable({super.tableRelation})
    : super(tableName: 'user_profile_extended') {
    updateTable = UserProfileExtendedUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    birthDate = _i1.ColumnDateTime(
      'birthDate',
      this,
    );
    gender = _i1.ColumnEnum(
      'gender',
      this,
      _i1.EnumSerialization.byName,
    );
  }

  late final UserProfileExtendedUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnDateTime birthDate;

  late final _i1.ColumnEnum<_i2.Gender> gender;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    birthDate,
    gender,
  ];
}

class UserProfileExtendedInclude extends _i1.IncludeObject {
  UserProfileExtendedInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserProfileExtended.t;
}

class UserProfileExtendedIncludeList extends _i1.IncludeList {
  UserProfileExtendedIncludeList._({
    _i1.WhereExpressionBuilder<UserProfileExtendedTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserProfileExtended.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserProfileExtended.t;
}

class UserProfileExtendedRepository {
  const UserProfileExtendedRepository._();

  /// Returns a list of [UserProfileExtended]s matching the given query parameters.
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
  Future<List<UserProfileExtended>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileExtendedTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileExtendedTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileExtendedTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserProfileExtended>(
      where: where?.call(UserProfileExtended.t),
      orderBy: orderBy?.call(UserProfileExtended.t),
      orderByList: orderByList?.call(UserProfileExtended.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserProfileExtended] matching the given query parameters.
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
  Future<UserProfileExtended?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileExtendedTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserProfileExtendedTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileExtendedTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserProfileExtended>(
      where: where?.call(UserProfileExtended.t),
      orderBy: orderBy?.call(UserProfileExtended.t),
      orderByList: orderByList?.call(UserProfileExtended.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserProfileExtended] by its [id] or null if no such row exists.
  Future<UserProfileExtended?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserProfileExtended>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserProfileExtended]s in the list and returns the inserted rows.
  ///
  /// The returned [UserProfileExtended]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserProfileExtended>> insert(
    _i1.Session session,
    List<UserProfileExtended> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserProfileExtended>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserProfileExtended] and returns the inserted row.
  ///
  /// The returned [UserProfileExtended] will have its `id` field set.
  Future<UserProfileExtended> insertRow(
    _i1.Session session,
    UserProfileExtended row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserProfileExtended>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserProfileExtended]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserProfileExtended>> update(
    _i1.Session session,
    List<UserProfileExtended> rows, {
    _i1.ColumnSelections<UserProfileExtendedTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserProfileExtended>(
      rows,
      columns: columns?.call(UserProfileExtended.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProfileExtended]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserProfileExtended> updateRow(
    _i1.Session session,
    UserProfileExtended row, {
    _i1.ColumnSelections<UserProfileExtendedTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserProfileExtended>(
      row,
      columns: columns?.call(UserProfileExtended.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProfileExtended] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserProfileExtended?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserProfileExtendedUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserProfileExtended>(
      id,
      columnValues: columnValues(UserProfileExtended.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserProfileExtended]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserProfileExtended>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserProfileExtendedUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<UserProfileExtendedTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileExtendedTable>? orderBy,
    _i1.OrderByListBuilder<UserProfileExtendedTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserProfileExtended>(
      columnValues: columnValues(UserProfileExtended.t.updateTable),
      where: where(UserProfileExtended.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfileExtended.t),
      orderByList: orderByList?.call(UserProfileExtended.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserProfileExtended]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserProfileExtended>> delete(
    _i1.Session session,
    List<UserProfileExtended> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserProfileExtended>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserProfileExtended].
  Future<UserProfileExtended> deleteRow(
    _i1.Session session,
    UserProfileExtended row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserProfileExtended>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserProfileExtended>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserProfileExtendedTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserProfileExtended>(
      where: where(UserProfileExtended.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileExtendedTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserProfileExtended>(
      where: where?.call(UserProfileExtended.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
