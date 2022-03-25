// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group<T> _$GroupFromJson<T>(
  Map json,
  T Function(Object? json) fromJsonT,
) =>
    Group<T>(
      id: json['id'] as String?,
      group: json['group'] as String?,
      activities:
          (json['activities'] as List<dynamic>?)?.map(fromJsonT).toList(),
      actorCount: json['actor_count'] as int?,
      createdAt:
          const DateTimeUTCConverter().fromJson(json['created_at'] as String?),
      updatedAt:
          const DateTimeUTCConverter().fromJson(json['updated_at'] as String?),
    );

Map<String, dynamic> _$GroupToJson<T>(
  Group<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'id': instance.id,
      'group': instance.group,
      'activities': instance.activities?.map(toJsonT).toList(),
      'actor_count': instance.actorCount,
      'created_at': const DateTimeUTCConverter().toJson(instance.createdAt),
      'updated_at': const DateTimeUTCConverter().toJson(instance.updatedAt),
    };

NotificationGroup<T> _$NotificationGroupFromJson<T>(
  Map json,
  T Function(Object? json) fromJsonT,
) =>
    NotificationGroup<T>(
      id: json['id'] as String?,
      group: json['group'] as String?,
      activities:
          (json['activities'] as List<dynamic>?)?.map(fromJsonT).toList(),
      actorCount: json['actor_count'] as int?,
      createdAt:
          const DateTimeUTCConverter().fromJson(json['created_at'] as String?),
      updatedAt:
          const DateTimeUTCConverter().fromJson(json['updated_at'] as String?),
      isRead: json['is_read'] as bool?,
      isSeen: json['is_seen'] as bool?,
    );

Map<String, dynamic> _$NotificationGroupToJson<T>(
  NotificationGroup<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'id': instance.id,
      'group': instance.group,
      'activities': instance.activities?.map(toJsonT).toList(),
      'actor_count': instance.actorCount,
      'created_at': const DateTimeUTCConverter().toJson(instance.createdAt),
      'updated_at': const DateTimeUTCConverter().toJson(instance.updatedAt),
      'is_read': instance.isRead,
      'is_seen': instance.isSeen,
    };
