// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrapped.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWrappedCollection on Isar {
  IsarCollection<Wrapped> get wrappeds => this.collection();
}

const WrappedSchema = CollectionSchema(
  name: r'Wrapped',
  id: 5361126310026796004,
  properties: {
    r'generatedAt': PropertySchema(
      id: 0,
      name: r'generatedAt',
      type: IsarType.dateTime,
    ),
    r'mostPlayedAlbumJson': PropertySchema(
      id: 1,
      name: r'mostPlayedAlbumJson',
      type: IsarType.string,
    ),
    r'mostPlayedAlbumMinutes': PropertySchema(
      id: 2,
      name: r'mostPlayedAlbumMinutes',
      type: IsarType.long,
    ),
    r'mostPlayedAlbumPlays': PropertySchema(
      id: 3,
      name: r'mostPlayedAlbumPlays',
      type: IsarType.long,
    ),
    r'mostPlayedArtistJson': PropertySchema(
      id: 4,
      name: r'mostPlayedArtistJson',
      type: IsarType.string,
    ),
    r'mostPlayedArtistMinutes': PropertySchema(
      id: 5,
      name: r'mostPlayedArtistMinutes',
      type: IsarType.long,
    ),
    r'mostPlayedArtistPlays': PropertySchema(
      id: 6,
      name: r'mostPlayedArtistPlays',
      type: IsarType.long,
    ),
    r'mostPlayedTrackJson': PropertySchema(
      id: 7,
      name: r'mostPlayedTrackJson',
      type: IsarType.string,
    ),
    r'mostPlayedTrackMinutes': PropertySchema(
      id: 8,
      name: r'mostPlayedTrackMinutes',
      type: IsarType.long,
    ),
    r'mostPlayedTrackPlays': PropertySchema(
      id: 9,
      name: r'mostPlayedTrackPlays',
      type: IsarType.long,
    ),
    r'periodEnd': PropertySchema(
      id: 10,
      name: r'periodEnd',
      type: IsarType.dateTime,
    ),
    r'periodStart': PropertySchema(
      id: 11,
      name: r'periodStart',
      type: IsarType.dateTime,
    ),
    r'seed': PropertySchema(
      id: 12,
      name: r'seed',
      type: IsarType.string,
    ),
    r'topAlbumsJson': PropertySchema(
      id: 13,
      name: r'topAlbumsJson',
      type: IsarType.string,
    ),
    r'topArtistsJson': PropertySchema(
      id: 14,
      name: r'topArtistsJson',
      type: IsarType.string,
    ),
    r'topTracksJson': PropertySchema(
      id: 15,
      name: r'topTracksJson',
      type: IsarType.string,
    ),
    r'totalAlbumsPlayed': PropertySchema(
      id: 16,
      name: r'totalAlbumsPlayed',
      type: IsarType.long,
    ),
    r'totalArtistsPlayed': PropertySchema(
      id: 17,
      name: r'totalArtistsPlayed',
      type: IsarType.long,
    ),
    r'totalMinutes': PropertySchema(
      id: 18,
      name: r'totalMinutes',
      type: IsarType.long,
    ),
    r'totalTracksPlayed': PropertySchema(
      id: 19,
      name: r'totalTracksPlayed',
      type: IsarType.long,
    ),
    r'year': PropertySchema(
      id: 20,
      name: r'year',
      type: IsarType.long,
    )
  },
  estimateSize: _wrappedEstimateSize,
  serialize: _wrappedSerialize,
  deserialize: _wrappedDeserialize,
  deserializeProp: _wrappedDeserializeProp,
  idName: r'id',
  indexes: {
    r'periodStart': IndexSchema(
      id: -7133903706047263368,
      name: r'periodStart',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'periodStart',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'periodEnd': IndexSchema(
      id: -748264925685152938,
      name: r'periodEnd',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'periodEnd',
          type: IndexType.value,
          caseSensitive: false,
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _wrappedGetId,
  getLinks: _wrappedGetLinks,
  attach: _wrappedAttach,
  version: '3.1.0+1',
);

int _wrappedEstimateSize(
  Wrapped object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.mostPlayedAlbumJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.mostPlayedArtistJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.mostPlayedTrackJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.seed.length * 3;
  bytesCount += 3 + object.topAlbumsJson.length * 3;
  bytesCount += 3 + object.topArtistsJson.length * 3;
  bytesCount += 3 + object.topTracksJson.length * 3;
  return bytesCount;
}

void _wrappedSerialize(
  Wrapped object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.generatedAt);
  writer.writeString(offsets[1], object.mostPlayedAlbumJson);
  writer.writeLong(offsets[2], object.mostPlayedAlbumMinutes);
  writer.writeLong(offsets[3], object.mostPlayedAlbumPlays);
  writer.writeString(offsets[4], object.mostPlayedArtistJson);
  writer.writeLong(offsets[5], object.mostPlayedArtistMinutes);
  writer.writeLong(offsets[6], object.mostPlayedArtistPlays);
  writer.writeString(offsets[7], object.mostPlayedTrackJson);
  writer.writeLong(offsets[8], object.mostPlayedTrackMinutes);
  writer.writeLong(offsets[9], object.mostPlayedTrackPlays);
  writer.writeDateTime(offsets[10], object.periodEnd);
  writer.writeDateTime(offsets[11], object.periodStart);
  writer.writeString(offsets[12], object.seed);
  writer.writeString(offsets[13], object.topAlbumsJson);
  writer.writeString(offsets[14], object.topArtistsJson);
  writer.writeString(offsets[15], object.topTracksJson);
  writer.writeLong(offsets[16], object.totalAlbumsPlayed);
  writer.writeLong(offsets[17], object.totalArtistsPlayed);
  writer.writeLong(offsets[18], object.totalMinutes);
  writer.writeLong(offsets[19], object.totalTracksPlayed);
  writer.writeLong(offsets[20], object.year);
}

Wrapped _wrappedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Wrapped();
  object.generatedAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.mostPlayedAlbumJson = reader.readStringOrNull(offsets[1]);
  object.mostPlayedAlbumMinutes = reader.readLongOrNull(offsets[2]);
  object.mostPlayedAlbumPlays = reader.readLongOrNull(offsets[3]);
  object.mostPlayedArtistJson = reader.readStringOrNull(offsets[4]);
  object.mostPlayedArtistMinutes = reader.readLongOrNull(offsets[5]);
  object.mostPlayedArtistPlays = reader.readLongOrNull(offsets[6]);
  object.mostPlayedTrackJson = reader.readStringOrNull(offsets[7]);
  object.mostPlayedTrackMinutes = reader.readLongOrNull(offsets[8]);
  object.mostPlayedTrackPlays = reader.readLongOrNull(offsets[9]);
  object.periodEnd = reader.readDateTime(offsets[10]);
  object.periodStart = reader.readDateTime(offsets[11]);
  object.seed = reader.readString(offsets[12]);
  object.topAlbumsJson = reader.readString(offsets[13]);
  object.topArtistsJson = reader.readString(offsets[14]);
  object.topTracksJson = reader.readString(offsets[15]);
  object.totalAlbumsPlayed = reader.readLong(offsets[16]);
  object.totalArtistsPlayed = reader.readLong(offsets[17]);
  object.totalMinutes = reader.readLong(offsets[18]);
  object.totalTracksPlayed = reader.readLong(offsets[19]);
  object.year = reader.readLong(offsets[20]);
  return object;
}

P _wrappedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    case 18:
      return (reader.readLong(offset)) as P;
    case 19:
      return (reader.readLong(offset)) as P;
    case 20:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _wrappedGetId(Wrapped object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _wrappedGetLinks(Wrapped object) {
  return [];
}

void _wrappedAttach(IsarCollection<dynamic> col, Id id, Wrapped object) {
  object.id = id;
}

extension WrappedQueryWhereSort on QueryBuilder<Wrapped, Wrapped, QWhere> {
  QueryBuilder<Wrapped, Wrapped, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhere> anyPeriodStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'periodStart'),
      );
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhere> anyPeriodEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'periodEnd'),
      );
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhere> anyYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'year'),
      );
    });
  }
}

extension WrappedQueryWhere on QueryBuilder<Wrapped, Wrapped, QWhereClause> {
  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> idBetween(
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

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> periodStartEqualTo(
      DateTime periodStart) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'periodStart',
        value: [periodStart],
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> periodStartNotEqualTo(
      DateTime periodStart) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'periodStart',
              lower: [],
              upper: [periodStart],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'periodStart',
              lower: [periodStart],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'periodStart',
              lower: [periodStart],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'periodStart',
              lower: [],
              upper: [periodStart],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> periodStartGreaterThan(
    DateTime periodStart, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'periodStart',
        lower: [periodStart],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> periodStartLessThan(
    DateTime periodStart, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'periodStart',
        lower: [],
        upper: [periodStart],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> periodStartBetween(
    DateTime lowerPeriodStart,
    DateTime upperPeriodStart, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'periodStart',
        lower: [lowerPeriodStart],
        includeLower: includeLower,
        upper: [upperPeriodStart],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> periodEndEqualTo(
      DateTime periodEnd) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'periodEnd',
        value: [periodEnd],
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> periodEndNotEqualTo(
      DateTime periodEnd) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'periodEnd',
              lower: [],
              upper: [periodEnd],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'periodEnd',
              lower: [periodEnd],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'periodEnd',
              lower: [periodEnd],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'periodEnd',
              lower: [],
              upper: [periodEnd],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> periodEndGreaterThan(
    DateTime periodEnd, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'periodEnd',
        lower: [periodEnd],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> periodEndLessThan(
    DateTime periodEnd, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'periodEnd',
        lower: [],
        upper: [periodEnd],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> periodEndBetween(
    DateTime lowerPeriodEnd,
    DateTime upperPeriodEnd, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'periodEnd',
        lower: [lowerPeriodEnd],
        includeLower: includeLower,
        upper: [upperPeriodEnd],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> yearEqualTo(int year) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'year',
        value: [year],
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> yearNotEqualTo(int year) {
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

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> yearGreaterThan(
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

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> yearLessThan(
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

  QueryBuilder<Wrapped, Wrapped, QAfterWhereClause> yearBetween(
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
}

extension WrappedQueryFilter
    on QueryBuilder<Wrapped, Wrapped, QFilterCondition> {
  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> generatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> generatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> generatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> generatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'generatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mostPlayedAlbumJson',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mostPlayedAlbumJson',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostPlayedAlbumJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mostPlayedAlbumJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mostPlayedAlbumJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mostPlayedAlbumJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mostPlayedAlbumJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mostPlayedAlbumJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mostPlayedAlbumJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mostPlayedAlbumJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostPlayedAlbumJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mostPlayedAlbumJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mostPlayedAlbumMinutes',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mostPlayedAlbumMinutes',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostPlayedAlbumMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumMinutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mostPlayedAlbumMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumMinutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mostPlayedAlbumMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mostPlayedAlbumMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumPlaysIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mostPlayedAlbumPlays',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumPlaysIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mostPlayedAlbumPlays',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumPlaysEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostPlayedAlbumPlays',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumPlaysGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mostPlayedAlbumPlays',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumPlaysLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mostPlayedAlbumPlays',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedAlbumPlaysBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mostPlayedAlbumPlays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mostPlayedArtistJson',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mostPlayedArtistJson',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostPlayedArtistJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mostPlayedArtistJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mostPlayedArtistJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mostPlayedArtistJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mostPlayedArtistJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mostPlayedArtistJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mostPlayedArtistJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mostPlayedArtistJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostPlayedArtistJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mostPlayedArtistJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mostPlayedArtistMinutes',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mostPlayedArtistMinutes',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostPlayedArtistMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistMinutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mostPlayedArtistMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistMinutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mostPlayedArtistMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mostPlayedArtistMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistPlaysIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mostPlayedArtistPlays',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistPlaysIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mostPlayedArtistPlays',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistPlaysEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostPlayedArtistPlays',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistPlaysGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mostPlayedArtistPlays',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistPlaysLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mostPlayedArtistPlays',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedArtistPlaysBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mostPlayedArtistPlays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mostPlayedTrackJson',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mostPlayedTrackJson',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostPlayedTrackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mostPlayedTrackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mostPlayedTrackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mostPlayedTrackJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mostPlayedTrackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mostPlayedTrackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mostPlayedTrackJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mostPlayedTrackJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostPlayedTrackJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mostPlayedTrackJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mostPlayedTrackMinutes',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mostPlayedTrackMinutes',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostPlayedTrackMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackMinutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mostPlayedTrackMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackMinutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mostPlayedTrackMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mostPlayedTrackMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackPlaysIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mostPlayedTrackPlays',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackPlaysIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mostPlayedTrackPlays',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackPlaysEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostPlayedTrackPlays',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackPlaysGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mostPlayedTrackPlays',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackPlaysLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mostPlayedTrackPlays',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      mostPlayedTrackPlaysBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mostPlayedTrackPlays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> periodEndEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'periodEnd',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> periodEndGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'periodEnd',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> periodEndLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'periodEnd',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> periodEndBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'periodEnd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> periodStartEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'periodStart',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> periodStartGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'periodStart',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> periodStartLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'periodStart',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> periodStartBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'periodStart',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> seedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> seedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> seedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> seedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> seedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'seed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> seedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'seed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> seedContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'seed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> seedMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'seed',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> seedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seed',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> seedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'seed',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topAlbumsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topAlbumsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      topAlbumsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'topAlbumsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topAlbumsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'topAlbumsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topAlbumsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'topAlbumsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topAlbumsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'topAlbumsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topAlbumsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'topAlbumsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topAlbumsJsonContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'topAlbumsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topAlbumsJsonMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'topAlbumsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topAlbumsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topAlbumsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      topAlbumsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'topAlbumsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topArtistsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topArtistsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      topArtistsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'topArtistsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topArtistsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'topArtistsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topArtistsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'topArtistsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      topArtistsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'topArtistsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topArtistsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'topArtistsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topArtistsJsonContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'topArtistsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topArtistsJsonMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'topArtistsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      topArtistsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topArtistsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      topArtistsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'topArtistsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topTracksJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topTracksJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      topTracksJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'topTracksJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topTracksJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'topTracksJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topTracksJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'topTracksJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topTracksJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'topTracksJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topTracksJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'topTracksJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topTracksJsonContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'topTracksJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topTracksJsonMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'topTracksJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> topTracksJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topTracksJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      topTracksJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'topTracksJson',
        value: '',
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      totalAlbumsPlayedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalAlbumsPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      totalAlbumsPlayedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalAlbumsPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      totalAlbumsPlayedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalAlbumsPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      totalAlbumsPlayedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalAlbumsPlayed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      totalArtistsPlayedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalArtistsPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      totalArtistsPlayedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalArtistsPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      totalArtistsPlayedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalArtistsPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      totalArtistsPlayedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalArtistsPlayed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> totalMinutesEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> totalMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> totalMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> totalMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      totalTracksPlayedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalTracksPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      totalTracksPlayedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalTracksPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      totalTracksPlayedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalTracksPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition>
      totalTracksPlayedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalTracksPlayed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> yearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> yearGreaterThan(
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

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> yearLessThan(
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

  QueryBuilder<Wrapped, Wrapped, QAfterFilterCondition> yearBetween(
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
}

extension WrappedQueryObject
    on QueryBuilder<Wrapped, Wrapped, QFilterCondition> {}

extension WrappedQueryLinks
    on QueryBuilder<Wrapped, Wrapped, QFilterCondition> {}

extension WrappedQuerySortBy on QueryBuilder<Wrapped, Wrapped, QSortBy> {
  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByMostPlayedAlbumJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedAlbumJson', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByMostPlayedAlbumJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedAlbumJson', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByMostPlayedAlbumMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedAlbumMinutes', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy>
      sortByMostPlayedAlbumMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedAlbumMinutes', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByMostPlayedAlbumPlays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedAlbumPlays', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy>
      sortByMostPlayedAlbumPlaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedAlbumPlays', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByMostPlayedArtistJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedArtistJson', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy>
      sortByMostPlayedArtistJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedArtistJson', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByMostPlayedArtistMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedArtistMinutes', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy>
      sortByMostPlayedArtistMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedArtistMinutes', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByMostPlayedArtistPlays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedArtistPlays', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy>
      sortByMostPlayedArtistPlaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedArtistPlays', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByMostPlayedTrackJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedTrackJson', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByMostPlayedTrackJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedTrackJson', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByMostPlayedTrackMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedTrackMinutes', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy>
      sortByMostPlayedTrackMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedTrackMinutes', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByMostPlayedTrackPlays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedTrackPlays', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy>
      sortByMostPlayedTrackPlaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedTrackPlays', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByPeriodEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodEnd', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByPeriodEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodEnd', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByPeriodStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodStart', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByPeriodStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodStart', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortBySeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seed', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortBySeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seed', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByTopAlbumsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topAlbumsJson', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByTopAlbumsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topAlbumsJson', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByTopArtistsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topArtistsJson', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByTopArtistsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topArtistsJson', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByTopTracksJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topTracksJson', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByTopTracksJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topTracksJson', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByTotalAlbumsPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAlbumsPlayed', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByTotalAlbumsPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAlbumsPlayed', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByTotalArtistsPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalArtistsPlayed', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByTotalArtistsPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalArtistsPlayed', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByTotalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMinutes', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByTotalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMinutes', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByTotalTracksPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTracksPlayed', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByTotalTracksPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTracksPlayed', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension WrappedQuerySortThenBy
    on QueryBuilder<Wrapped, Wrapped, QSortThenBy> {
  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByMostPlayedAlbumJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedAlbumJson', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByMostPlayedAlbumJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedAlbumJson', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByMostPlayedAlbumMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedAlbumMinutes', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy>
      thenByMostPlayedAlbumMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedAlbumMinutes', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByMostPlayedAlbumPlays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedAlbumPlays', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy>
      thenByMostPlayedAlbumPlaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedAlbumPlays', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByMostPlayedArtistJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedArtistJson', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy>
      thenByMostPlayedArtistJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedArtistJson', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByMostPlayedArtistMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedArtistMinutes', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy>
      thenByMostPlayedArtistMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedArtistMinutes', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByMostPlayedArtistPlays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedArtistPlays', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy>
      thenByMostPlayedArtistPlaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedArtistPlays', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByMostPlayedTrackJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedTrackJson', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByMostPlayedTrackJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedTrackJson', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByMostPlayedTrackMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedTrackMinutes', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy>
      thenByMostPlayedTrackMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedTrackMinutes', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByMostPlayedTrackPlays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedTrackPlays', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy>
      thenByMostPlayedTrackPlaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPlayedTrackPlays', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByPeriodEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodEnd', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByPeriodEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodEnd', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByPeriodStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodStart', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByPeriodStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodStart', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenBySeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seed', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenBySeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seed', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByTopAlbumsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topAlbumsJson', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByTopAlbumsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topAlbumsJson', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByTopArtistsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topArtistsJson', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByTopArtistsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topArtistsJson', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByTopTracksJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topTracksJson', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByTopTracksJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topTracksJson', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByTotalAlbumsPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAlbumsPlayed', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByTotalAlbumsPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAlbumsPlayed', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByTotalArtistsPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalArtistsPlayed', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByTotalArtistsPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalArtistsPlayed', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByTotalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMinutes', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByTotalMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMinutes', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByTotalTracksPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTracksPlayed', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByTotalTracksPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTracksPlayed', Sort.desc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QAfterSortBy> thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension WrappedQueryWhereDistinct
    on QueryBuilder<Wrapped, Wrapped, QDistinct> {
  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAt');
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByMostPlayedAlbumJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mostPlayedAlbumJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByMostPlayedAlbumMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mostPlayedAlbumMinutes');
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByMostPlayedAlbumPlays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mostPlayedAlbumPlays');
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByMostPlayedArtistJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mostPlayedArtistJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct>
      distinctByMostPlayedArtistMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mostPlayedArtistMinutes');
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByMostPlayedArtistPlays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mostPlayedArtistPlays');
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByMostPlayedTrackJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mostPlayedTrackJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByMostPlayedTrackMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mostPlayedTrackMinutes');
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByMostPlayedTrackPlays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mostPlayedTrackPlays');
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByPeriodEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'periodEnd');
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByPeriodStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'periodStart');
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctBySeed(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seed', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByTopAlbumsJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topAlbumsJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByTopArtistsJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topArtistsJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByTopTracksJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topTracksJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByTotalAlbumsPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAlbumsPlayed');
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByTotalArtistsPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalArtistsPlayed');
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByTotalMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalMinutes');
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByTotalTracksPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalTracksPlayed');
    });
  }

  QueryBuilder<Wrapped, Wrapped, QDistinct> distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }
}

extension WrappedQueryProperty
    on QueryBuilder<Wrapped, Wrapped, QQueryProperty> {
  QueryBuilder<Wrapped, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Wrapped, DateTime, QQueryOperations> generatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAt');
    });
  }

  QueryBuilder<Wrapped, String?, QQueryOperations>
      mostPlayedAlbumJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mostPlayedAlbumJson');
    });
  }

  QueryBuilder<Wrapped, int?, QQueryOperations>
      mostPlayedAlbumMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mostPlayedAlbumMinutes');
    });
  }

  QueryBuilder<Wrapped, int?, QQueryOperations> mostPlayedAlbumPlaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mostPlayedAlbumPlays');
    });
  }

  QueryBuilder<Wrapped, String?, QQueryOperations>
      mostPlayedArtistJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mostPlayedArtistJson');
    });
  }

  QueryBuilder<Wrapped, int?, QQueryOperations>
      mostPlayedArtistMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mostPlayedArtistMinutes');
    });
  }

  QueryBuilder<Wrapped, int?, QQueryOperations>
      mostPlayedArtistPlaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mostPlayedArtistPlays');
    });
  }

  QueryBuilder<Wrapped, String?, QQueryOperations>
      mostPlayedTrackJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mostPlayedTrackJson');
    });
  }

  QueryBuilder<Wrapped, int?, QQueryOperations>
      mostPlayedTrackMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mostPlayedTrackMinutes');
    });
  }

  QueryBuilder<Wrapped, int?, QQueryOperations> mostPlayedTrackPlaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mostPlayedTrackPlays');
    });
  }

  QueryBuilder<Wrapped, DateTime, QQueryOperations> periodEndProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'periodEnd');
    });
  }

  QueryBuilder<Wrapped, DateTime, QQueryOperations> periodStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'periodStart');
    });
  }

  QueryBuilder<Wrapped, String, QQueryOperations> seedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seed');
    });
  }

  QueryBuilder<Wrapped, String, QQueryOperations> topAlbumsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topAlbumsJson');
    });
  }

  QueryBuilder<Wrapped, String, QQueryOperations> topArtistsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topArtistsJson');
    });
  }

  QueryBuilder<Wrapped, String, QQueryOperations> topTracksJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topTracksJson');
    });
  }

  QueryBuilder<Wrapped, int, QQueryOperations> totalAlbumsPlayedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAlbumsPlayed');
    });
  }

  QueryBuilder<Wrapped, int, QQueryOperations> totalArtistsPlayedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalArtistsPlayed');
    });
  }

  QueryBuilder<Wrapped, int, QQueryOperations> totalMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalMinutes');
    });
  }

  QueryBuilder<Wrapped, int, QQueryOperations> totalTracksPlayedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalTracksPlayed');
    });
  }

  QueryBuilder<Wrapped, int, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }
}
