// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realtime_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RealtimeMessage<A, Ob, T, Or> _$RealtimeMessageFromJson<A, Ob, T, Or>(
  Map json,
  A Function(Object? json) fromJsonA,
  Ob Function(Object? json) fromJsonOb,
  T Function(Object? json) fromJsonT,
  Or Function(Object? json) fromJsonOr,
) {
  return RealtimeMessage<A, Ob, T, Or>(
    feed: FeedId.fromId(json['feed'] as String?),
    deleted:
        (json['deleted'] as List<dynamic>).map((e) => e as String).toList(),
    deletedForeignIds:
        ForeignIdTimePair.fromList(json['deleted_foreign_ids'] as List?),
    newActivities: (json['new'] as List<dynamic>?)
        ?.map((e) => GenericEnrichedActivity.fromJson(
            (e as Map?)?.map(
              (k, e) => MapEntry(k as String, e),
            ),
            (value) => fromJsonA(value),
            (value) => fromJsonOb(value),
            (value) => fromJsonT(value),
            (value) => fromJsonOr(value)))
        .toList(),
    appId: json['app_id'] as String?,
    publishedAt: json['published_at'] == null
        ? null
        : DateTime.parse(json['published_at'] as String),
    markRead:
        json['mark_read'] == null ? null : MarkRead.fromJson(json['mark_read']),
    markSeen:
        json['mark_seen'] == null ? null : MarkSeen.fromJson(json['mark_seen']),
  );
}

Map<String, dynamic> _$RealtimeMessageToJson<A, Ob, T, Or>(
  RealtimeMessage<A, Ob, T, Or> instance,
  Object? Function(A value) toJsonA,
  Object? Function(Ob value) toJsonOb,
  Object? Function(T value) toJsonT,
  Object? Function(Or value) toJsonOr,
) {
  final val = <String, dynamic>{
    'mark_seen': instance.markSeen?.toJson(),
    'mark_read': instance.markRead?.toJson(),
    'feed': FeedId.toId(instance.feed),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('app_id', instance.appId);
  val['deleted'] = instance.deleted;
  val['deleted_foreign_ids'] =
      ForeignIdTimePair.toList(instance.deletedForeignIds);
  val['new'] = instance.newActivities
      ?.map((e) => e.toJson(
            (value) => toJsonA(value),
            (value) => toJsonOb(value),
            (value) => toJsonT(value),
            (value) => toJsonOr(value),
          ))
      .toList();
  writeNotNull('published_at', instance.publishedAt?.toIso8601String());
  return val;
}
