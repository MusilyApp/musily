// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_track_stats.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlaybackTrackStatsCollection on Isar {
  IsarCollection<PlaybackTrackStats> get playbackTrackStats =>
      this.collection();
}

const PlaybackTrackStatsSchema = CollectionSchema(
  name: r'PlaybackTrackStats',
  id: 6931984640458806776,
  properties: {
    r'month': PropertySchema(
      id: 0,
      name: r'month',
      type: IsarType.long,
    ),
    r'playCount': PropertySchema(
      id: 1,
      name: r'playCount',
      type: IsarType.long,
    ),
    r'secondsPlayed': PropertySchema(
      id: 2,
      name: r'secondsPlayed',
      type: IsarType.long,
    ),
    r'trackId': PropertySchema(
      id: 3,
      name: r'trackId',
      type: IsarType.string,
    ),
    r'trackJson': PropertySchema(
      id: 4,
      name: r'trackJson',
      type: IsarType.string,
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
  estimateSize: _playbackTrackStatsEstimateSize,
  serialize: _playbackTrackStatsSerialize,
  deserialize: _playbackTrackStatsDeserialize,
  deserializeProp: _playbackTrackStatsDeserializeProp,
  idName: r'id',
  indexes: {
    r'trackId': IndexSchema(
      id: -8614467705999066844,
      name: r'trackId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'trackId',
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
  getId: _playbackTrackStatsGetId,
  getLinks: _playbackTrackStatsGetLinks,
  attach: _playbackTrackStatsAttach,
  version: '3.1.0+1',
);

int _playbackTrackStatsEstimateSize(
  PlaybackTrackStats object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.trackId.length * 3;
  bytesCount += 3 + object.trackJson.length * 3;
  return bytesCount;
}

void _playbackTrackStatsSerialize(
  PlaybackTrackStats object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.month);
  writer.writeLong(offsets[1], object.playCount);
  writer.writeLong(offsets[2], object.secondsPlayed);
  writer.writeString(offsets[3], object.trackId);
  writer.writeString(offsets[4], object.trackJson);
  writer.writeLong(offsets[5], object.year);
  writer.writeLong(offsets[6], object.yearMonthKey);
}

PlaybackTrackStats _playbackTrackStatsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlaybackTrackStats();
  object.id = id;
  object.month = reader.readLong(offsets[0]);
  object.playCount = reader.readLong(offsets[1]);
  object.secondsPlayed = reader.readLong(offsets[2]);
  object.trackId = reader.readString(offsets[3]);
  object.trackJson = reader.readString(offsets[4]);
  object.year = reader.readLong(offsets[5]);
  object.yearMonthKey = reader.readLong(offsets[6]);
  return object;
}

P _playbackTrackStatsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _playbackTrackStatsGetId(PlaybackTrackStats object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playbackTrackStatsGetLinks(
    PlaybackTrackStats object) {
  return [];
}

void _playbackTrackStatsAttach(
    IsarCollection<dynamic> col, Id id, PlaybackTrackStats object) {
  object.id = id;
}

extension PlaybackTrackStatsQueryWhereSort
    on QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QWhere> {
  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhere> anyYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'year'),
      );
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhere> anyMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'month'),
      );
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhere>
      anyYearMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'yearMonthKey'),
      );
    });
  }
}

extension PlaybackTrackStatsQueryWhere
    on QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QWhereClause> {
  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
      trackIdEqualTo(String trackId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'trackId',
        value: [trackId],
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
      trackIdNotEqualTo(String trackId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'trackId',
              lower: [],
              upper: [trackId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'trackId',
              lower: [trackId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'trackId',
              lower: [trackId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'trackId',
              lower: [],
              upper: [trackId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
      yearEqualTo(int year) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'year',
        value: [year],
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
      monthEqualTo(int month) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'month',
        value: [month],
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
      yearMonthKeyEqualTo(int yearMonthKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'yearMonthKey',
        value: [yearMonthKey],
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterWhereClause>
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

extension PlaybackTrackStatsQueryFilter
    on QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QFilterCondition> {
  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      monthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      playCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      secondsPlayedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secondsPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackIdEqualTo(
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackIdLessThan(
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackIdBetween(
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackIdStartsWith(
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackIdEndsWith(
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'trackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'trackId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'trackId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trackJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'trackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'trackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'trackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'trackJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      trackJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'trackJson',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      yearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
      yearMonthKeyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yearMonthKey',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterFilterCondition>
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

extension PlaybackTrackStatsQueryObject
    on QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QFilterCondition> {}

extension PlaybackTrackStatsQueryLinks
    on QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QFilterCondition> {}

extension PlaybackTrackStatsQuerySortBy
    on QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QSortBy> {
  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      sortByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      sortByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      sortByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.asc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      sortByPlayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.desc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      sortBySecondsPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondsPlayed', Sort.asc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      sortBySecondsPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondsPlayed', Sort.desc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      sortByTrackId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.asc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      sortByTrackIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.desc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      sortByTrackJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackJson', Sort.asc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      sortByTrackJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackJson', Sort.desc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      sortByYearMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearMonthKey', Sort.asc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      sortByYearMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearMonthKey', Sort.desc);
    });
  }
}

extension PlaybackTrackStatsQuerySortThenBy
    on QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QSortThenBy> {
  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      thenByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      thenByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      thenByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.asc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      thenByPlayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.desc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      thenBySecondsPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondsPlayed', Sort.asc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      thenBySecondsPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondsPlayed', Sort.desc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      thenByTrackId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.asc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      thenByTrackIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.desc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      thenByTrackJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackJson', Sort.asc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      thenByTrackJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackJson', Sort.desc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      thenByYearMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearMonthKey', Sort.asc);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QAfterSortBy>
      thenByYearMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearMonthKey', Sort.desc);
    });
  }
}

extension PlaybackTrackStatsQueryWhereDistinct
    on QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QDistinct> {
  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QDistinct>
      distinctByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'month');
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QDistinct>
      distinctByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playCount');
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QDistinct>
      distinctBySecondsPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'secondsPlayed');
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QDistinct>
      distinctByTrackId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trackId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QDistinct>
      distinctByTrackJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trackJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QDistinct>
      distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }

  QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QDistinct>
      distinctByYearMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yearMonthKey');
    });
  }
}

extension PlaybackTrackStatsQueryProperty
    on QueryBuilder<PlaybackTrackStats, PlaybackTrackStats, QQueryProperty> {
  QueryBuilder<PlaybackTrackStats, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlaybackTrackStats, int, QQueryOperations> monthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'month');
    });
  }

  QueryBuilder<PlaybackTrackStats, int, QQueryOperations> playCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playCount');
    });
  }

  QueryBuilder<PlaybackTrackStats, int, QQueryOperations>
      secondsPlayedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'secondsPlayed');
    });
  }

  QueryBuilder<PlaybackTrackStats, String, QQueryOperations> trackIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackId');
    });
  }

  QueryBuilder<PlaybackTrackStats, String, QQueryOperations>
      trackJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackJson');
    });
  }

  QueryBuilder<PlaybackTrackStats, int, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }

  QueryBuilder<PlaybackTrackStats, int, QQueryOperations>
      yearMonthKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yearMonthKey');
    });
  }
}
