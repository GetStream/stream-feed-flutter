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
) =>
    RealtimeMessage<A, Ob, T, Or>(
      feed: FeedId.fromId(json['feed'] as String?),
      deleted: (json['deleted'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      deletedForeignIds: json['deleted_foreign_ids'] == null
          ? const <ForeignIdTimePair>[]
          : ForeignIdTimePair.fromList(json['deleted_foreign_ids'] as List?),
      newActivities: (json['new'] as List<dynamic>?)
          ?.map((e) => GenericEnrichedActivity<A, Ob, T, Or>.fromJson(
              (e as Map?)?.map(
                (k, e) => MapEntry(k as String, e),
              ),
              (value) => fromJsonA(value),
              (value) => fromJsonOb(value),
              (value) => fromJsonT(value),
              (value) => fromJsonOr(value)))
          .toList(),
      appId: json['app_id'] as String?,
      publishedAt: const DateTimeUTCConverter()
          .fromJson(json['published_at'] as String?),
    );

Map<String, dynamic> _$RealtimeMessageToJson<A, Ob, T, Or>(
  RealtimeMessage<A, Ob, T, Or> instance,
  Object? Function(A value) toJsonA,
  Object? Function(Ob value) toJsonOb,
  Object? Function(T value) toJsonT,
  Object? Function(Or value) toJsonOr,
) {
  final val = <String, dynamic>{
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
  writeNotNull('published_at',
      const DateTimeUTCConverter().toJson(instance.publishedAt));
  return val;
}
