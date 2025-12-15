// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_album_stats.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlaybackAlbumStatsCollection on Isar {
  IsarCollection<PlaybackAlbumStats> get playbackAlbumStats =>
      this.collection();
}

const PlaybackAlbumStatsSchema = CollectionSchema(
  name: r'PlaybackAlbumStats',
  id: -5784299464500561298,
  properties: {
    r'albumId': PropertySchema(
      id: 0,
      name: r'albumId',
      type: IsarType.string,
    ),
    r'albumJson': PropertySchema(
      id: 1,
      name: r'albumJson',
      type: IsarType.string,
    ),
    r'month': PropertySchema(
      id: 2,
      name: r'month',
      type: IsarType.long,
    ),
    r'playCount': PropertySchema(
      id: 3,
      name: r'playCount',
      type: IsarType.long,
    ),
    r'secondsPlayed': PropertySchema(
      id: 4,
      name: r'secondsPlayed',
      type: IsarType.long,
    ),
    r'year': PropertySchema(
      id: 5,
      name: r'year',
      type: IsarType.long,
    ),
    r'yearMonthKey': PropertySchema(
      id: 6,
      name: r'yearMonthKey',
      type: IsarType.long,
    )
  },
  estimateSize: _playbackAlbumStatsEstimateSize,
  serialize: _playbackAlbumStatsSerialize,
  deserialize: _playbackAlbumStatsDeserialize,
  deserializeProp: _playbackAlbumStatsDeserializeProp,
  idName: r'id',
  indexes: {
    r'albumId': IndexSchema(
      id: -3314078833704812111,
      name: r'albumId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'albumId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'year': IndexSchema(
      id: -875522826430421864,
      name: r'year',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'year',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'month': IndexSchema(
      id: -3594385961712742690,
      name: r'month',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'month',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'yearMonthKey': IndexSchema(
      id: -7336763800647463484,
      name: r'yearMonthKey',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'yearMonthKey',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _playbackAlbumStatsGetId,
  getLinks: _playbackAlbumStatsGetLinks,
  attach: _playbackAlbumStatsAttach,
  version: '3.1.0+1',
);

int _playbackAlbumStatsEstimateSize(
  PlaybackAlbumStats object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.albumId.length * 3;
  bytesCount += 3 + object.albumJson.length * 3;
  return bytesCount;
}

void _playbackAlbumStatsSerialize(
  PlaybackAlbumStats object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.albumId);
  writer.writeString(offsets[1], object.albumJson);
  writer.writeLong(offsets[2], object.month);
  writer.writeLong(offsets[3], object.playCount);
  writer.writeLong(offsets[4], object.secondsPlayed);
  writer.writeLong(offsets[5], object.year);
  writer.writeLong(offsets[6], object.yearMonthKey);
}

PlaybackAlbumStats _playbackAlbumStatsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlaybackAlbumStats();
  object.albumId = reader.readString(offsets[0]);
  object.albumJson = reader.readString(offsets[1]);
  object.id = id;
  object.month = reader.readLong(offsets[2]);
  object.playCount = reader.readLong(offsets[3]);
  object.secondsPlayed = reader.readLong(offsets[4]);
  object.year = reader.readLong(offsets[5]);
  object.yearMonthKey = reader.readLong(offsets[6]);
  return object;
}

P _playbackAlbumStatsDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _playbackAlbumStatsGetId(PlaybackAlbumStats object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playbackAlbumStatsGetLinks(
    PlaybackAlbumStats object) {
  return [];
}

void _playbackAlbumStatsAttach(
    IsarCollection<dynamic> col, Id id, PlaybackAlbumStats object) {
  object.id = id;
}

extension PlaybackAlbumStatsQueryWhereSort
    on QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QWhere> {
  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhere> anyYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'year'),
      );
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhere> anyMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'month'),
      );
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhere>
      anyYearMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'yearMonthKey'),
      );
    });
  }
}

extension PlaybackAlbumStatsQueryWhere
    on QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QWhereClause> {
  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      albumIdEqualTo(String albumId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'albumId',
        value: [albumId],
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      albumIdNotEqualTo(String albumId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'albumId',
              lower: [],
              upper: [albumId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'albumId',
              lower: [albumId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'albumId',
              lower: [albumId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'albumId',
              lower: [],
              upper: [albumId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      yearEqualTo(int year) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'year',
        value: [year],
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      yearNotEqualTo(int year) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'year',
              lower: [],
              upper: [year],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'year',
              lower: [year],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'year',
              lower: [year],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'year',
              lower: [],
              upper: [year],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      yearGreaterThan(
    int year, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'year',
        lower: [year],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      yearLessThan(
    int year, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'year',
        lower: [],
        upper: [year],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      yearBetween(
    int lowerYear,
    int upperYear, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'year',
        lower: [lowerYear],
        includeLower: includeLower,
        upper: [upperYear],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      monthEqualTo(int month) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'month',
        value: [month],
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      monthNotEqualTo(int month) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'month',
              lower: [],
              upper: [month],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'month',
              lower: [month],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'month',
              lower: [month],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'month',
              lower: [],
              upper: [month],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      monthGreaterThan(
    int month, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'month',
        lower: [month],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      monthLessThan(
    int month, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'month',
        lower: [],
        upper: [month],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      monthBetween(
    int lowerMonth,
    int upperMonth, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'month',
        lower: [lowerMonth],
        includeLower: includeLower,
        upper: [upperMonth],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      yearMonthKeyEqualTo(int yearMonthKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'yearMonthKey',
        value: [yearMonthKey],
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      yearMonthKeyNotEqualTo(int yearMonthKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'yearMonthKey',
              lower: [],
              upper: [yearMonthKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'yearMonthKey',
              lower: [yearMonthKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'yearMonthKey',
              lower: [yearMonthKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'yearMonthKey',
              lower: [],
              upper: [yearMonthKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      yearMonthKeyGreaterThan(
    int yearMonthKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'yearMonthKey',
        lower: [yearMonthKey],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      yearMonthKeyLessThan(
    int yearMonthKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'yearMonthKey',
        lower: [],
        upper: [yearMonthKey],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterWhereClause>
      yearMonthKeyBetween(
    int lowerYearMonthKey,
    int upperYearMonthKey, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'yearMonthKey',
        lower: [lowerYearMonthKey],
        includeLower: includeLower,
        upper: [upperYearMonthKey],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PlaybackAlbumStatsQueryFilter
    on QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QFilterCondition> {
  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumIdEqualTo(
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

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumIdLessThan(
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

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumIdBetween(
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

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumIdStartsWith(
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

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumIdEndsWith(
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

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'albumId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'albumId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'albumId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'albumJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'albumJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'albumJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'albumJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'albumJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'albumJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'albumJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'albumJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      albumJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'albumJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      monthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      monthGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      monthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      monthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'month',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      playCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      playCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      playCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      playCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      secondsPlayedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secondsPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      secondsPlayedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'secondsPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      secondsPlayedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'secondsPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      secondsPlayedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'secondsPlayed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      yearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      yearGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      yearLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      yearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'year',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      yearMonthKeyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yearMonthKey',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      yearMonthKeyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'yearMonthKey',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      yearMonthKeyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'yearMonthKey',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterFilterCondition>
      yearMonthKeyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'yearMonthKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PlaybackAlbumStatsQueryObject
    on QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QFilterCondition> {}

extension PlaybackAlbumStatsQueryLinks
    on QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QFilterCondition> {}

extension PlaybackAlbumStatsQuerySortBy
    on QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QSortBy> {
  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      sortByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      sortByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      sortByAlbumJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumJson', Sort.asc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      sortByAlbumJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumJson', Sort.desc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      sortByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      sortByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      sortByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.asc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      sortByPlayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.desc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      sortBySecondsPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondsPlayed', Sort.asc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      sortBySecondsPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondsPlayed', Sort.desc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      sortByYearMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearMonthKey', Sort.asc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      sortByYearMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearMonthKey', Sort.desc);
    });
  }
}

extension PlaybackAlbumStatsQuerySortThenBy
    on QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QSortThenBy> {
  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      thenByAlbumId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.asc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      thenByAlbumIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumId', Sort.desc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      thenByAlbumJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumJson', Sort.asc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      thenByAlbumJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'albumJson', Sort.desc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      thenByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      thenByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      thenByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.asc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      thenByPlayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.desc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      thenBySecondsPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondsPlayed', Sort.asc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      thenBySecondsPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondsPlayed', Sort.desc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      thenByYearMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearMonthKey', Sort.asc);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QAfterSortBy>
      thenByYearMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearMonthKey', Sort.desc);
    });
  }
}

extension PlaybackAlbumStatsQueryWhereDistinct
    on QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QDistinct> {
  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QDistinct>
      distinctByAlbumId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'albumId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QDistinct>
      distinctByAlbumJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'albumJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QDistinct>
      distinctByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'month');
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QDistinct>
      distinctByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playCount');
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QDistinct>
      distinctBySecondsPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'secondsPlayed');
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QDistinct>
      distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }

  QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QDistinct>
      distinctByYearMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yearMonthKey');
    });
  }
}

extension PlaybackAlbumStatsQueryProperty
    on QueryBuilder<PlaybackAlbumStats, PlaybackAlbumStats, QQueryProperty> {
  QueryBuilder<PlaybackAlbumStats, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlaybackAlbumStats, String, QQueryOperations> albumIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albumId');
    });
  }

  QueryBuilder<PlaybackAlbumStats, String, QQueryOperations>
      albumJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'albumJson');
    });
  }

  QueryBuilder<PlaybackAlbumStats, int, QQueryOperations> monthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'month');
    });
  }

  QueryBuilder<PlaybackAlbumStats, int, QQueryOperations> playCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playCount');
    });
  }

  QueryBuilder<PlaybackAlbumStats, int, QQueryOperations>
      secondsPlayedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'secondsPlayed');
    });
  }

  QueryBuilder<PlaybackAlbumStats, int, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }

  QueryBuilder<PlaybackAlbumStats, int, QQueryOperations>
      yearMonthKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yearMonthKey');
    });
  }
}
