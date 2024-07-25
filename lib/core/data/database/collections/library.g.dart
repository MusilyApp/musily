// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDatabaseLibraryCollection on Isar {
  IsarCollection<DatabaseLibrary> get databaseLibrarys => this.collection();
}

const DatabaseLibrarySchema = CollectionSchema(
  name: r'DatabaseLibrary',
  id: -5922894697627131488,
  properties: {
    r'musilyId': PropertySchema(
      id: 0,
      name: r'musilyId',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 1,
      name: r'type',
      type: IsarType.byte,
      enumMap: _DatabaseLibrarytypeEnumValueMap,
    ),
    r'value': PropertySchema(
      id: 2,
      name: r'value',
      type: IsarType.string,
    )
  },
  estimateSize: _databaseLibraryEstimateSize,
  serialize: _databaseLibrarySerialize,
  deserialize: _databaseLibraryDeserialize,
  deserializeProp: _databaseLibraryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _databaseLibraryGetId,
  getLinks: _databaseLibraryGetLinks,
  attach: _databaseLibraryAttach,
  version: '3.1.0+1',
);

int _databaseLibraryEstimateSize(
  DatabaseLibrary object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.musilyId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.value;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _databaseLibrarySerialize(
  DatabaseLibrary object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.musilyId);
  writer.writeByte(offsets[1], object.type.index);
  writer.writeString(offsets[2], object.value);
}

DatabaseLibrary _databaseLibraryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DatabaseLibrary();
  object.id = id;
  object.musilyId = reader.readStringOrNull(offsets[0]);
  object.type =
      _DatabaseLibrarytypeValueEnumMap[reader.readByteOrNull(offsets[1])] ??
          LibraryType.album;
  object.value = reader.readStringOrNull(offsets[2]);
  return object;
}

P _databaseLibraryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (_DatabaseLibrarytypeValueEnumMap[reader.readByteOrNull(offset)] ??
          LibraryType.album) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DatabaseLibrarytypeEnumValueMap = {
  'album': 0,
  'playlist': 1,
  'artist': 2,
};
const _DatabaseLibrarytypeValueEnumMap = {
  0: LibraryType.album,
  1: LibraryType.playlist,
  2: LibraryType.artist,
};

Id _databaseLibraryGetId(DatabaseLibrary object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _databaseLibraryGetLinks(DatabaseLibrary object) {
  return [];
}

void _databaseLibraryAttach(
    IsarCollection<dynamic> col, Id id, DatabaseLibrary object) {
  object.id = id;
}

extension DatabaseLibraryQueryWhereSort
    on QueryBuilder<DatabaseLibrary, DatabaseLibrary, QWhere> {
  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DatabaseLibraryQueryWhere
    on QueryBuilder<DatabaseLibrary, DatabaseLibrary, QWhereClause> {
  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterWhereClause>
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

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterWhereClause> idBetween(
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
}

extension DatabaseLibraryQueryFilter
    on QueryBuilder<DatabaseLibrary, DatabaseLibrary, QFilterCondition> {
  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
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

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      idLessThan(
    Id? value, {
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

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      musilyIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'musilyId',
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      musilyIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'musilyId',
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      musilyIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'musilyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      musilyIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'musilyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      musilyIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'musilyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      musilyIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'musilyId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      musilyIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'musilyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      musilyIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'musilyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      musilyIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'musilyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      musilyIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'musilyId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      musilyIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'musilyId',
        value: '',
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      musilyIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'musilyId',
        value: '',
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      typeEqualTo(LibraryType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      typeGreaterThan(
    LibraryType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      typeLessThan(
    LibraryType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      typeBetween(
    LibraryType lower,
    LibraryType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      valueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      valueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      valueEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      valueGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      valueLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      valueBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      valueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      valueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'value',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: '',
      ));
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterFilterCondition>
      valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'value',
        value: '',
      ));
    });
  }
}

extension DatabaseLibraryQueryObject
    on QueryBuilder<DatabaseLibrary, DatabaseLibrary, QFilterCondition> {}

extension DatabaseLibraryQueryLinks
    on QueryBuilder<DatabaseLibrary, DatabaseLibrary, QFilterCondition> {}

extension DatabaseLibraryQuerySortBy
    on QueryBuilder<DatabaseLibrary, DatabaseLibrary, QSortBy> {
  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterSortBy>
      sortByMusilyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'musilyId', Sort.asc);
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterSortBy>
      sortByMusilyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'musilyId', Sort.desc);
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterSortBy>
      sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension DatabaseLibraryQuerySortThenBy
    on QueryBuilder<DatabaseLibrary, DatabaseLibrary, QSortThenBy> {
  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterSortBy>
      thenByMusilyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'musilyId', Sort.asc);
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterSortBy>
      thenByMusilyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'musilyId', Sort.desc);
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QAfterSortBy>
      thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension DatabaseLibraryQueryWhereDistinct
    on QueryBuilder<DatabaseLibrary, DatabaseLibrary, QDistinct> {
  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QDistinct> distinctByMusilyId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'musilyId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<DatabaseLibrary, DatabaseLibrary, QDistinct> distinctByValue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value', caseSensitive: caseSensitive);
    });
  }
}

extension DatabaseLibraryQueryProperty
    on QueryBuilder<DatabaseLibrary, DatabaseLibrary, QQueryProperty> {
  QueryBuilder<DatabaseLibrary, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DatabaseLibrary, String?, QQueryOperations> musilyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'musilyId');
    });
  }

  QueryBuilder<DatabaseLibrary, LibraryType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<DatabaseLibrary, String?, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
