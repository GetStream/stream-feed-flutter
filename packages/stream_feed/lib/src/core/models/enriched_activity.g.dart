// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enriched_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnrichedActivity _$EnrichedActivityFromJson(Map json) {
  return EnrichedActivity(
    id: json['id'] as String?,
    actor: EnrichableField.deserialize(json['actor']),
    verb: json['verb'] as String?,
    object: EnrichableField.deserialize(json['object']),
    foreignId: json['foreign_id'] as String?,
    target: EnrichableField.deserialize(json['target']),
    time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
    origin: EnrichableField.deserialize(json['origin']),
    to: (json['to'] as List<dynamic>?)?.map((e) => e as String).toList(),
    score: (json['score'] as num?)?.toDouble(),
    analytics: (json['analytics'] as Map?)?.map(
      (k, e) => MapEntry(k as String, e as Object),
    ),
    extraContext: (json['extra_context'] as Map?)?.map(
      (k, e) => MapEntry(k as String, e as Object),
    ),
    extraData: (json['extra_data'] as Map?)?.map(
      (k, e) => MapEntry(k as String, e as Object),
    ),
    reactionCounts: (json['reaction_counts'] as Map?)?.map(
      (k, e) => MapEntry(k as String, e as Object),
    ),
    ownReactions: (json['own_reactions'] as Map?)?.map(
      (k, e) => MapEntry(
          k as String,
          (e as List<dynamic>)
              .map(
                  (e) => Reaction.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()),
    ),
    latestReactions: (json['latest_reactions'] as Map?)?.map(
      (k, e) => MapEntry(
          k as String,
          (e as List<dynamic>)
              .map(
                  (e) => Reaction.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()),
    ),
  );
}

Map<String, dynamic> _$EnrichedActivityToJson(EnrichedActivity instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', readonly(instance.id));
  val['actor'] = EnrichableField.serialize(instance.actor);
  val['verb'] = instance.verb;
  val['object'] = EnrichableField.serialize(instance.object);
  writeNotNull('foreign_id', instance.foreignId);
  writeNotNull('target', readonly(instance.target));
  writeNotNull('time', instance.time?.toIso8601String());
  writeNotNull('origin', readonly(instance.origin));
  writeNotNull('to', readonly(instance.to));
  writeNotNull('score', readonly(instance.score));
  writeNotNull('analytics', readonly(instance.analytics));
  writeNotNull('extra_context', readonly(instance.extraContext));
  writeNotNull('reaction_counts', readonly(instance.reactionCounts));
  writeNotNull('own_reactions', readonly(instance.ownReactions));
  writeNotNull('latest_reactions', readonly(instance.latestReactions));
  writeNotNull('extra_data', instance.extraData);
  return val;
}
