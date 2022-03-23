// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionEntry _$CollectionEntryFromJson(Map json) => CollectionEntry(
      id: json['id'] as String?,
      collection: json['collection'] as String?,
      foreignId: json['foreign_id'] as String?,
      data: (json['data'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as Object),
      ),
      createdAt:
          const DateTimeUTCConverter().fromJson(json['created_at'] as String?),
      updatedAt:
          const DateTimeUTCConverter().fromJson(json['updated_at'] as String?),
    );

Map<String, dynamic> _$CollectionEntryToJson(CollectionEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collection': instance.collection,
      'foreign_id': instance.foreignId,
      'data': instance.data,
      'created_at': const DateTimeUTCConverter().toJson(instance.createdAt),
      'updated_at': const DateTimeUTCConverter().toJson(instance.updatedAt),
    };
