// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group<T> _$GroupFromJson<T>(
  Map json,
  T Function(Object? json) fromJsonT,
) {
  return Group<T>(
    id: json['id'] as String?,
    group: json['group'] as String?,
    activities: (json['activities'] as List<dynamic>?)?.map(fromJsonT).toList(),
    actorCount: json['actor_count'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$GroupToJson<T>(
  Group<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'id': instance.id,
      'group': instance.group,
      'activities': instance.activities?.map(toJsonT).toList(),
      'actor_count': instance.actorCount,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

NotificationGroup<T> _$NotificationGroupFromJson<T>(
  Map json,
  T Function(Object? json) fromJsonT,
) {
  return NotificationGroup<T>(
    id: json['id'] as String?,
    group: json['group'] as String?,
    activities: (json['activities'] as List<dynamic>?)?.map(fromJsonT).toList(),
    actorCount: json['actor_count'] as int?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    isRead: json['is_read'] as bool?,
    isSeen: json['is_seen'] as bool?,
    unread: json['unread'] as int?,
    unseen: json['unseen'] as int?,
  );
}

Map<String, dynamic> _$NotificationGroupToJson<T>(
  NotificationGroup<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'id': instance.id,
      'group': instance.group,
      'activities': instance.activities?.map(toJsonT).toList(),
      'actor_count': instance.actorCount,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'is_read': instance.isRead,
      'is_seen': instance.isSeen,
      'unread': instance.unread,
      'unseen': instance.unseen,
    };
