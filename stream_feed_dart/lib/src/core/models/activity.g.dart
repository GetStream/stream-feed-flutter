// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map json) {
  return Activity(
    actor: json['actor'] as String,
    verb: json['verb'] as String,
    object: json['object'] as String,
    id: json['id'] as String,
    foreignId: json['foreign_id'] as String,
    target: json['target'] as String,
    time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
    to: (json['to'] as List)?.map((e) => e as String)?.toList(),
    analytics: (json['analytics'] as Map)?.map(
      (k, e) => MapEntry(k as String, e),
    ),
    extraContext: (json['extra_context'] as Map)?.map(
      (k, e) => MapEntry(k as String, e),
    ),
    origin: json['origin'] as String,
    score: (json['score'] as num)?.toDouble(),
    extraData: (json['extra_data'] as Map)?.map(
      (k, e) => MapEntry(k as String, e),
    ),
  );
}

Map<String, dynamic> _$ActivityToJson(Activity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', readonly(instance.id));
  val['actor'] = instance.actor;
  val['verb'] = instance.verb;
  val['object'] = instance.object;
  writeNotNull('foreign_id', instance.foreignId);
  writeNotNull('target', readonly(instance.target));
  writeNotNull('time', instance.time?.toIso8601String());
  writeNotNull('origin', readonly(instance.origin));
  writeNotNull('to', readonly(instance.to));
  writeNotNull('score', readonly(instance.score));
  writeNotNull('analytics', readonly(instance.analytics));
  writeNotNull('extra_context', readonly(instance.extraContext));
  writeNotNull('extra_data', instance.extraData);
  return val;
}
