// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_artist_stats.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlaybackArtistStatsCollection on Isar {
  IsarCollection<PlaybackArtistStats> get playbackArtistStats =>
      this.collection();
}

const PlaybackArtistStatsSchema = CollectionSchema(
  name: r'PlaybackArtistStats',
  id: -1315894392234500530,
  properties: {
    r'artistId': PropertySchema(
      id: 0,
      name: r'artistId',
      type: IsarType.string,
    ),
    r'artistJson': PropertySchema(
      id: 1,
      name: r'artistJson',
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
  estimateSize: _playbackArtistStatsEstimateSize,
  serialize: _playbackArtistStatsSerialize,
  deserialize: _playbackArtistStatsDeserialize,
  deserializeProp: _playbackArtistStatsDeserializeProp,
  idName: r'id',
  indexes: {
    r'artistId': IndexSchema(
      id: 8275676849534481306,
      name: r'artistId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'artistId',
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
  getId: _playbackArtistStatsGetId,
  getLinks: _playbackArtistStatsGetLinks,
  attach: _playbackArtistStatsAttach,
  version: '3.1.0+1',
);

int _playbackArtistStatsEstimateSize(
  PlaybackArtistStats object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.artistId.length * 3;
  bytesCount += 3 + object.artistJson.length * 3;
  return bytesCount;
}

void _playbackArtistStatsSerialize(
  PlaybackArtistStats object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.artistId);
  writer.writeString(offsets[1], object.artistJson);
  writer.writeLong(offsets[2], object.month);
  writer.writeLong(offsets[3], object.playCount);
  writer.writeLong(offsets[4], object.secondsPlayed);
  writer.writeLong(offsets[5], object.year);
  writer.writeLong(offsets[6], object.yearMonthKey);
}

PlaybackArtistStats _playbackArtistStatsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlaybackArtistStats();
  object.artistId = reader.readString(offsets[0]);
  object.artistJson = reader.readString(offsets[1]);
  object.id = id;
  object.month = reader.readLong(offsets[2]);
  object.playCount = reader.readLong(offsets[3]);
  object.secondsPlayed = reader.readLong(offsets[4]);
  object.year = reader.readLong(offsets[5]);
  object.yearMonthKey = reader.readLong(offsets[6]);
  return object;
}

P _playbackArtistStatsDeserializeProp<P>(
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

Id _playbackArtistStatsGetId(PlaybackArtistStats object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playbackArtistStatsGetLinks(
    PlaybackArtistStats object) {
  return [];
}

void _playbackArtistStatsAttach(
    IsarCollection<dynamic> col, Id id, PlaybackArtistStats object) {
  object.id = id;
}

extension PlaybackArtistStatsQueryWhereSort
    on QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QWhere> {
  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhere>
      anyYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'year'),
      );
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhere>
      anyMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'month'),
      );
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhere>
      anyYearMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'yearMonthKey'),
      );
    });
  }
}

extension PlaybackArtistStatsQueryWhere
    on QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QWhereClause> {
  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
      artistIdEqualTo(String artistId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'artistId',
        value: [artistId],
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
      artistIdNotEqualTo(String artistId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'artistId',
              lower: [],
              upper: [artistId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'artistId',
              lower: [artistId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'artistId',
              lower: [artistId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'artistId',
              lower: [],
              upper: [artistId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
      yearEqualTo(int year) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'year',
        value: [year],
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
      monthEqualTo(int month) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'month',
        value: [month],
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
      yearMonthKeyEqualTo(int yearMonthKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'yearMonthKey',
        value: [yearMonthKey],
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterWhereClause>
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

extension PlaybackArtistStatsQueryFilter on QueryBuilder<PlaybackArtistStats,
    PlaybackArtistStats, QFilterCondition> {
  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistIdEqualTo(
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistIdLessThan(
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistIdBetween(
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistIdEndsWith(
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'artistId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'artistId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artistId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'artistId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artistJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'artistJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'artistJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'artistJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'artistJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'artistJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'artistJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'artistJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artistJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      artistJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'artistJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      monthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      playCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      secondsPlayedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secondsPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      yearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
      yearMonthKeyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yearMonthKey',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterFilterCondition>
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

extension PlaybackArtistStatsQueryObject on QueryBuilder<PlaybackArtistStats,
    PlaybackArtistStats, QFilterCondition> {}

extension PlaybackArtistStatsQueryLinks on QueryBuilder<PlaybackArtistStats,
    PlaybackArtistStats, QFilterCondition> {}

extension PlaybackArtistStatsQuerySortBy
    on QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QSortBy> {
  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      sortByArtistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.asc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      sortByArtistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.desc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      sortByArtistJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistJson', Sort.asc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      sortByArtistJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistJson', Sort.desc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      sortByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      sortByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      sortByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.asc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      sortByPlayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.desc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      sortBySecondsPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondsPlayed', Sort.asc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      sortBySecondsPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondsPlayed', Sort.desc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      sortByYearMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearMonthKey', Sort.asc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      sortByYearMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearMonthKey', Sort.desc);
    });
  }
}

extension PlaybackArtistStatsQuerySortThenBy
    on QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QSortThenBy> {
  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      thenByArtistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.asc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      thenByArtistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistId', Sort.desc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      thenByArtistJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistJson', Sort.asc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      thenByArtistJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artistJson', Sort.desc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      thenByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      thenByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      thenByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.asc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      thenByPlayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.desc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      thenBySecondsPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondsPlayed', Sort.asc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      thenBySecondsPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondsPlayed', Sort.desc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      thenByYearMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearMonthKey', Sort.asc);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QAfterSortBy>
      thenByYearMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearMonthKey', Sort.desc);
    });
  }
}

extension PlaybackArtistStatsQueryWhereDistinct
    on QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QDistinct> {
  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QDistinct>
      distinctByArtistId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'artistId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QDistinct>
      distinctByArtistJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'artistJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QDistinct>
      distinctByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'month');
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QDistinct>
      distinctByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playCount');
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QDistinct>
      distinctBySecondsPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'secondsPlayed');
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QDistinct>
      distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }

  QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QDistinct>
      distinctByYearMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yearMonthKey');
    });
  }
}

extension PlaybackArtistStatsQueryProperty
    on QueryBuilder<PlaybackArtistStats, PlaybackArtistStats, QQueryProperty> {
  QueryBuilder<PlaybackArtistStats, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlaybackArtistStats, String, QQueryOperations>
      artistIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'artistId');
    });
  }

  QueryBuilder<PlaybackArtistStats, String, QQueryOperations>
      artistJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'artistJson');
    });
  }

  QueryBuilder<PlaybackArtistStats, int, QQueryOperations> monthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'month');
    });
  }

  QueryBuilder<PlaybackArtistStats, int, QQueryOperations> playCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playCount');
    });
  }

  QueryBuilder<PlaybackArtistStats, int, QQueryOperations>
      secondsPlayedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'secondsPlayed');
    });
  }

  QueryBuilder<PlaybackArtistStats, int, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }

  QueryBuilder<PlaybackArtistStats, int, QQueryOperations>
      yearMonthKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yearMonthKey');
    });
  }
}
