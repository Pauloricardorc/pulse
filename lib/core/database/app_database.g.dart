// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ServicesTable extends Services with TableInfo<$ServicesTable, Service> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'services';
  @override
  VerificationContext validateIntegrity(
    Insertable<Service> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Service map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Service(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ServicesTable createAlias(String alias) {
    return $ServicesTable(attachedDatabase, alias);
  }
}

class Service extends DataClass implements Insertable<Service> {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;
  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ServicesCompanion toCompanion(bool nullToAbsent) {
    return ServicesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory Service.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Service(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Service copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt,
  }) => Service(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    createdAt: createdAt ?? this.createdAt,
  );
  Service copyWithCompanion(ServicesCompanion data) {
    return Service(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Service(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Service &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class ServicesCompanion extends UpdateCompanion<Service> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<DateTime> createdAt;
  const ServicesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ServicesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Service> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ServicesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? description,
    Value<DateTime>? createdAt,
  }) {
    return ServicesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EnvironmentsTable extends Environments
    with TableInfo<$EnvironmentsTable, Environment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnvironmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serviceIdMeta = const VerificationMeta(
    'serviceId',
  );
  @override
  late final GeneratedColumn<int> serviceId = GeneratedColumn<int>(
    'service_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES services (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('GET'),
  );
  static const VerificationMeta _headersJsonMeta = const VerificationMeta(
    'headersJson',
  );
  @override
  late final GeneratedColumn<String> headersJson = GeneratedColumn<String>(
    'headers_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _matchTypeMeta = const VerificationMeta(
    'matchType',
  );
  @override
  late final GeneratedColumn<String> matchType = GeneratedColumn<String>(
    'match_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('status'),
  );
  static const VerificationMeta _matchValueMeta = const VerificationMeta(
    'matchValue',
  );
  @override
  late final GeneratedColumn<String> matchValue = GeneratedColumn<String>(
    'match_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('200'),
  );
  static const VerificationMeta _statusRangeFromMeta = const VerificationMeta(
    'statusRangeFrom',
  );
  @override
  late final GeneratedColumn<int> statusRangeFrom = GeneratedColumn<int>(
    'status_range_from',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(200),
  );
  static const VerificationMeta _statusRangeToMeta = const VerificationMeta(
    'statusRangeTo',
  );
  @override
  late final GeneratedColumn<int> statusRangeTo = GeneratedColumn<int>(
    'status_range_to',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(299),
  );
  static const VerificationMeta _timeoutMsMeta = const VerificationMeta(
    'timeoutMs',
  );
  @override
  late final GeneratedColumn<int> timeoutMs = GeneratedColumn<int>(
    'timeout_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10000),
  );
  static const VerificationMeta _checkIntervalSecondsMeta =
      const VerificationMeta('checkIntervalSeconds');
  @override
  late final GeneratedColumn<int> checkIntervalSeconds = GeneratedColumn<int>(
    'check_interval_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serviceId,
    name,
    url,
    role,
    method,
    headersJson,
    body,
    matchType,
    matchValue,
    statusRangeFrom,
    statusRangeTo,
    timeoutMs,
    checkIntervalSeconds,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'environments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Environment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('service_id')) {
      context.handle(
        _serviceIdMeta,
        serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serviceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    }
    if (data.containsKey('headers_json')) {
      context.handle(
        _headersJsonMeta,
        headersJson.isAcceptableOrUnknown(
          data['headers_json']!,
          _headersJsonMeta,
        ),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('match_type')) {
      context.handle(
        _matchTypeMeta,
        matchType.isAcceptableOrUnknown(data['match_type']!, _matchTypeMeta),
      );
    }
    if (data.containsKey('match_value')) {
      context.handle(
        _matchValueMeta,
        matchValue.isAcceptableOrUnknown(data['match_value']!, _matchValueMeta),
      );
    }
    if (data.containsKey('status_range_from')) {
      context.handle(
        _statusRangeFromMeta,
        statusRangeFrom.isAcceptableOrUnknown(
          data['status_range_from']!,
          _statusRangeFromMeta,
        ),
      );
    }
    if (data.containsKey('status_range_to')) {
      context.handle(
        _statusRangeToMeta,
        statusRangeTo.isAcceptableOrUnknown(
          data['status_range_to']!,
          _statusRangeToMeta,
        ),
      );
    }
    if (data.containsKey('timeout_ms')) {
      context.handle(
        _timeoutMsMeta,
        timeoutMs.isAcceptableOrUnknown(data['timeout_ms']!, _timeoutMsMeta),
      );
    }
    if (data.containsKey('check_interval_seconds')) {
      context.handle(
        _checkIntervalSecondsMeta,
        checkIntervalSeconds.isAcceptableOrUnknown(
          data['check_interval_seconds']!,
          _checkIntervalSecondsMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Environment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Environment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}service_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      headersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}headers_json'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      matchType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}match_type'],
      )!,
      matchValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}match_value'],
      )!,
      statusRangeFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status_range_from'],
      )!,
      statusRangeTo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status_range_to'],
      )!,
      timeoutMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timeout_ms'],
      )!,
      checkIntervalSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}check_interval_seconds'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EnvironmentsTable createAlias(String alias) {
    return $EnvironmentsTable(attachedDatabase, alias);
  }
}

class Environment extends DataClass implements Insertable<Environment> {
  final int id;
  final int serviceId;
  final String name;
  final String url;
  final String role;
  final String method;
  final String headersJson;
  final String body;
  final String matchType;
  final String matchValue;
  final int statusRangeFrom;
  final int statusRangeTo;
  final int timeoutMs;
  final int checkIntervalSeconds;
  final bool isActive;
  final DateTime createdAt;
  const Environment({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.url,
    required this.role,
    required this.method,
    required this.headersJson,
    required this.body,
    required this.matchType,
    required this.matchValue,
    required this.statusRangeFrom,
    required this.statusRangeTo,
    required this.timeoutMs,
    required this.checkIntervalSeconds,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['service_id'] = Variable<int>(serviceId);
    map['name'] = Variable<String>(name);
    map['url'] = Variable<String>(url);
    map['role'] = Variable<String>(role);
    map['method'] = Variable<String>(method);
    map['headers_json'] = Variable<String>(headersJson);
    map['body'] = Variable<String>(body);
    map['match_type'] = Variable<String>(matchType);
    map['match_value'] = Variable<String>(matchValue);
    map['status_range_from'] = Variable<int>(statusRangeFrom);
    map['status_range_to'] = Variable<int>(statusRangeTo);
    map['timeout_ms'] = Variable<int>(timeoutMs);
    map['check_interval_seconds'] = Variable<int>(checkIntervalSeconds);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EnvironmentsCompanion toCompanion(bool nullToAbsent) {
    return EnvironmentsCompanion(
      id: Value(id),
      serviceId: Value(serviceId),
      name: Value(name),
      url: Value(url),
      role: Value(role),
      method: Value(method),
      headersJson: Value(headersJson),
      body: Value(body),
      matchType: Value(matchType),
      matchValue: Value(matchValue),
      statusRangeFrom: Value(statusRangeFrom),
      statusRangeTo: Value(statusRangeTo),
      timeoutMs: Value(timeoutMs),
      checkIntervalSeconds: Value(checkIntervalSeconds),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Environment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Environment(
      id: serializer.fromJson<int>(json['id']),
      serviceId: serializer.fromJson<int>(json['serviceId']),
      name: serializer.fromJson<String>(json['name']),
      url: serializer.fromJson<String>(json['url']),
      role: serializer.fromJson<String>(json['role']),
      method: serializer.fromJson<String>(json['method']),
      headersJson: serializer.fromJson<String>(json['headersJson']),
      body: serializer.fromJson<String>(json['body']),
      matchType: serializer.fromJson<String>(json['matchType']),
      matchValue: serializer.fromJson<String>(json['matchValue']),
      statusRangeFrom: serializer.fromJson<int>(json['statusRangeFrom']),
      statusRangeTo: serializer.fromJson<int>(json['statusRangeTo']),
      timeoutMs: serializer.fromJson<int>(json['timeoutMs']),
      checkIntervalSeconds: serializer.fromJson<int>(
        json['checkIntervalSeconds'],
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serviceId': serializer.toJson<int>(serviceId),
      'name': serializer.toJson<String>(name),
      'url': serializer.toJson<String>(url),
      'role': serializer.toJson<String>(role),
      'method': serializer.toJson<String>(method),
      'headersJson': serializer.toJson<String>(headersJson),
      'body': serializer.toJson<String>(body),
      'matchType': serializer.toJson<String>(matchType),
      'matchValue': serializer.toJson<String>(matchValue),
      'statusRangeFrom': serializer.toJson<int>(statusRangeFrom),
      'statusRangeTo': serializer.toJson<int>(statusRangeTo),
      'timeoutMs': serializer.toJson<int>(timeoutMs),
      'checkIntervalSeconds': serializer.toJson<int>(checkIntervalSeconds),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Environment copyWith({
    int? id,
    int? serviceId,
    String? name,
    String? url,
    String? role,
    String? method,
    String? headersJson,
    String? body,
    String? matchType,
    String? matchValue,
    int? statusRangeFrom,
    int? statusRangeTo,
    int? timeoutMs,
    int? checkIntervalSeconds,
    bool? isActive,
    DateTime? createdAt,
  }) => Environment(
    id: id ?? this.id,
    serviceId: serviceId ?? this.serviceId,
    name: name ?? this.name,
    url: url ?? this.url,
    role: role ?? this.role,
    method: method ?? this.method,
    headersJson: headersJson ?? this.headersJson,
    body: body ?? this.body,
    matchType: matchType ?? this.matchType,
    matchValue: matchValue ?? this.matchValue,
    statusRangeFrom: statusRangeFrom ?? this.statusRangeFrom,
    statusRangeTo: statusRangeTo ?? this.statusRangeTo,
    timeoutMs: timeoutMs ?? this.timeoutMs,
    checkIntervalSeconds: checkIntervalSeconds ?? this.checkIntervalSeconds,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  Environment copyWithCompanion(EnvironmentsCompanion data) {
    return Environment(
      id: data.id.present ? data.id.value : this.id,
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      name: data.name.present ? data.name.value : this.name,
      url: data.url.present ? data.url.value : this.url,
      role: data.role.present ? data.role.value : this.role,
      method: data.method.present ? data.method.value : this.method,
      headersJson: data.headersJson.present
          ? data.headersJson.value
          : this.headersJson,
      body: data.body.present ? data.body.value : this.body,
      matchType: data.matchType.present ? data.matchType.value : this.matchType,
      matchValue: data.matchValue.present
          ? data.matchValue.value
          : this.matchValue,
      statusRangeFrom: data.statusRangeFrom.present
          ? data.statusRangeFrom.value
          : this.statusRangeFrom,
      statusRangeTo: data.statusRangeTo.present
          ? data.statusRangeTo.value
          : this.statusRangeTo,
      timeoutMs: data.timeoutMs.present ? data.timeoutMs.value : this.timeoutMs,
      checkIntervalSeconds: data.checkIntervalSeconds.present
          ? data.checkIntervalSeconds.value
          : this.checkIntervalSeconds,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Environment(')
          ..write('id: $id, ')
          ..write('serviceId: $serviceId, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('role: $role, ')
          ..write('method: $method, ')
          ..write('headersJson: $headersJson, ')
          ..write('body: $body, ')
          ..write('matchType: $matchType, ')
          ..write('matchValue: $matchValue, ')
          ..write('statusRangeFrom: $statusRangeFrom, ')
          ..write('statusRangeTo: $statusRangeTo, ')
          ..write('timeoutMs: $timeoutMs, ')
          ..write('checkIntervalSeconds: $checkIntervalSeconds, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serviceId,
    name,
    url,
    role,
    method,
    headersJson,
    body,
    matchType,
    matchValue,
    statusRangeFrom,
    statusRangeTo,
    timeoutMs,
    checkIntervalSeconds,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Environment &&
          other.id == this.id &&
          other.serviceId == this.serviceId &&
          other.name == this.name &&
          other.url == this.url &&
          other.role == this.role &&
          other.method == this.method &&
          other.headersJson == this.headersJson &&
          other.body == this.body &&
          other.matchType == this.matchType &&
          other.matchValue == this.matchValue &&
          other.statusRangeFrom == this.statusRangeFrom &&
          other.statusRangeTo == this.statusRangeTo &&
          other.timeoutMs == this.timeoutMs &&
          other.checkIntervalSeconds == this.checkIntervalSeconds &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class EnvironmentsCompanion extends UpdateCompanion<Environment> {
  final Value<int> id;
  final Value<int> serviceId;
  final Value<String> name;
  final Value<String> url;
  final Value<String> role;
  final Value<String> method;
  final Value<String> headersJson;
  final Value<String> body;
  final Value<String> matchType;
  final Value<String> matchValue;
  final Value<int> statusRangeFrom;
  final Value<int> statusRangeTo;
  final Value<int> timeoutMs;
  final Value<int> checkIntervalSeconds;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const EnvironmentsCompanion({
    this.id = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.name = const Value.absent(),
    this.url = const Value.absent(),
    this.role = const Value.absent(),
    this.method = const Value.absent(),
    this.headersJson = const Value.absent(),
    this.body = const Value.absent(),
    this.matchType = const Value.absent(),
    this.matchValue = const Value.absent(),
    this.statusRangeFrom = const Value.absent(),
    this.statusRangeTo = const Value.absent(),
    this.timeoutMs = const Value.absent(),
    this.checkIntervalSeconds = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EnvironmentsCompanion.insert({
    this.id = const Value.absent(),
    required int serviceId,
    required String name,
    required String url,
    this.role = const Value.absent(),
    this.method = const Value.absent(),
    this.headersJson = const Value.absent(),
    this.body = const Value.absent(),
    this.matchType = const Value.absent(),
    this.matchValue = const Value.absent(),
    this.statusRangeFrom = const Value.absent(),
    this.statusRangeTo = const Value.absent(),
    this.timeoutMs = const Value.absent(),
    this.checkIntervalSeconds = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : serviceId = Value(serviceId),
       name = Value(name),
       url = Value(url);
  static Insertable<Environment> custom({
    Expression<int>? id,
    Expression<int>? serviceId,
    Expression<String>? name,
    Expression<String>? url,
    Expression<String>? role,
    Expression<String>? method,
    Expression<String>? headersJson,
    Expression<String>? body,
    Expression<String>? matchType,
    Expression<String>? matchValue,
    Expression<int>? statusRangeFrom,
    Expression<int>? statusRangeTo,
    Expression<int>? timeoutMs,
    Expression<int>? checkIntervalSeconds,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serviceId != null) 'service_id': serviceId,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (role != null) 'role': role,
      if (method != null) 'method': method,
      if (headersJson != null) 'headers_json': headersJson,
      if (body != null) 'body': body,
      if (matchType != null) 'match_type': matchType,
      if (matchValue != null) 'match_value': matchValue,
      if (statusRangeFrom != null) 'status_range_from': statusRangeFrom,
      if (statusRangeTo != null) 'status_range_to': statusRangeTo,
      if (timeoutMs != null) 'timeout_ms': timeoutMs,
      if (checkIntervalSeconds != null)
        'check_interval_seconds': checkIntervalSeconds,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EnvironmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? serviceId,
    Value<String>? name,
    Value<String>? url,
    Value<String>? role,
    Value<String>? method,
    Value<String>? headersJson,
    Value<String>? body,
    Value<String>? matchType,
    Value<String>? matchValue,
    Value<int>? statusRangeFrom,
    Value<int>? statusRangeTo,
    Value<int>? timeoutMs,
    Value<int>? checkIntervalSeconds,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return EnvironmentsCompanion(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      name: name ?? this.name,
      url: url ?? this.url,
      role: role ?? this.role,
      method: method ?? this.method,
      headersJson: headersJson ?? this.headersJson,
      body: body ?? this.body,
      matchType: matchType ?? this.matchType,
      matchValue: matchValue ?? this.matchValue,
      statusRangeFrom: statusRangeFrom ?? this.statusRangeFrom,
      statusRangeTo: statusRangeTo ?? this.statusRangeTo,
      timeoutMs: timeoutMs ?? this.timeoutMs,
      checkIntervalSeconds: checkIntervalSeconds ?? this.checkIntervalSeconds,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serviceId.present) {
      map['service_id'] = Variable<int>(serviceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (headersJson.present) {
      map['headers_json'] = Variable<String>(headersJson.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (matchType.present) {
      map['match_type'] = Variable<String>(matchType.value);
    }
    if (matchValue.present) {
      map['match_value'] = Variable<String>(matchValue.value);
    }
    if (statusRangeFrom.present) {
      map['status_range_from'] = Variable<int>(statusRangeFrom.value);
    }
    if (statusRangeTo.present) {
      map['status_range_to'] = Variable<int>(statusRangeTo.value);
    }
    if (timeoutMs.present) {
      map['timeout_ms'] = Variable<int>(timeoutMs.value);
    }
    if (checkIntervalSeconds.present) {
      map['check_interval_seconds'] = Variable<int>(checkIntervalSeconds.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnvironmentsCompanion(')
          ..write('id: $id, ')
          ..write('serviceId: $serviceId, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('role: $role, ')
          ..write('method: $method, ')
          ..write('headersJson: $headersJson, ')
          ..write('body: $body, ')
          ..write('matchType: $matchType, ')
          ..write('matchValue: $matchValue, ')
          ..write('statusRangeFrom: $statusRangeFrom, ')
          ..write('statusRangeTo: $statusRangeTo, ')
          ..write('timeoutMs: $timeoutMs, ')
          ..write('checkIntervalSeconds: $checkIntervalSeconds, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 32,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String name;
  const Tag({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(id: Value(id), name: Value(name));
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Tag copyWith({int? id, String? name}) =>
      Tag(id: id ?? this.id, name: name ?? this.name);
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag && other.id == this.id && other.name == this.name);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  TagsCompanion.insert({this.id = const Value.absent(), required String name})
    : name = Value(name);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  TagsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return TagsCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $EnvironmentTagsTable extends EnvironmentTags
    with TableInfo<$EnvironmentTagsTable, EnvironmentTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnvironmentTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _environmentIdMeta = const VerificationMeta(
    'environmentId',
  );
  @override
  late final GeneratedColumn<int> environmentId = GeneratedColumn<int>(
    'environment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES environments (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [environmentId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'environment_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<EnvironmentTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('environment_id')) {
      context.handle(
        _environmentIdMeta,
        environmentId.isAcceptableOrUnknown(
          data['environment_id']!,
          _environmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_environmentIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {environmentId, tagId};
  @override
  EnvironmentTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnvironmentTag(
      environmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}environment_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $EnvironmentTagsTable createAlias(String alias) {
    return $EnvironmentTagsTable(attachedDatabase, alias);
  }
}

class EnvironmentTag extends DataClass implements Insertable<EnvironmentTag> {
  final int environmentId;
  final int tagId;
  const EnvironmentTag({required this.environmentId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['environment_id'] = Variable<int>(environmentId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  EnvironmentTagsCompanion toCompanion(bool nullToAbsent) {
    return EnvironmentTagsCompanion(
      environmentId: Value(environmentId),
      tagId: Value(tagId),
    );
  }

  factory EnvironmentTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnvironmentTag(
      environmentId: serializer.fromJson<int>(json['environmentId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'environmentId': serializer.toJson<int>(environmentId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  EnvironmentTag copyWith({int? environmentId, int? tagId}) => EnvironmentTag(
    environmentId: environmentId ?? this.environmentId,
    tagId: tagId ?? this.tagId,
  );
  EnvironmentTag copyWithCompanion(EnvironmentTagsCompanion data) {
    return EnvironmentTag(
      environmentId: data.environmentId.present
          ? data.environmentId.value
          : this.environmentId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnvironmentTag(')
          ..write('environmentId: $environmentId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(environmentId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnvironmentTag &&
          other.environmentId == this.environmentId &&
          other.tagId == this.tagId);
}

class EnvironmentTagsCompanion extends UpdateCompanion<EnvironmentTag> {
  final Value<int> environmentId;
  final Value<int> tagId;
  final Value<int> rowid;
  const EnvironmentTagsCompanion({
    this.environmentId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EnvironmentTagsCompanion.insert({
    required int environmentId,
    required int tagId,
    this.rowid = const Value.absent(),
  }) : environmentId = Value(environmentId),
       tagId = Value(tagId);
  static Insertable<EnvironmentTag> custom({
    Expression<int>? environmentId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (environmentId != null) 'environment_id': environmentId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EnvironmentTagsCompanion copyWith({
    Value<int>? environmentId,
    Value<int>? tagId,
    Value<int>? rowid,
  }) {
    return EnvironmentTagsCompanion(
      environmentId: environmentId ?? this.environmentId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (environmentId.present) {
      map['environment_id'] = Variable<int>(environmentId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnvironmentTagsCompanion(')
          ..write('environmentId: $environmentId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CheckResultsTable extends CheckResults
    with TableInfo<$CheckResultsTable, CheckResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _environmentIdMeta = const VerificationMeta(
    'environmentId',
  );
  @override
  late final GeneratedColumn<int> environmentId = GeneratedColumn<int>(
    'environment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES environments (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _checkedAtMeta = const VerificationMeta(
    'checkedAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkedAt = GeneratedColumn<DateTime>(
    'checked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _statusCodeMeta = const VerificationMeta(
    'statusCode',
  );
  @override
  late final GeneratedColumn<int> statusCode = GeneratedColumn<int>(
    'status_code',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _responseTimeMsMeta = const VerificationMeta(
    'responseTimeMs',
  );
  @override
  late final GeneratedColumn<int> responseTimeMs = GeneratedColumn<int>(
    'response_time_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isUpMeta = const VerificationMeta('isUp');
  @override
  late final GeneratedColumn<bool> isUp = GeneratedColumn<bool>(
    'is_up',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_up" IN (0, 1))',
    ),
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    environmentId,
    checkedAt,
    statusCode,
    responseTimeMs,
    isUp,
    errorMessage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'check_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<CheckResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('environment_id')) {
      context.handle(
        _environmentIdMeta,
        environmentId.isAcceptableOrUnknown(
          data['environment_id']!,
          _environmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_environmentIdMeta);
    }
    if (data.containsKey('checked_at')) {
      context.handle(
        _checkedAtMeta,
        checkedAt.isAcceptableOrUnknown(data['checked_at']!, _checkedAtMeta),
      );
    }
    if (data.containsKey('status_code')) {
      context.handle(
        _statusCodeMeta,
        statusCode.isAcceptableOrUnknown(data['status_code']!, _statusCodeMeta),
      );
    }
    if (data.containsKey('response_time_ms')) {
      context.handle(
        _responseTimeMsMeta,
        responseTimeMs.isAcceptableOrUnknown(
          data['response_time_ms']!,
          _responseTimeMsMeta,
        ),
      );
    }
    if (data.containsKey('is_up')) {
      context.handle(
        _isUpMeta,
        isUp.isAcceptableOrUnknown(data['is_up']!, _isUpMeta),
      );
    } else if (isInserting) {
      context.missing(_isUpMeta);
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CheckResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CheckResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      environmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}environment_id'],
      )!,
      checkedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_at'],
      )!,
      statusCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status_code'],
      ),
      responseTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}response_time_ms'],
      ),
      isUp: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_up'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
    );
  }

  @override
  $CheckResultsTable createAlias(String alias) {
    return $CheckResultsTable(attachedDatabase, alias);
  }
}

class CheckResult extends DataClass implements Insertable<CheckResult> {
  final int id;
  final int environmentId;
  final DateTime checkedAt;
  final int? statusCode;
  final int? responseTimeMs;
  final bool isUp;
  final String? errorMessage;
  const CheckResult({
    required this.id,
    required this.environmentId,
    required this.checkedAt,
    this.statusCode,
    this.responseTimeMs,
    required this.isUp,
    this.errorMessage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['environment_id'] = Variable<int>(environmentId);
    map['checked_at'] = Variable<DateTime>(checkedAt);
    if (!nullToAbsent || statusCode != null) {
      map['status_code'] = Variable<int>(statusCode);
    }
    if (!nullToAbsent || responseTimeMs != null) {
      map['response_time_ms'] = Variable<int>(responseTimeMs);
    }
    map['is_up'] = Variable<bool>(isUp);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    return map;
  }

  CheckResultsCompanion toCompanion(bool nullToAbsent) {
    return CheckResultsCompanion(
      id: Value(id),
      environmentId: Value(environmentId),
      checkedAt: Value(checkedAt),
      statusCode: statusCode == null && nullToAbsent
          ? const Value.absent()
          : Value(statusCode),
      responseTimeMs: responseTimeMs == null && nullToAbsent
          ? const Value.absent()
          : Value(responseTimeMs),
      isUp: Value(isUp),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
    );
  }

  factory CheckResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CheckResult(
      id: serializer.fromJson<int>(json['id']),
      environmentId: serializer.fromJson<int>(json['environmentId']),
      checkedAt: serializer.fromJson<DateTime>(json['checkedAt']),
      statusCode: serializer.fromJson<int?>(json['statusCode']),
      responseTimeMs: serializer.fromJson<int?>(json['responseTimeMs']),
      isUp: serializer.fromJson<bool>(json['isUp']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'environmentId': serializer.toJson<int>(environmentId),
      'checkedAt': serializer.toJson<DateTime>(checkedAt),
      'statusCode': serializer.toJson<int?>(statusCode),
      'responseTimeMs': serializer.toJson<int?>(responseTimeMs),
      'isUp': serializer.toJson<bool>(isUp),
      'errorMessage': serializer.toJson<String?>(errorMessage),
    };
  }

  CheckResult copyWith({
    int? id,
    int? environmentId,
    DateTime? checkedAt,
    Value<int?> statusCode = const Value.absent(),
    Value<int?> responseTimeMs = const Value.absent(),
    bool? isUp,
    Value<String?> errorMessage = const Value.absent(),
  }) => CheckResult(
    id: id ?? this.id,
    environmentId: environmentId ?? this.environmentId,
    checkedAt: checkedAt ?? this.checkedAt,
    statusCode: statusCode.present ? statusCode.value : this.statusCode,
    responseTimeMs: responseTimeMs.present
        ? responseTimeMs.value
        : this.responseTimeMs,
    isUp: isUp ?? this.isUp,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
  );
  CheckResult copyWithCompanion(CheckResultsCompanion data) {
    return CheckResult(
      id: data.id.present ? data.id.value : this.id,
      environmentId: data.environmentId.present
          ? data.environmentId.value
          : this.environmentId,
      checkedAt: data.checkedAt.present ? data.checkedAt.value : this.checkedAt,
      statusCode: data.statusCode.present
          ? data.statusCode.value
          : this.statusCode,
      responseTimeMs: data.responseTimeMs.present
          ? data.responseTimeMs.value
          : this.responseTimeMs,
      isUp: data.isUp.present ? data.isUp.value : this.isUp,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CheckResult(')
          ..write('id: $id, ')
          ..write('environmentId: $environmentId, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('statusCode: $statusCode, ')
          ..write('responseTimeMs: $responseTimeMs, ')
          ..write('isUp: $isUp, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    environmentId,
    checkedAt,
    statusCode,
    responseTimeMs,
    isUp,
    errorMessage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckResult &&
          other.id == this.id &&
          other.environmentId == this.environmentId &&
          other.checkedAt == this.checkedAt &&
          other.statusCode == this.statusCode &&
          other.responseTimeMs == this.responseTimeMs &&
          other.isUp == this.isUp &&
          other.errorMessage == this.errorMessage);
}

class CheckResultsCompanion extends UpdateCompanion<CheckResult> {
  final Value<int> id;
  final Value<int> environmentId;
  final Value<DateTime> checkedAt;
  final Value<int?> statusCode;
  final Value<int?> responseTimeMs;
  final Value<bool> isUp;
  final Value<String?> errorMessage;
  const CheckResultsCompanion({
    this.id = const Value.absent(),
    this.environmentId = const Value.absent(),
    this.checkedAt = const Value.absent(),
    this.statusCode = const Value.absent(),
    this.responseTimeMs = const Value.absent(),
    this.isUp = const Value.absent(),
    this.errorMessage = const Value.absent(),
  });
  CheckResultsCompanion.insert({
    this.id = const Value.absent(),
    required int environmentId,
    this.checkedAt = const Value.absent(),
    this.statusCode = const Value.absent(),
    this.responseTimeMs = const Value.absent(),
    required bool isUp,
    this.errorMessage = const Value.absent(),
  }) : environmentId = Value(environmentId),
       isUp = Value(isUp);
  static Insertable<CheckResult> custom({
    Expression<int>? id,
    Expression<int>? environmentId,
    Expression<DateTime>? checkedAt,
    Expression<int>? statusCode,
    Expression<int>? responseTimeMs,
    Expression<bool>? isUp,
    Expression<String>? errorMessage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (environmentId != null) 'environment_id': environmentId,
      if (checkedAt != null) 'checked_at': checkedAt,
      if (statusCode != null) 'status_code': statusCode,
      if (responseTimeMs != null) 'response_time_ms': responseTimeMs,
      if (isUp != null) 'is_up': isUp,
      if (errorMessage != null) 'error_message': errorMessage,
    });
  }

  CheckResultsCompanion copyWith({
    Value<int>? id,
    Value<int>? environmentId,
    Value<DateTime>? checkedAt,
    Value<int?>? statusCode,
    Value<int?>? responseTimeMs,
    Value<bool>? isUp,
    Value<String?>? errorMessage,
  }) {
    return CheckResultsCompanion(
      id: id ?? this.id,
      environmentId: environmentId ?? this.environmentId,
      checkedAt: checkedAt ?? this.checkedAt,
      statusCode: statusCode ?? this.statusCode,
      responseTimeMs: responseTimeMs ?? this.responseTimeMs,
      isUp: isUp ?? this.isUp,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (environmentId.present) {
      map['environment_id'] = Variable<int>(environmentId.value);
    }
    if (checkedAt.present) {
      map['checked_at'] = Variable<DateTime>(checkedAt.value);
    }
    if (statusCode.present) {
      map['status_code'] = Variable<int>(statusCode.value);
    }
    if (responseTimeMs.present) {
      map['response_time_ms'] = Variable<int>(responseTimeMs.value);
    }
    if (isUp.present) {
      map['is_up'] = Variable<bool>(isUp.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckResultsCompanion(')
          ..write('id: $id, ')
          ..write('environmentId: $environmentId, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('statusCode: $statusCode, ')
          ..write('responseTimeMs: $responseTimeMs, ')
          ..write('isUp: $isUp, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }
}

class $IncidentsTable extends Incidents
    with TableInfo<$IncidentsTable, Incident> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncidentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _environmentIdMeta = const VerificationMeta(
    'environmentId',
  );
  @override
  late final GeneratedColumn<int> environmentId = GeneratedColumn<int>(
    'environment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES environments (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _causeMeta = const VerificationMeta('cause');
  @override
  late final GeneratedColumn<String> cause = GeneratedColumn<String>(
    'cause',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _acknowledgedMeta = const VerificationMeta(
    'acknowledged',
  );
  @override
  late final GeneratedColumn<bool> acknowledged = GeneratedColumn<bool>(
    'acknowledged',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("acknowledged" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    environmentId,
    startedAt,
    endedAt,
    cause,
    note,
    acknowledged,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'incidents';
  @override
  VerificationContext validateIntegrity(
    Insertable<Incident> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('environment_id')) {
      context.handle(
        _environmentIdMeta,
        environmentId.isAcceptableOrUnknown(
          data['environment_id']!,
          _environmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_environmentIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('cause')) {
      context.handle(
        _causeMeta,
        cause.isAcceptableOrUnknown(data['cause']!, _causeMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('acknowledged')) {
      context.handle(
        _acknowledgedMeta,
        acknowledged.isAcceptableOrUnknown(
          data['acknowledged']!,
          _acknowledgedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Incident map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Incident(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      environmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}environment_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      cause: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cause'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      acknowledged: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}acknowledged'],
      )!,
    );
  }

  @override
  $IncidentsTable createAlias(String alias) {
    return $IncidentsTable(attachedDatabase, alias);
  }
}

class Incident extends DataClass implements Insertable<Incident> {
  final int id;
  final int environmentId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String cause;
  final String note;
  final bool acknowledged;
  const Incident({
    required this.id,
    required this.environmentId,
    required this.startedAt,
    this.endedAt,
    required this.cause,
    required this.note,
    required this.acknowledged,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['environment_id'] = Variable<int>(environmentId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['cause'] = Variable<String>(cause);
    map['note'] = Variable<String>(note);
    map['acknowledged'] = Variable<bool>(acknowledged);
    return map;
  }

  IncidentsCompanion toCompanion(bool nullToAbsent) {
    return IncidentsCompanion(
      id: Value(id),
      environmentId: Value(environmentId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      cause: Value(cause),
      note: Value(note),
      acknowledged: Value(acknowledged),
    );
  }

  factory Incident.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Incident(
      id: serializer.fromJson<int>(json['id']),
      environmentId: serializer.fromJson<int>(json['environmentId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      cause: serializer.fromJson<String>(json['cause']),
      note: serializer.fromJson<String>(json['note']),
      acknowledged: serializer.fromJson<bool>(json['acknowledged']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'environmentId': serializer.toJson<int>(environmentId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'cause': serializer.toJson<String>(cause),
      'note': serializer.toJson<String>(note),
      'acknowledged': serializer.toJson<bool>(acknowledged),
    };
  }

  Incident copyWith({
    int? id,
    int? environmentId,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    String? cause,
    String? note,
    bool? acknowledged,
  }) => Incident(
    id: id ?? this.id,
    environmentId: environmentId ?? this.environmentId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    cause: cause ?? this.cause,
    note: note ?? this.note,
    acknowledged: acknowledged ?? this.acknowledged,
  );
  Incident copyWithCompanion(IncidentsCompanion data) {
    return Incident(
      id: data.id.present ? data.id.value : this.id,
      environmentId: data.environmentId.present
          ? data.environmentId.value
          : this.environmentId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      cause: data.cause.present ? data.cause.value : this.cause,
      note: data.note.present ? data.note.value : this.note,
      acknowledged: data.acknowledged.present
          ? data.acknowledged.value
          : this.acknowledged,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Incident(')
          ..write('id: $id, ')
          ..write('environmentId: $environmentId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('cause: $cause, ')
          ..write('note: $note, ')
          ..write('acknowledged: $acknowledged')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    environmentId,
    startedAt,
    endedAt,
    cause,
    note,
    acknowledged,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Incident &&
          other.id == this.id &&
          other.environmentId == this.environmentId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.cause == this.cause &&
          other.note == this.note &&
          other.acknowledged == this.acknowledged);
}

class IncidentsCompanion extends UpdateCompanion<Incident> {
  final Value<int> id;
  final Value<int> environmentId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<String> cause;
  final Value<String> note;
  final Value<bool> acknowledged;
  const IncidentsCompanion({
    this.id = const Value.absent(),
    this.environmentId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.cause = const Value.absent(),
    this.note = const Value.absent(),
    this.acknowledged = const Value.absent(),
  });
  IncidentsCompanion.insert({
    this.id = const Value.absent(),
    required int environmentId,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.cause = const Value.absent(),
    this.note = const Value.absent(),
    this.acknowledged = const Value.absent(),
  }) : environmentId = Value(environmentId),
       startedAt = Value(startedAt);
  static Insertable<Incident> custom({
    Expression<int>? id,
    Expression<int>? environmentId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? cause,
    Expression<String>? note,
    Expression<bool>? acknowledged,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (environmentId != null) 'environment_id': environmentId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (cause != null) 'cause': cause,
      if (note != null) 'note': note,
      if (acknowledged != null) 'acknowledged': acknowledged,
    });
  }

  IncidentsCompanion copyWith({
    Value<int>? id,
    Value<int>? environmentId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<String>? cause,
    Value<String>? note,
    Value<bool>? acknowledged,
  }) {
    return IncidentsCompanion(
      id: id ?? this.id,
      environmentId: environmentId ?? this.environmentId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      cause: cause ?? this.cause,
      note: note ?? this.note,
      acknowledged: acknowledged ?? this.acknowledged,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (environmentId.present) {
      map['environment_id'] = Variable<int>(environmentId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (cause.present) {
      map['cause'] = Variable<String>(cause.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (acknowledged.present) {
      map['acknowledged'] = Variable<bool>(acknowledged.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncidentsCompanion(')
          ..write('id: $id, ')
          ..write('environmentId: $environmentId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('cause: $cause, ')
          ..write('note: $note, ')
          ..write('acknowledged: $acknowledged')
          ..write(')'))
        .toString();
  }
}

class $WebhooksTable extends Webhooks with TableInfo<$WebhooksTable, Webhook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WebhooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('generic'),
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _triggerOnMeta = const VerificationMeta(
    'triggerOn',
  );
  @override
  late final GeneratedColumn<String> triggerOn = GeneratedColumn<String>(
    'trigger_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('any'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    url,
    triggerOn,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'webhooks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Webhook> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('trigger_on')) {
      context.handle(
        _triggerOnMeta,
        triggerOn.isAcceptableOrUnknown(data['trigger_on']!, _triggerOnMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Webhook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Webhook(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      triggerOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger_on'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $WebhooksTable createAlias(String alias) {
    return $WebhooksTable(attachedDatabase, alias);
  }
}

class Webhook extends DataClass implements Insertable<Webhook> {
  final int id;
  final String name;
  final String type;
  final String url;
  final String triggerOn;
  final bool isActive;
  const Webhook({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.triggerOn,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['url'] = Variable<String>(url);
    map['trigger_on'] = Variable<String>(triggerOn);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  WebhooksCompanion toCompanion(bool nullToAbsent) {
    return WebhooksCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      url: Value(url),
      triggerOn: Value(triggerOn),
      isActive: Value(isActive),
    );
  }

  factory Webhook.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Webhook(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      url: serializer.fromJson<String>(json['url']),
      triggerOn: serializer.fromJson<String>(json['triggerOn']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'url': serializer.toJson<String>(url),
      'triggerOn': serializer.toJson<String>(triggerOn),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Webhook copyWith({
    int? id,
    String? name,
    String? type,
    String? url,
    String? triggerOn,
    bool? isActive,
  }) => Webhook(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    url: url ?? this.url,
    triggerOn: triggerOn ?? this.triggerOn,
    isActive: isActive ?? this.isActive,
  );
  Webhook copyWithCompanion(WebhooksCompanion data) {
    return Webhook(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      url: data.url.present ? data.url.value : this.url,
      triggerOn: data.triggerOn.present ? data.triggerOn.value : this.triggerOn,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Webhook(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('url: $url, ')
          ..write('triggerOn: $triggerOn, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, url, triggerOn, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Webhook &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.url == this.url &&
          other.triggerOn == this.triggerOn &&
          other.isActive == this.isActive);
}

class WebhooksCompanion extends UpdateCompanion<Webhook> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> url;
  final Value<String> triggerOn;
  final Value<bool> isActive;
  const WebhooksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.url = const Value.absent(),
    this.triggerOn = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  WebhooksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.type = const Value.absent(),
    required String url,
    this.triggerOn = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name),
       url = Value(url);
  static Insertable<Webhook> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? url,
    Expression<String>? triggerOn,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (url != null) 'url': url,
      if (triggerOn != null) 'trigger_on': triggerOn,
      if (isActive != null) 'is_active': isActive,
    });
  }

  WebhooksCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String>? url,
    Value<String>? triggerOn,
    Value<bool>? isActive,
  }) {
    return WebhooksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      url: url ?? this.url,
      triggerOn: triggerOn ?? this.triggerOn,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (triggerOn.present) {
      map['trigger_on'] = Variable<String>(triggerOn.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WebhooksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('url: $url, ')
          ..write('triggerOn: $triggerOn, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ServicesTable services = $ServicesTable(this);
  late final $EnvironmentsTable environments = $EnvironmentsTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $EnvironmentTagsTable environmentTags = $EnvironmentTagsTable(
    this,
  );
  late final $CheckResultsTable checkResults = $CheckResultsTable(this);
  late final $IncidentsTable incidents = $IncidentsTable(this);
  late final $WebhooksTable webhooks = $WebhooksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    services,
    environments,
    tags,
    environmentTags,
    checkResults,
    incidents,
    webhooks,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'services',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('environments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'environments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('environment_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('environment_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'environments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('check_results', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'environments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('incidents', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ServicesTableCreateCompanionBuilder =
    ServicesCompanion Function({
      Value<int> id,
      required String name,
      Value<String> description,
      Value<DateTime> createdAt,
    });
typedef $$ServicesTableUpdateCompanionBuilder =
    ServicesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> description,
      Value<DateTime> createdAt,
    });

final class $$ServicesTableReferences
    extends BaseReferences<_$AppDatabase, $ServicesTable, Service> {
  $$ServicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EnvironmentsTable, List<Environment>>
  _environmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.environments,
    aliasName: $_aliasNameGenerator(db.services.id, db.environments.serviceId),
  );

  $$EnvironmentsTableProcessedTableManager get environmentsRefs {
    final manager = $$EnvironmentsTableTableManager(
      $_db,
      $_db.environments,
    ).filter((f) => f.serviceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_environmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServicesTableFilterComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> environmentsRefs(
    Expression<bool> Function($$EnvironmentsTableFilterComposer f) f,
  ) {
    final $$EnvironmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.environments,
      getReferencedColumn: (t) => t.serviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvironmentsTableFilterComposer(
            $db: $db,
            $table: $db.environments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServicesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> environmentsRefs<T extends Object>(
    Expression<T> Function($$EnvironmentsTableAnnotationComposer a) f,
  ) {
    final $$EnvironmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.environments,
      getReferencedColumn: (t) => t.serviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvironmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.environments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServicesTable,
          Service,
          $$ServicesTableFilterComposer,
          $$ServicesTableOrderingComposer,
          $$ServicesTableAnnotationComposer,
          $$ServicesTableCreateCompanionBuilder,
          $$ServicesTableUpdateCompanionBuilder,
          (Service, $$ServicesTableReferences),
          Service,
          PrefetchHooks Function({bool environmentsRefs})
        > {
  $$ServicesTableTableManager(_$AppDatabase db, $ServicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ServicesCompanion(
                id: id,
                name: name,
                description: description,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ServicesCompanion.insert(
                id: id,
                name: name,
                description: description,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({environmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (environmentsRefs) db.environments],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (environmentsRefs)
                    await $_getPrefetchedData<
                      Service,
                      $ServicesTable,
                      Environment
                    >(
                      currentTable: table,
                      referencedTable: $$ServicesTableReferences
                          ._environmentsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ServicesTableReferences(
                        db,
                        table,
                        p0,
                      ).environmentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.serviceId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ServicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServicesTable,
      Service,
      $$ServicesTableFilterComposer,
      $$ServicesTableOrderingComposer,
      $$ServicesTableAnnotationComposer,
      $$ServicesTableCreateCompanionBuilder,
      $$ServicesTableUpdateCompanionBuilder,
      (Service, $$ServicesTableReferences),
      Service,
      PrefetchHooks Function({bool environmentsRefs})
    >;
typedef $$EnvironmentsTableCreateCompanionBuilder =
    EnvironmentsCompanion Function({
      Value<int> id,
      required int serviceId,
      required String name,
      required String url,
      Value<String> role,
      Value<String> method,
      Value<String> headersJson,
      Value<String> body,
      Value<String> matchType,
      Value<String> matchValue,
      Value<int> statusRangeFrom,
      Value<int> statusRangeTo,
      Value<int> timeoutMs,
      Value<int> checkIntervalSeconds,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$EnvironmentsTableUpdateCompanionBuilder =
    EnvironmentsCompanion Function({
      Value<int> id,
      Value<int> serviceId,
      Value<String> name,
      Value<String> url,
      Value<String> role,
      Value<String> method,
      Value<String> headersJson,
      Value<String> body,
      Value<String> matchType,
      Value<String> matchValue,
      Value<int> statusRangeFrom,
      Value<int> statusRangeTo,
      Value<int> timeoutMs,
      Value<int> checkIntervalSeconds,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$EnvironmentsTableReferences
    extends BaseReferences<_$AppDatabase, $EnvironmentsTable, Environment> {
  $$EnvironmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ServicesTable _serviceIdTable(_$AppDatabase db) =>
      db.services.createAlias(
        $_aliasNameGenerator(db.environments.serviceId, db.services.id),
      );

  $$ServicesTableProcessedTableManager get serviceId {
    final $_column = $_itemColumn<int>('service_id')!;

    final manager = $$ServicesTableTableManager(
      $_db,
      $_db.services,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EnvironmentTagsTable, List<EnvironmentTag>>
  _environmentTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.environmentTags,
    aliasName: $_aliasNameGenerator(
      db.environments.id,
      db.environmentTags.environmentId,
    ),
  );

  $$EnvironmentTagsTableProcessedTableManager get environmentTagsRefs {
    final manager = $$EnvironmentTagsTableTableManager(
      $_db,
      $_db.environmentTags,
    ).filter((f) => f.environmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _environmentTagsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CheckResultsTable, List<CheckResult>>
  _checkResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.checkResults,
    aliasName: $_aliasNameGenerator(
      db.environments.id,
      db.checkResults.environmentId,
    ),
  );

  $$CheckResultsTableProcessedTableManager get checkResultsRefs {
    final manager = $$CheckResultsTableTableManager(
      $_db,
      $_db.checkResults,
    ).filter((f) => f.environmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_checkResultsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IncidentsTable, List<Incident>>
  _incidentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incidents,
    aliasName: $_aliasNameGenerator(
      db.environments.id,
      db.incidents.environmentId,
    ),
  );

  $$IncidentsTableProcessedTableManager get incidentsRefs {
    final manager = $$IncidentsTableTableManager(
      $_db,
      $_db.incidents,
    ).filter((f) => f.environmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_incidentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EnvironmentsTableFilterComposer
    extends Composer<_$AppDatabase, $EnvironmentsTable> {
  $$EnvironmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get headersJson => $composableBuilder(
    column: $table.headersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matchType => $composableBuilder(
    column: $table.matchType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matchValue => $composableBuilder(
    column: $table.matchValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get statusRangeFrom => $composableBuilder(
    column: $table.statusRangeFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get statusRangeTo => $composableBuilder(
    column: $table.statusRangeTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeoutMs => $composableBuilder(
    column: $table.timeoutMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get checkIntervalSeconds => $composableBuilder(
    column: $table.checkIntervalSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ServicesTableFilterComposer get serviceId {
    final $$ServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableFilterComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> environmentTagsRefs(
    Expression<bool> Function($$EnvironmentTagsTableFilterComposer f) f,
  ) {
    final $$EnvironmentTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.environmentTags,
      getReferencedColumn: (t) => t.environmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvironmentTagsTableFilterComposer(
            $db: $db,
            $table: $db.environmentTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> checkResultsRefs(
    Expression<bool> Function($$CheckResultsTableFilterComposer f) f,
  ) {
    final $$CheckResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checkResults,
      getReferencedColumn: (t) => t.environmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckResultsTableFilterComposer(
            $db: $db,
            $table: $db.checkResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incidentsRefs(
    Expression<bool> Function($$IncidentsTableFilterComposer f) f,
  ) {
    final $$IncidentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incidents,
      getReferencedColumn: (t) => t.environmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncidentsTableFilterComposer(
            $db: $db,
            $table: $db.incidents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EnvironmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $EnvironmentsTable> {
  $$EnvironmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get headersJson => $composableBuilder(
    column: $table.headersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matchType => $composableBuilder(
    column: $table.matchType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matchValue => $composableBuilder(
    column: $table.matchValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statusRangeFrom => $composableBuilder(
    column: $table.statusRangeFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statusRangeTo => $composableBuilder(
    column: $table.statusRangeTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeoutMs => $composableBuilder(
    column: $table.timeoutMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get checkIntervalSeconds => $composableBuilder(
    column: $table.checkIntervalSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServicesTableOrderingComposer get serviceId {
    final $$ServicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableOrderingComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EnvironmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnvironmentsTable> {
  $$EnvironmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get headersJson => $composableBuilder(
    column: $table.headersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get matchType =>
      $composableBuilder(column: $table.matchType, builder: (column) => column);

  GeneratedColumn<String> get matchValue => $composableBuilder(
    column: $table.matchValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get statusRangeFrom => $composableBuilder(
    column: $table.statusRangeFrom,
    builder: (column) => column,
  );

  GeneratedColumn<int> get statusRangeTo => $composableBuilder(
    column: $table.statusRangeTo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timeoutMs =>
      $composableBuilder(column: $table.timeoutMs, builder: (column) => column);

  GeneratedColumn<int> get checkIntervalSeconds => $composableBuilder(
    column: $table.checkIntervalSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ServicesTableAnnotationComposer get serviceId {
    final $$ServicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableAnnotationComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> environmentTagsRefs<T extends Object>(
    Expression<T> Function($$EnvironmentTagsTableAnnotationComposer a) f,
  ) {
    final $$EnvironmentTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.environmentTags,
      getReferencedColumn: (t) => t.environmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvironmentTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.environmentTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> checkResultsRefs<T extends Object>(
    Expression<T> Function($$CheckResultsTableAnnotationComposer a) f,
  ) {
    final $$CheckResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checkResults,
      getReferencedColumn: (t) => t.environmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CheckResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.checkResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> incidentsRefs<T extends Object>(
    Expression<T> Function($$IncidentsTableAnnotationComposer a) f,
  ) {
    final $$IncidentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incidents,
      getReferencedColumn: (t) => t.environmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncidentsTableAnnotationComposer(
            $db: $db,
            $table: $db.incidents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EnvironmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnvironmentsTable,
          Environment,
          $$EnvironmentsTableFilterComposer,
          $$EnvironmentsTableOrderingComposer,
          $$EnvironmentsTableAnnotationComposer,
          $$EnvironmentsTableCreateCompanionBuilder,
          $$EnvironmentsTableUpdateCompanionBuilder,
          (Environment, $$EnvironmentsTableReferences),
          Environment,
          PrefetchHooks Function({
            bool serviceId,
            bool environmentTagsRefs,
            bool checkResultsRefs,
            bool incidentsRefs,
          })
        > {
  $$EnvironmentsTableTableManager(_$AppDatabase db, $EnvironmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnvironmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnvironmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnvironmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> serviceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String> headersJson = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> matchType = const Value.absent(),
                Value<String> matchValue = const Value.absent(),
                Value<int> statusRangeFrom = const Value.absent(),
                Value<int> statusRangeTo = const Value.absent(),
                Value<int> timeoutMs = const Value.absent(),
                Value<int> checkIntervalSeconds = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EnvironmentsCompanion(
                id: id,
                serviceId: serviceId,
                name: name,
                url: url,
                role: role,
                method: method,
                headersJson: headersJson,
                body: body,
                matchType: matchType,
                matchValue: matchValue,
                statusRangeFrom: statusRangeFrom,
                statusRangeTo: statusRangeTo,
                timeoutMs: timeoutMs,
                checkIntervalSeconds: checkIntervalSeconds,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int serviceId,
                required String name,
                required String url,
                Value<String> role = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String> headersJson = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> matchType = const Value.absent(),
                Value<String> matchValue = const Value.absent(),
                Value<int> statusRangeFrom = const Value.absent(),
                Value<int> statusRangeTo = const Value.absent(),
                Value<int> timeoutMs = const Value.absent(),
                Value<int> checkIntervalSeconds = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EnvironmentsCompanion.insert(
                id: id,
                serviceId: serviceId,
                name: name,
                url: url,
                role: role,
                method: method,
                headersJson: headersJson,
                body: body,
                matchType: matchType,
                matchValue: matchValue,
                statusRangeFrom: statusRangeFrom,
                statusRangeTo: statusRangeTo,
                timeoutMs: timeoutMs,
                checkIntervalSeconds: checkIntervalSeconds,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EnvironmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                serviceId = false,
                environmentTagsRefs = false,
                checkResultsRefs = false,
                incidentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (environmentTagsRefs) db.environmentTags,
                    if (checkResultsRefs) db.checkResults,
                    if (incidentsRefs) db.incidents,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (serviceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.serviceId,
                                    referencedTable:
                                        $$EnvironmentsTableReferences
                                            ._serviceIdTable(db),
                                    referencedColumn:
                                        $$EnvironmentsTableReferences
                                            ._serviceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (environmentTagsRefs)
                        await $_getPrefetchedData<
                          Environment,
                          $EnvironmentsTable,
                          EnvironmentTag
                        >(
                          currentTable: table,
                          referencedTable: $$EnvironmentsTableReferences
                              ._environmentTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EnvironmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).environmentTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.environmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (checkResultsRefs)
                        await $_getPrefetchedData<
                          Environment,
                          $EnvironmentsTable,
                          CheckResult
                        >(
                          currentTable: table,
                          referencedTable: $$EnvironmentsTableReferences
                              ._checkResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EnvironmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).checkResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.environmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (incidentsRefs)
                        await $_getPrefetchedData<
                          Environment,
                          $EnvironmentsTable,
                          Incident
                        >(
                          currentTable: table,
                          referencedTable: $$EnvironmentsTableReferences
                              ._incidentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EnvironmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).incidentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.environmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EnvironmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnvironmentsTable,
      Environment,
      $$EnvironmentsTableFilterComposer,
      $$EnvironmentsTableOrderingComposer,
      $$EnvironmentsTableAnnotationComposer,
      $$EnvironmentsTableCreateCompanionBuilder,
      $$EnvironmentsTableUpdateCompanionBuilder,
      (Environment, $$EnvironmentsTableReferences),
      Environment,
      PrefetchHooks Function({
        bool serviceId,
        bool environmentTagsRefs,
        bool checkResultsRefs,
        bool incidentsRefs,
      })
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({Value<int> id, required String name});
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({Value<int> id, Value<String> name});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EnvironmentTagsTable, List<EnvironmentTag>>
  _environmentTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.environmentTags,
    aliasName: $_aliasNameGenerator(db.tags.id, db.environmentTags.tagId),
  );

  $$EnvironmentTagsTableProcessedTableManager get environmentTagsRefs {
    final manager = $$EnvironmentTagsTableTableManager(
      $_db,
      $_db.environmentTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _environmentTagsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> environmentTagsRefs(
    Expression<bool> Function($$EnvironmentTagsTableFilterComposer f) f,
  ) {
    final $$EnvironmentTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.environmentTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvironmentTagsTableFilterComposer(
            $db: $db,
            $table: $db.environmentTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> environmentTagsRefs<T extends Object>(
    Expression<T> Function($$EnvironmentTagsTableAnnotationComposer a) f,
  ) {
    final $$EnvironmentTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.environmentTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvironmentTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.environmentTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool environmentTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => TagsCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  TagsCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TagsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({environmentTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (environmentTagsRefs) db.environmentTags,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (environmentTagsRefs)
                    await $_getPrefetchedData<Tag, $TagsTable, EnvironmentTag>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences
                          ._environmentTagsRefsTable(db),
                      managerFromTypedResult: (p0) => $$TagsTableReferences(
                        db,
                        table,
                        p0,
                      ).environmentTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool environmentTagsRefs})
    >;
typedef $$EnvironmentTagsTableCreateCompanionBuilder =
    EnvironmentTagsCompanion Function({
      required int environmentId,
      required int tagId,
      Value<int> rowid,
    });
typedef $$EnvironmentTagsTableUpdateCompanionBuilder =
    EnvironmentTagsCompanion Function({
      Value<int> environmentId,
      Value<int> tagId,
      Value<int> rowid,
    });

final class $$EnvironmentTagsTableReferences
    extends
        BaseReferences<_$AppDatabase, $EnvironmentTagsTable, EnvironmentTag> {
  $$EnvironmentTagsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EnvironmentsTable _environmentIdTable(_$AppDatabase db) =>
      db.environments.createAlias(
        $_aliasNameGenerator(
          db.environmentTags.environmentId,
          db.environments.id,
        ),
      );

  $$EnvironmentsTableProcessedTableManager get environmentId {
    final $_column = $_itemColumn<int>('environment_id')!;

    final manager = $$EnvironmentsTableTableManager(
      $_db,
      $_db.environments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_environmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) => db.tags.createAlias(
    $_aliasNameGenerator(db.environmentTags.tagId, db.tags.id),
  );

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EnvironmentTagsTableFilterComposer
    extends Composer<_$AppDatabase, $EnvironmentTagsTable> {
  $$EnvironmentTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EnvironmentsTableFilterComposer get environmentId {
    final $$EnvironmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.environmentId,
      referencedTable: $db.environments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvironmentsTableFilterComposer(
            $db: $db,
            $table: $db.environments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EnvironmentTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $EnvironmentTagsTable> {
  $$EnvironmentTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EnvironmentsTableOrderingComposer get environmentId {
    final $$EnvironmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.environmentId,
      referencedTable: $db.environments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvironmentsTableOrderingComposer(
            $db: $db,
            $table: $db.environments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EnvironmentTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnvironmentTagsTable> {
  $$EnvironmentTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EnvironmentsTableAnnotationComposer get environmentId {
    final $$EnvironmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.environmentId,
      referencedTable: $db.environments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvironmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.environments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EnvironmentTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnvironmentTagsTable,
          EnvironmentTag,
          $$EnvironmentTagsTableFilterComposer,
          $$EnvironmentTagsTableOrderingComposer,
          $$EnvironmentTagsTableAnnotationComposer,
          $$EnvironmentTagsTableCreateCompanionBuilder,
          $$EnvironmentTagsTableUpdateCompanionBuilder,
          (EnvironmentTag, $$EnvironmentTagsTableReferences),
          EnvironmentTag,
          PrefetchHooks Function({bool environmentId, bool tagId})
        > {
  $$EnvironmentTagsTableTableManager(
    _$AppDatabase db,
    $EnvironmentTagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnvironmentTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnvironmentTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnvironmentTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> environmentId = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnvironmentTagsCompanion(
                environmentId: environmentId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int environmentId,
                required int tagId,
                Value<int> rowid = const Value.absent(),
              }) => EnvironmentTagsCompanion.insert(
                environmentId: environmentId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EnvironmentTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({environmentId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (environmentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.environmentId,
                                referencedTable:
                                    $$EnvironmentTagsTableReferences
                                        ._environmentIdTable(db),
                                referencedColumn:
                                    $$EnvironmentTagsTableReferences
                                        ._environmentIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable:
                                    $$EnvironmentTagsTableReferences
                                        ._tagIdTable(db),
                                referencedColumn:
                                    $$EnvironmentTagsTableReferences
                                        ._tagIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EnvironmentTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnvironmentTagsTable,
      EnvironmentTag,
      $$EnvironmentTagsTableFilterComposer,
      $$EnvironmentTagsTableOrderingComposer,
      $$EnvironmentTagsTableAnnotationComposer,
      $$EnvironmentTagsTableCreateCompanionBuilder,
      $$EnvironmentTagsTableUpdateCompanionBuilder,
      (EnvironmentTag, $$EnvironmentTagsTableReferences),
      EnvironmentTag,
      PrefetchHooks Function({bool environmentId, bool tagId})
    >;
typedef $$CheckResultsTableCreateCompanionBuilder =
    CheckResultsCompanion Function({
      Value<int> id,
      required int environmentId,
      Value<DateTime> checkedAt,
      Value<int?> statusCode,
      Value<int?> responseTimeMs,
      required bool isUp,
      Value<String?> errorMessage,
    });
typedef $$CheckResultsTableUpdateCompanionBuilder =
    CheckResultsCompanion Function({
      Value<int> id,
      Value<int> environmentId,
      Value<DateTime> checkedAt,
      Value<int?> statusCode,
      Value<int?> responseTimeMs,
      Value<bool> isUp,
      Value<String?> errorMessage,
    });

final class $$CheckResultsTableReferences
    extends BaseReferences<_$AppDatabase, $CheckResultsTable, CheckResult> {
  $$CheckResultsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EnvironmentsTable _environmentIdTable(_$AppDatabase db) =>
      db.environments.createAlias(
        $_aliasNameGenerator(db.checkResults.environmentId, db.environments.id),
      );

  $$EnvironmentsTableProcessedTableManager get environmentId {
    final $_column = $_itemColumn<int>('environment_id')!;

    final manager = $$EnvironmentsTableTableManager(
      $_db,
      $_db.environments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_environmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CheckResultsTableFilterComposer
    extends Composer<_$AppDatabase, $CheckResultsTable> {
  $$CheckResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get responseTimeMs => $composableBuilder(
    column: $table.responseTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUp => $composableBuilder(
    column: $table.isUp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  $$EnvironmentsTableFilterComposer get environmentId {
    final $$EnvironmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.environmentId,
      referencedTable: $db.environments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvironmentsTableFilterComposer(
            $db: $db,
            $table: $db.environments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CheckResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckResultsTable> {
  $$CheckResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get responseTimeMs => $composableBuilder(
    column: $table.responseTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUp => $composableBuilder(
    column: $table.isUp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  $$EnvironmentsTableOrderingComposer get environmentId {
    final $$EnvironmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.environmentId,
      referencedTable: $db.environments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvironmentsTableOrderingComposer(
            $db: $db,
            $table: $db.environments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CheckResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckResultsTable> {
  $$CheckResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedAt =>
      $composableBuilder(column: $table.checkedAt, builder: (column) => column);

  GeneratedColumn<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get responseTimeMs => $composableBuilder(
    column: $table.responseTimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isUp =>
      $composableBuilder(column: $table.isUp, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  $$EnvironmentsTableAnnotationComposer get environmentId {
    final $$EnvironmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.environmentId,
      referencedTable: $db.environments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvironmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.environments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CheckResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CheckResultsTable,
          CheckResult,
          $$CheckResultsTableFilterComposer,
          $$CheckResultsTableOrderingComposer,
          $$CheckResultsTableAnnotationComposer,
          $$CheckResultsTableCreateCompanionBuilder,
          $$CheckResultsTableUpdateCompanionBuilder,
          (CheckResult, $$CheckResultsTableReferences),
          CheckResult,
          PrefetchHooks Function({bool environmentId})
        > {
  $$CheckResultsTableTableManager(_$AppDatabase db, $CheckResultsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> environmentId = const Value.absent(),
                Value<DateTime> checkedAt = const Value.absent(),
                Value<int?> statusCode = const Value.absent(),
                Value<int?> responseTimeMs = const Value.absent(),
                Value<bool> isUp = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
              }) => CheckResultsCompanion(
                id: id,
                environmentId: environmentId,
                checkedAt: checkedAt,
                statusCode: statusCode,
                responseTimeMs: responseTimeMs,
                isUp: isUp,
                errorMessage: errorMessage,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int environmentId,
                Value<DateTime> checkedAt = const Value.absent(),
                Value<int?> statusCode = const Value.absent(),
                Value<int?> responseTimeMs = const Value.absent(),
                required bool isUp,
                Value<String?> errorMessage = const Value.absent(),
              }) => CheckResultsCompanion.insert(
                id: id,
                environmentId: environmentId,
                checkedAt: checkedAt,
                statusCode: statusCode,
                responseTimeMs: responseTimeMs,
                isUp: isUp,
                errorMessage: errorMessage,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CheckResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({environmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (environmentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.environmentId,
                                referencedTable: $$CheckResultsTableReferences
                                    ._environmentIdTable(db),
                                referencedColumn: $$CheckResultsTableReferences
                                    ._environmentIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CheckResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CheckResultsTable,
      CheckResult,
      $$CheckResultsTableFilterComposer,
      $$CheckResultsTableOrderingComposer,
      $$CheckResultsTableAnnotationComposer,
      $$CheckResultsTableCreateCompanionBuilder,
      $$CheckResultsTableUpdateCompanionBuilder,
      (CheckResult, $$CheckResultsTableReferences),
      CheckResult,
      PrefetchHooks Function({bool environmentId})
    >;
typedef $$IncidentsTableCreateCompanionBuilder =
    IncidentsCompanion Function({
      Value<int> id,
      required int environmentId,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<String> cause,
      Value<String> note,
      Value<bool> acknowledged,
    });
typedef $$IncidentsTableUpdateCompanionBuilder =
    IncidentsCompanion Function({
      Value<int> id,
      Value<int> environmentId,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<String> cause,
      Value<String> note,
      Value<bool> acknowledged,
    });

final class $$IncidentsTableReferences
    extends BaseReferences<_$AppDatabase, $IncidentsTable, Incident> {
  $$IncidentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EnvironmentsTable _environmentIdTable(_$AppDatabase db) =>
      db.environments.createAlias(
        $_aliasNameGenerator(db.incidents.environmentId, db.environments.id),
      );

  $$EnvironmentsTableProcessedTableManager get environmentId {
    final $_column = $_itemColumn<int>('environment_id')!;

    final manager = $$EnvironmentsTableTableManager(
      $_db,
      $_db.environments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_environmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IncidentsTableFilterComposer
    extends Composer<_$AppDatabase, $IncidentsTable> {
  $$IncidentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cause => $composableBuilder(
    column: $table.cause,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get acknowledged => $composableBuilder(
    column: $table.acknowledged,
    builder: (column) => ColumnFilters(column),
  );

  $$EnvironmentsTableFilterComposer get environmentId {
    final $$EnvironmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.environmentId,
      referencedTable: $db.environments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvironmentsTableFilterComposer(
            $db: $db,
            $table: $db.environments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncidentsTableOrderingComposer
    extends Composer<_$AppDatabase, $IncidentsTable> {
  $$IncidentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cause => $composableBuilder(
    column: $table.cause,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get acknowledged => $composableBuilder(
    column: $table.acknowledged,
    builder: (column) => ColumnOrderings(column),
  );

  $$EnvironmentsTableOrderingComposer get environmentId {
    final $$EnvironmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.environmentId,
      referencedTable: $db.environments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvironmentsTableOrderingComposer(
            $db: $db,
            $table: $db.environments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncidentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncidentsTable> {
  $$IncidentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get cause =>
      $composableBuilder(column: $table.cause, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get acknowledged => $composableBuilder(
    column: $table.acknowledged,
    builder: (column) => column,
  );

  $$EnvironmentsTableAnnotationComposer get environmentId {
    final $$EnvironmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.environmentId,
      referencedTable: $db.environments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnvironmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.environments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncidentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncidentsTable,
          Incident,
          $$IncidentsTableFilterComposer,
          $$IncidentsTableOrderingComposer,
          $$IncidentsTableAnnotationComposer,
          $$IncidentsTableCreateCompanionBuilder,
          $$IncidentsTableUpdateCompanionBuilder,
          (Incident, $$IncidentsTableReferences),
          Incident,
          PrefetchHooks Function({bool environmentId})
        > {
  $$IncidentsTableTableManager(_$AppDatabase db, $IncidentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncidentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncidentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncidentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> environmentId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String> cause = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> acknowledged = const Value.absent(),
              }) => IncidentsCompanion(
                id: id,
                environmentId: environmentId,
                startedAt: startedAt,
                endedAt: endedAt,
                cause: cause,
                note: note,
                acknowledged: acknowledged,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int environmentId,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String> cause = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> acknowledged = const Value.absent(),
              }) => IncidentsCompanion.insert(
                id: id,
                environmentId: environmentId,
                startedAt: startedAt,
                endedAt: endedAt,
                cause: cause,
                note: note,
                acknowledged: acknowledged,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IncidentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({environmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (environmentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.environmentId,
                                referencedTable: $$IncidentsTableReferences
                                    ._environmentIdTable(db),
                                referencedColumn: $$IncidentsTableReferences
                                    ._environmentIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IncidentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncidentsTable,
      Incident,
      $$IncidentsTableFilterComposer,
      $$IncidentsTableOrderingComposer,
      $$IncidentsTableAnnotationComposer,
      $$IncidentsTableCreateCompanionBuilder,
      $$IncidentsTableUpdateCompanionBuilder,
      (Incident, $$IncidentsTableReferences),
      Incident,
      PrefetchHooks Function({bool environmentId})
    >;
typedef $$WebhooksTableCreateCompanionBuilder =
    WebhooksCompanion Function({
      Value<int> id,
      required String name,
      Value<String> type,
      required String url,
      Value<String> triggerOn,
      Value<bool> isActive,
    });
typedef $$WebhooksTableUpdateCompanionBuilder =
    WebhooksCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> type,
      Value<String> url,
      Value<String> triggerOn,
      Value<bool> isActive,
    });

class $$WebhooksTableFilterComposer
    extends Composer<_$AppDatabase, $WebhooksTable> {
  $$WebhooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get triggerOn => $composableBuilder(
    column: $table.triggerOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WebhooksTableOrderingComposer
    extends Composer<_$AppDatabase, $WebhooksTable> {
  $$WebhooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggerOn => $composableBuilder(
    column: $table.triggerOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WebhooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $WebhooksTable> {
  $$WebhooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get triggerOn =>
      $composableBuilder(column: $table.triggerOn, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$WebhooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WebhooksTable,
          Webhook,
          $$WebhooksTableFilterComposer,
          $$WebhooksTableOrderingComposer,
          $$WebhooksTableAnnotationComposer,
          $$WebhooksTableCreateCompanionBuilder,
          $$WebhooksTableUpdateCompanionBuilder,
          (Webhook, BaseReferences<_$AppDatabase, $WebhooksTable, Webhook>),
          Webhook,
          PrefetchHooks Function()
        > {
  $$WebhooksTableTableManager(_$AppDatabase db, $WebhooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WebhooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WebhooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WebhooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> triggerOn = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => WebhooksCompanion(
                id: id,
                name: name,
                type: type,
                url: url,
                triggerOn: triggerOn,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> type = const Value.absent(),
                required String url,
                Value<String> triggerOn = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => WebhooksCompanion.insert(
                id: id,
                name: name,
                type: type,
                url: url,
                triggerOn: triggerOn,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WebhooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WebhooksTable,
      Webhook,
      $$WebhooksTableFilterComposer,
      $$WebhooksTableOrderingComposer,
      $$WebhooksTableAnnotationComposer,
      $$WebhooksTableCreateCompanionBuilder,
      $$WebhooksTableUpdateCompanionBuilder,
      (Webhook, BaseReferences<_$AppDatabase, $WebhooksTable, Webhook>),
      Webhook,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ServicesTableTableManager get services =>
      $$ServicesTableTableManager(_db, _db.services);
  $$EnvironmentsTableTableManager get environments =>
      $$EnvironmentsTableTableManager(_db, _db.environments);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$EnvironmentTagsTableTableManager get environmentTags =>
      $$EnvironmentTagsTableTableManager(_db, _db.environmentTags);
  $$CheckResultsTableTableManager get checkResults =>
      $$CheckResultsTableTableManager(_db, _db.checkResults);
  $$IncidentsTableTableManager get incidents =>
      $$IncidentsTableTableManager(_db, _db.incidents);
  $$WebhooksTableTableManager get webhooks =>
      $$WebhooksTableTableManager(_db, _db.webhooks);
}
