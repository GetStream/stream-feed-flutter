// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionEntry _$CollectionEntryFromJson(Map json) {
  return CollectionEntry(
    id: json['id'] as String,
    collection: json['collection'] as String,
    foreignId: json['foreign_id'] as String,
    data: (json['data'] as Map)?.map(
      (k, e) => MapEntry(k as String, e),
    ),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$CollectionEntryToJson(CollectionEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collection': instance.collection,
      'foreign_id': instance.foreignId,
      'data': instance.data,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
