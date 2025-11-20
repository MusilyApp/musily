// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_state.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlayerStateCollection on Isar {
  IsarCollection<PlayerState> get playerStates => this.collection();
}

const PlayerStateSchema = CollectionSchema(
  name: r'PlayerState',
  id: 7799289008565125410,
  properties: {
    r'currentTrackHash': PropertySchema(
      id: 0,
      name: r'currentTrackHash',
      type: IsarType.string,
    ),
    r'currentTrackId': PropertySchema(
      id: 1,
      name: r'currentTrackId',
      type: IsarType.string,
    ),
    r'currentTrackJson': PropertySchema(
      id: 2,
      name: r'currentTrackJson',
      type: IsarType.string,
    ),
    r'lastUpdated': PropertySchema(
      id: 3,
      name: r'lastUpdated',
      type: IsarType.long,
    ),
    r'repeatMode': PropertySchema(
      id: 4,
      name: r'repeatMode',
      type: IsarType.string,
    ),
    r'shuffleEnabled': PropertySchema(
      id: 5,
      name: r'shuffleEnabled',
      type: IsarType.bool,
    ),
    r'stateKey': PropertySchema(
      id: 6,
      name: r'stateKey',
      type: IsarType.string,
    )
  },
  estimateSize: _playerStateEstimateSize,
  serialize: _playerStateSerialize,
  deserialize: _playerStateDeserialize,
  deserializeProp: _playerStateDeserializeProp,
  idName: r'id',
  indexes: {
    r'stateKey': IndexSchema(
      id: 535423888346486579,
      name: r'stateKey',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'stateKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _playerStateGetId,
  getLinks: _playerStateGetLinks,
  attach: _playerStateAttach,
  version: '3.1.0+1',
);

int _playerStateEstimateSize(
  PlayerState object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.currentTrackHash;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.currentTrackId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.currentTrackJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.repeatMode.length * 3;
  bytesCount += 3 + object.stateKey.length * 3;
  return bytesCount;
}

void _playerStateSerialize(
  PlayerState object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.currentTrackHash);
  writer.writeString(offsets[1], object.currentTrackId);
  writer.writeString(offsets[2], object.currentTrackJson);
  writer.writeLong(offsets[3], object.lastUpdated);
  writer.writeString(offsets[4], object.repeatMode);
  writer.writeBool(offsets[5], object.shuffleEnabled);
  writer.writeString(offsets[6], object.stateKey);
}

PlayerState _playerStateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlayerState();
  object.currentTrackHash = reader.readStringOrNull(offsets[0]);
  object.currentTrackId = reader.readStringOrNull(offsets[1]);
  object.currentTrackJson = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.lastUpdated = reader.readLong(offsets[3]);
  object.repeatMode = reader.readString(offsets[4]);
  object.shuffleEnabled = reader.readBool(offsets[5]);
  object.stateKey = reader.readString(offsets[6]);
  return object;
}

P _playerStateDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _playerStateGetId(PlayerState object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playerStateGetLinks(PlayerState object) {
  return [];
}

void _playerStateAttach(
    IsarCollection<dynamic> col, Id id, PlayerState object) {
  object.id = id;
}

extension PlayerStateByIndex on IsarCollection<PlayerState> {
  Future<PlayerState?> getByStateKey(String stateKey) {
    return getByIndex(r'stateKey', [stateKey]);
  }

  PlayerState? getByStateKeySync(String stateKey) {
    return getByIndexSync(r'stateKey', [stateKey]);
  }

  Future<bool> deleteByStateKey(String stateKey) {
    return deleteByIndex(r'stateKey', [stateKey]);
  }

  bool deleteByStateKeySync(String stateKey) {
    return deleteByIndexSync(r'stateKey', [stateKey]);
  }

  Future<List<PlayerState?>> getAllByStateKey(List<String> stateKeyValues) {
    final values = stateKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'stateKey', values);
  }

  List<PlayerState?> getAllByStateKeySync(List<String> stateKeyValues) {
    final values = stateKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'stateKey', values);
  }

  Future<int> deleteAllByStateKey(List<String> stateKeyValues) {
    final values = stateKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'stateKey', values);
  }

  int deleteAllByStateKeySync(List<String> stateKeyValues) {
    final values = stateKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'stateKey', values);
  }

  Future<Id> putByStateKey(PlayerState object) {
    return putByIndex(r'stateKey', object);
  }

  Id putByStateKeySync(PlayerState object, {bool saveLinks = true}) {
    return putByIndexSync(r'stateKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByStateKey(List<PlayerState> objects) {
    return putAllByIndex(r'stateKey', objects);
  }

  List<Id> putAllByStateKeySync(List<PlayerState> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'stateKey', objects, saveLinks: saveLinks);
  }
}

extension PlayerStateQueryWhereSort
    on QueryBuilder<PlayerState, PlayerState, QWhere> {
  QueryBuilder<PlayerState, PlayerState, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlayerStateQueryWhere
    on QueryBuilder<PlayerState, PlayerState, QWhereClause> {
  QueryBuilder<PlayerState, PlayerState, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterWhereClause> stateKeyEqualTo(
      String stateKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'stateKey',
        value: [stateKey],
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterWhereClause> stateKeyNotEqualTo(
      String stateKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stateKey',
              lower: [],
              upper: [stateKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stateKey',
              lower: [stateKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stateKey',
              lower: [stateKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'stateKey',
              lower: [],
              upper: [stateKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PlayerStateQueryFilter
    on QueryBuilder<PlayerState, PlayerState, QFilterCondition> {
  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackHashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentTrackHash',
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackHashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentTrackHash',
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackHashEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentTrackHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackHashGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentTrackHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackHashLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentTrackHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackHashBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentTrackHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currentTrackHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currentTrackHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currentTrackHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currentTrackHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentTrackHash',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currentTrackHash',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentTrackId',
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentTrackId',
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentTrackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentTrackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentTrackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentTrackId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currentTrackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currentTrackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currentTrackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currentTrackId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentTrackId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currentTrackId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentTrackJson',
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentTrackJson',
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentTrackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentTrackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentTrackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentTrackJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currentTrackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currentTrackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currentTrackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currentTrackJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentTrackJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      currentTrackJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currentTrackJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      lastUpdatedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      lastUpdatedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      lastUpdatedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      repeatModeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repeatMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      repeatModeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repeatMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      repeatModeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repeatMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      repeatModeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repeatMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      repeatModeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'repeatMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      repeatModeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'repeatMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      repeatModeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'repeatMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      repeatModeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'repeatMode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      repeatModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repeatMode',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      repeatModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'repeatMode',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      shuffleEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shuffleEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition> stateKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      stateKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      stateKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition> stateKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stateKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      stateKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      stateKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      stateKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition> stateKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stateKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      stateKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateKey',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterFilterCondition>
      stateKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stateKey',
        value: '',
      ));
    });
  }
}

extension PlayerStateQueryObject
    on QueryBuilder<PlayerState, PlayerState, QFilterCondition> {}

extension PlayerStateQueryLinks
    on QueryBuilder<PlayerState, PlayerState, QFilterCondition> {}

extension PlayerStateQuerySortBy
    on QueryBuilder<PlayerState, PlayerState, QSortBy> {
  QueryBuilder<PlayerState, PlayerState, QAfterSortBy>
      sortByCurrentTrackHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTrackHash', Sort.asc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy>
      sortByCurrentTrackHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTrackHash', Sort.desc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> sortByCurrentTrackId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTrackId', Sort.asc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy>
      sortByCurrentTrackIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTrackId', Sort.desc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy>
      sortByCurrentTrackJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTrackJson', Sort.asc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy>
      sortByCurrentTrackJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTrackJson', Sort.desc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> sortByRepeatMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatMode', Sort.asc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> sortByRepeatModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatMode', Sort.desc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> sortByShuffleEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shuffleEnabled', Sort.asc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy>
      sortByShuffleEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shuffleEnabled', Sort.desc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> sortByStateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateKey', Sort.asc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> sortByStateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateKey', Sort.desc);
    });
  }
}

extension PlayerStateQuerySortThenBy
    on QueryBuilder<PlayerState, PlayerState, QSortThenBy> {
  QueryBuilder<PlayerState, PlayerState, QAfterSortBy>
      thenByCurrentTrackHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTrackHash', Sort.asc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy>
      thenByCurrentTrackHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTrackHash', Sort.desc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> thenByCurrentTrackId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTrackId', Sort.asc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy>
      thenByCurrentTrackIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTrackId', Sort.desc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy>
      thenByCurrentTrackJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTrackJson', Sort.asc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy>
      thenByCurrentTrackJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentTrackJson', Sort.desc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> thenByRepeatMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatMode', Sort.asc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> thenByRepeatModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeatMode', Sort.desc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> thenByShuffleEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shuffleEnabled', Sort.asc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy>
      thenByShuffleEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shuffleEnabled', Sort.desc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> thenByStateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateKey', Sort.asc);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QAfterSortBy> thenByStateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateKey', Sort.desc);
    });
  }
}

extension PlayerStateQueryWhereDistinct
    on QueryBuilder<PlayerState, PlayerState, QDistinct> {
  QueryBuilder<PlayerState, PlayerState, QDistinct> distinctByCurrentTrackHash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentTrackHash',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QDistinct> distinctByCurrentTrackId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentTrackId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QDistinct> distinctByCurrentTrackJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentTrackJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QDistinct> distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<PlayerState, PlayerState, QDistinct> distinctByRepeatMode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repeatMode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerState, PlayerState, QDistinct> distinctByShuffleEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shuffleEnabled');
    });
  }

  QueryBuilder<PlayerState, PlayerState, QDistinct> distinctByStateKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stateKey', caseSensitive: caseSensitive);
    });
  }
}

extension PlayerStateQueryProperty
    on QueryBuilder<PlayerState, PlayerState, QQueryProperty> {
  QueryBuilder<PlayerState, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlayerState, String?, QQueryOperations>
      currentTrackHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentTrackHash');
    });
  }

  QueryBuilder<PlayerState, String?, QQueryOperations>
      currentTrackIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentTrackId');
    });
  }

  QueryBuilder<PlayerState, String?, QQueryOperations>
      currentTrackJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentTrackJson');
    });
  }

  QueryBuilder<PlayerState, int, QQueryOperations> lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<PlayerState, String, QQueryOperations> repeatModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeatMode');
    });
  }

  QueryBuilder<PlayerState, bool, QQueryOperations> shuffleEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shuffleEnabled');
    });
  }

  QueryBuilder<PlayerState, String, QQueryOperations> stateKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stateKey');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetQueueTrackCollection on Isar {
  IsarCollection<QueueTrack> get queueTracks => this.collection();
}

const QueueTrackSchema = CollectionSchema(
  name: r'QueueTrack',
  id: 2540172975017435456,
  properties: {
    r'albumId': PropertySchema(
      id: 0,
      name: r'albumId',
      type: IsarType.string,
    ),
    r'albumTitle': PropertySchema(
      id: 1,
      name: r'albumTitle',
      type: IsarType.string,
    ),
    r'artistId': PropertySchema(
      id: 2,
      name: r'artistId',
      type: IsarType.string,
    ),
    r'artistName': PropertySchema(
      id: 3,
      name: r'artistName',
      type: IsarType.string,
    ),
    r'durationMs': PropertySchema(
      id: 4,
      name: r'durationMs',
      type: IsarType.long,
    ),
    r'fromSmartQueue': PropertySchema(
      id: 5,
      name: r'fromSmartQueue',
      type: IsarType.bool,
    ),
    r'hash': PropertySchema(
      id: 6,
      name: r'hash',
      type: IsarType.string,
    ),
    r'highResImg': PropertySchema(
      id: 7,
      name: r'highResImg',
      type: IsarType.string,
    ),
    r'isLocal': PropertySchema(
      id: 8,
      name: r'isLocal',
      type: IsarType.bool,
    ),
    r'lowResImg': PropertySchema(
      id: 9,
      name: r'lowResImg',
      type: IsarType.string,
    ),
    r'orderIndex': PropertySchema(
      id: 10,
      name: r'orderIndex',
      type: IsarType.long,
    ),
    r'positionMs': PropertySchema(
      id: 11,
      name: r'positionMs',
      type: IsarType.long,
    ),
    r'queueType': PropertySchema(
      id: 12,
      name: r'queueType',
      type: IsarType.string,
    ),
    r'source': PropertySchema(
      id: 13,
      name: r'source',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 14,
      name: r'title',
      type: IsarType.string,
    ),
    r'trackId': PropertySchema(
      id: 15,
      name: r'trackId',
      type: IsarType.string,
    ),
    r'url': PropertySchema(
      id: 16,
      name: r'url',
      type: IsarType.string,
    )
  },
  estimateSize: _queueTrackEstimateSize,
  serialize: _queueTrackSerialize,
  deserialize: _queueTrackDeserialize,
  deserializeProp: _queueTrackDeserializeProp,
  idName: r'id',
  indexes: {
    r'queueType': IndexSchema(
      id: -3806745889451951065,
      name: r'queueType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'queueType',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _queueTrackGetId,
  getLinks: _queueTrackGetLinks,
  attach: _queueTrackAttach,
  version: '3.1.0+1',
);

int _queueTrackEstimateSize(
  QueueTrack object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.albumId.length * 3;
  bytesCount += 3 + object.albumTitle.length * 3;
  bytesCount += 3 + object.artistId.length * 3;
  bytesCount += 3 + object.artistName.length * 3;
  bytesCount += 3 + object.hash.length * 3;
  {
    final value = object.highResImg;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lowResImg;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.queueType.length * 3;
  {
    final value = object.source;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.trackId.length * 3;
  {
    final value = object.url;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _queueTrackSerialize(
  QueueTrack object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.albumId);
  writer.writeString(offsets[1], object.albumTitle);
  writer.writeString(offsets[2], object.artistId);
  writer.writeString(offsets[3], object.artistName);
  writer.writeLong(offsets[4], object.durationMs);
  writer.writeBool(offsets[5], object.fromSmartQueue);
  writer.writeString(offsets[6], object.hash);
  writer.writeString(offsets[7], object.highResImg);
  writer.writeBool(offsets[8], object.isLocal);
  writer.writeString(offsets[9], object.lowResImg);
  writer.writeLong(offsets[10], object.orderIndex);
  writer.writeLong(offsets[11], object.positionMs);
  writer.writeString(offsets[12], object.queueType);
  writer.writeString(offsets[13], object.source);
  writer.writeString(offsets[14], object.title);
  writer.writeString(offsets[15], object.trackId);
  writer.writeString(offsets[16], object.url);
}

QueueTrack _queueTrackDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = QueueTrack();
  object.albumId = reader.readString(offsets[0]);
  object.albumTitle = reader.readString(offsets[1]);
  object.artistId = reader.readString(offsets[2]);
  object.artistName = reader.readString(offsets[3]);
  object.durationMs = reader.readLong(offsets[4]);
  object.fromSmartQueue = reader.readBool(offsets[5]);
  object.hash = reader.readString(offsets[6]);
  object.highResImg = reader.readStringOrNull(offsets[7]);
  object.id = id;
  object.isLocal = reader.readBool(offsets[8]);
  object.lowResImg = reader.readStringOrNull(offsets[9]);
  object.orderIndex = reader.readLong(offsets[10]);
  object.positionMs = reader.readLong(offsets[11]);
  object.queueType = reader.readString(offsets[12]);
  object.source = reader.readStringOrNull(offsets[13]);
  object.title = reader.readString(offsets[14]);
  object.trackId = reader.readString(offsets[15]);
  object.url = reader.readStringOrNull(offsets[16]);
  return object;
}

P _queueTrackDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _queueTrackGetId(QueueTrack object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _queueTrackGetLinks(QueueTrack object) {
  return [];
}

void _queueTrackAttach(IsarCollection<dynamic> col, Id id, QueueTrack object) {
  object.id = id;
}

extension QueueTrackQueryWhereSort
    on QueryBuilder<QueueTrack, QueueTrack, QWhere> {
  QueryBuilder<QueueTrack, QueueTrack, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension QueueTrackQueryWhere
    on QueryBuilder<QueueTrack, QueueTrack, QWhereClause> {
  QueryBuilder<QueueTrack, QueueTrack, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterWhereClause> queueTypeEqualTo(
      String queueType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'queueType',
        value: [queueType],
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterWhereClause> queueTypeNotEqualTo(
      String queueType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'queueType',
              lower: [],
              upper: [queueType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'queueType',
              lower: [queueType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'queueType',
              lower: [queueType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'queueType',
              lower: [],
              upper: [queueType],
              includeUpper: false,
            ));
      }
    });
  }
}

extension QueueTrackQueryFilter
    on QueryBuilder<QueueTrack, QueueTrack, QFilterCondition> {
  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> albumIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      albumIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'albumId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> albumIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'albumId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> albumIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'albumId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> albumIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'albumId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> albumIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'albumId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> albumIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'albumId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> albumIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'albumId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> albumIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumId',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      albumIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'albumId',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> albumTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      albumTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'albumTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      albumTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'albumTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> albumTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'albumTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      albumTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'albumTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      albumTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'albumTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      albumTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'albumTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> albumTitleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'albumTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      albumTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      albumTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'albumTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> artistIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      artistIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'artistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> artistIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'artistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> artistIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'artistId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      artistIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'artistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> artistIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'artistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> artistIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'artistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> artistIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'artistId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      artistIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artistId',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      artistIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'artistId',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> artistNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      artistNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'artistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      artistNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'artistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> artistNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'artistName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      artistNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'artistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      artistNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'artistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      artistNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'artistName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> artistNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'artistName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      artistNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artistName',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      artistNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'artistName',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> durationMsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      durationMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      durationMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> durationMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      fromSmartQueueEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fromSmartQueue',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> hashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> hashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> hashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> hashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> hashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> hashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> hashContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> hashMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> hashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hash',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> hashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hash',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      highResImgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'highResImg',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      highResImgIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'highResImg',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> highResImgEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'highResImg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      highResImgGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'highResImg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      highResImgLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'highResImg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> highResImgBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'highResImg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      highResImgStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'highResImg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      highResImgEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'highResImg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      highResImgContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'highResImg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> highResImgMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'highResImg',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      highResImgIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'highResImg',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      highResImgIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'highResImg',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> isLocalEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isLocal',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      lowResImgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lowResImg',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      lowResImgIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lowResImg',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> lowResImgEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lowResImg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      lowResImgGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lowResImg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> lowResImgLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lowResImg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> lowResImgBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lowResImg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      lowResImgStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lowResImg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> lowResImgEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lowResImg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> lowResImgContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lowResImg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> lowResImgMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lowResImg',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      lowResImgIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lowResImg',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      lowResImgIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lowResImg',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> orderIndexEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      orderIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      orderIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> orderIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> positionMsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'positionMs',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      positionMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'positionMs',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      positionMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'positionMs',
        value: value,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> positionMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'positionMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> queueTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'queueType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      queueTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'queueType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> queueTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'queueType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> queueTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'queueType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      queueTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'queueType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> queueTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'queueType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> queueTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'queueType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> queueTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'queueType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      queueTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'queueType',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      queueTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'queueType',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> sourceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'source',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      sourceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'source',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> sourceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> sourceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> sourceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> sourceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> sourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> sourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> sourceContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> sourceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'source',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> trackIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      trackIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> trackIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> trackIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trackId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> trackIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'trackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> trackIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'trackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> trackIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'trackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> trackIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'trackId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> trackIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackId',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition>
      trackIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'trackId',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> urlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'url',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> urlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'url',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> urlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> urlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> urlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> urlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> urlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> urlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterFilterCondition> urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }
}

extension QueueTrackQueryObject
    on QueryBuilder<QueueTrack, QueueTrack, QFilterCondition> {}

extension QueueTrackQueryLinks
    on QueryBuilder<QueueTrack, QueueTrack, QFilterCondition> {}

extension QueueTrackQuerySortBy
    on QueryBuilder<QueueTrack, QueueTrack, QSortBy> {
  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByAlbumTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumTitle', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByAlbumTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumTitle', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByArtistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByArtistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByArtistName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistName', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByArtistNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistName', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByFromSmartQueue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fromSmartQueue', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy>
      sortByFromSmartQueueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fromSmartQueue', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByHighResImg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highResImg', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByHighResImgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highResImg', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByIsLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocal', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByIsLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocal', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByLowResImg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowResImg', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByLowResImgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowResImg', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByPositionMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByQueueType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queueType', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByQueueTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queueType', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByTrackId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByTrackIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension QueueTrackQuerySortThenBy
    on QueryBuilder<QueueTrack, QueueTrack, QSortThenBy> {
  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByAlbumTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumTitle', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByAlbumTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumTitle', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByArtistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByArtistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByArtistName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistName', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByArtistNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistName', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByFromSmartQueue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fromSmartQueue', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy>
      thenByFromSmartQueueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fromSmartQueue', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByHighResImg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highResImg', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByHighResImgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highResImg', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByIsLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocal', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByIsLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocal', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByLowResImg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowResImg', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByLowResImgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowResImg', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByPositionMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByQueueType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queueType', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByQueueTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queueType', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByTrackId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByTrackIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.desc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QAfterSortBy> thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension QueueTrackQueryWhereDistinct
    on QueryBuilder<QueueTrack, QueueTrack, QDistinct> {
  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctByAlbumId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'albumId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctByAlbumTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'albumTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctByArtistId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'artistId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctByArtistName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'artistName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationMs');
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctByFromSmartQueue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fromSmartQueue');
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctByHash(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctByHighResImg(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'highResImg', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctByIsLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isLocal');
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctByLowResImg(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lowResImg', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderIndex');
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'positionMs');
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctByQueueType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'queueType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctBySource(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctByTrackId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trackId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueTrack, QueueTrack, QDistinct> distinctByUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }
}

extension QueueTrackQueryProperty
    on QueryBuilder<QueueTrack, QueueTrack, QQueryProperty> {
  QueryBuilder<QueueTrack, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<QueueTrack, String, QQueryOperations> albumIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albumId');
    });
  }

  QueryBuilder<QueueTrack, String, QQueryOperations> albumTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albumTitle');
    });
  }

  QueryBuilder<QueueTrack, String, QQueryOperations> artistIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'artistId');
    });
  }

  QueryBuilder<QueueTrack, String, QQueryOperations> artistNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'artistName');
    });
  }

  QueryBuilder<QueueTrack, int, QQueryOperations> durationMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationMs');
    });
  }

  QueryBuilder<QueueTrack, bool, QQueryOperations> fromSmartQueueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fromSmartQueue');
    });
  }

  QueryBuilder<QueueTrack, String, QQueryOperations> hashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hash');
    });
  }

  QueryBuilder<QueueTrack, String?, QQueryOperations> highResImgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'highResImg');
    });
  }

  QueryBuilder<QueueTrack, bool, QQueryOperations> isLocalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isLocal');
    });
  }

  QueryBuilder<QueueTrack, String?, QQueryOperations> lowResImgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lowResImg');
    });
  }

  QueryBuilder<QueueTrack, int, QQueryOperations> orderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderIndex');
    });
  }

  QueryBuilder<QueueTrack, int, QQueryOperations> positionMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'positionMs');
    });
  }

  QueryBuilder<QueueTrack, String, QQueryOperations> queueTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'queueType');
    });
  }

  QueryBuilder<QueueTrack, String?, QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<QueueTrack, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<QueueTrack, String, QQueryOperations> trackIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackId');
    });
  }

  QueryBuilder<QueueTrack, String?, QQueryOperations> urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }
}
