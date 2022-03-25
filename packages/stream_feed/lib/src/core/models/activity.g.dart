// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map json) => Activity(
      actor: json['actor'] as String?,
      verb: json['verb'] as String?,
      object: json['object'] as String?,
      id: json['id'] as String?,
      foreignId: json['foreign_id'] as String?,
      target: json['target'] as String?,
      time: const DateTimeUTCConverter().fromJson(json['time'] as String?),
      to: FeedId.fromIds(json['to'] as List?),
      analytics: (json['analytics'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as Object),
      ),
      extraContext: (json['extra_context'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as Object),
      ),
      origin: json['origin'] as String?,
      score: (json['score'] as num?)?.toDouble(),
      extraData: (json['extra_data'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as Object),
      ),
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['actor'] = instance.actor;
  val['verb'] = instance.verb;
  val['object'] = instance.object;
  writeNotNull('foreign_id', instance.foreignId);
  writeNotNull('target', instance.target);
  writeNotNull('time', const DateTimeUTCConverter().toJson(instance.time));
  writeNotNull('origin', instance.origin);
  writeNotNull('to', FeedId.toIds(instance.to));
  writeNotNull('score', instance.score);
  writeNotNull('analytics', instance.analytics);
  writeNotNull('extra_context', instance.extraContext);
  writeNotNull('extra_data', instance.extraData);
  return val;
}
