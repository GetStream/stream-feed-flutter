// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reaction _$ReactionFromJson(Map json) {
  return Reaction(
    id: json['id'] as String,
    kind: json['kind'] as String,
    activityId: json['activity_id'] as String,
    userId: json['user_id'] as String,
    parent: json['parent'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    targetFeeds: FeedId.fromIds(json['target_feeds'] as List<String>),
    user: (json['user'] as Map)?.map(
      (k, e) => MapEntry(k as String, e),
    ),
    targetFeedsExtraData: (json['target_feeds_extra_data'] as Map)?.map(
      (k, e) => MapEntry(k as String, e),
    ),
    data: (json['data'] as Map)?.map(
      (k, e) => MapEntry(k as String, e),
    ),
    latestChildren: (json['latest_children'] as Map)?.map(
      (k, e) => MapEntry(
          k as String,
          (e as List)
              ?.map((e) => e == null
                  ? null
                  : Reaction.fromJson((e as Map)?.map(
                      (k, e) => MapEntry(k as String, e),
                    )))
              ?.toList()),
    ),
    childrenCounts: (json['children_counts'] as Map)?.map(
      (k, e) => MapEntry(k as String, e as int),
    ),
  );
}

Map<String, dynamic> _$ReactionToJson(Reaction instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', readonly(instance.id));
  val['kind'] = instance.kind;
  val['activity_id'] = instance.activityId;
  val['user_id'] = instance.userId;
  writeNotNull('parent', instance.parent);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', readonly(instance.updatedAt));
  writeNotNull('target_feeds', FeedId.toIds(instance.targetFeeds));
  writeNotNull('user', instance.user);
  writeNotNull('target_feeds_extra_data', instance.targetFeedsExtraData);
  writeNotNull('data', instance.data);
  writeNotNull('latest_children', readonly(instance.latestChildren));
  writeNotNull('children_counts', readonly(instance.childrenCounts));
  return val;
}
