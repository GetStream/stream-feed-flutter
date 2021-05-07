// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realtime_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RealtimeMessage _$RealtimeMessageFromJson(Map json) {
  return RealtimeMessage(
    feed: FeedId.fromId(json['feed'] as String?),
    deleted:
        (json['deleted'] as List<dynamic>).map((e) => e as String).toList(),
    deletedForeignIds:
        ForeignIdTimePair.fromList(json['deleted_foreign_ids'] as List?),
    newActivities: (json['new'] as List<dynamic>)
        .map((e) => Activity.fromJson((e as Map?)?.map(
              (k, e) => MapEntry(k as String, e),
            )))
        .toList(),
    appId: json['app_id'] as String?,
    publishedAt: json['published_at'] == null
        ? null
        : DateTime.parse(json['published_at'] as String),
  );
}

Map<String, dynamic> _$RealtimeMessageToJson(RealtimeMessage instance) {
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
  val['new'] = instance.newActivities.map((e) => e.toJson()).toList();
  writeNotNull('published_at', instance.publishedAt?.toIso8601String());
  return val;
}
