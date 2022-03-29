// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map json) => UserData(
      json['id'] as String,
      json['alias'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'alias': instance.alias,
    };

Feature _$FeatureFromJson(Map json) => Feature(
      json['group'] as String,
      json['value'] as String,
    );

Map<String, dynamic> _$FeatureToJson(Feature instance) => <String, dynamic>{
      'group': instance.group,
      'value': instance.value,
    };

Event _$EventFromJson(Map json) => Event(
      userData: json['user_data'] == null
          ? null
          : UserData.fromJson(
              Map<String, dynamic>.from(json['user_data'] as Map)),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => Feature.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      feedId: FeedId.fromId(json['feed_id'] as String?),
      location: json['location'] as String?,
      position: json['position'] as int?,
    );

Map<String, dynamic> _$EventToJson(Event instance) {
  final val = <String, dynamic>{
    'user_data': instance.userData?.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('features', instance.features?.map((e) => e.toJson()).toList());
  writeNotNull('feed_id', FeedId.toId(instance.feedId));
  writeNotNull('location', instance.location);
  writeNotNull('position', instance.position);
  return val;
}

Engagement _$EngagementFromJson(Map json) => Engagement(
      content:
          Content.fromJson(Map<String, dynamic>.from(json['content'] as Map)),
      label: json['label'] as String,
      score: json['score'] as int?,
      boost: json['boost'] as int?,
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => Feature.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      feedId: FeedId.fromId(json['feed_id'] as String?),
      location: json['location'] as String?,
      position: json['position'] as int?,
      trackedAt: json['tracked_at'] as String?,
      userData: json['user_data'] == null
          ? null
          : UserData.fromJson(
              Map<String, dynamic>.from(json['user_data'] as Map)),
    );

Map<String, dynamic> _$EngagementToJson(Engagement instance) {
  final val = <String, dynamic>{
    'user_data': instance.userData?.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('features', instance.features?.map((e) => e.toJson()).toList());
  writeNotNull('feed_id', FeedId.toId(instance.feedId));
  writeNotNull('location', instance.location);
  writeNotNull('position', instance.position);
  val['content'] = instance.content.toJson();
  val['label'] = instance.label;
  val['score'] = instance.score;
  writeNotNull('boost', instance.boost);
  writeNotNull('tracked_at', instance.trackedAt);
  return val;
}

Impression _$ImpressionFromJson(Map json) => Impression(
      contentList: (json['content_list'] as List<dynamic>)
          .map((e) => Content.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => Feature.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      feedId: FeedId.fromId(json['feed_id'] as String?),
      location: json['location'] as String?,
      position: json['position'] as int?,
      trackedAt: json['tracked_at'] as String?,
      userData: json['user_data'] == null
          ? null
          : UserData.fromJson(
              Map<String, dynamic>.from(json['user_data'] as Map)),
    );

Map<String, dynamic> _$ImpressionToJson(Impression instance) {
  final val = <String, dynamic>{
    'user_data': instance.userData?.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('features', instance.features?.map((e) => e.toJson()).toList());
  writeNotNull('feed_id', FeedId.toId(instance.feedId));
  writeNotNull('location', instance.location);
  writeNotNull('position', instance.position);
  val['content_list'] = instance.contentList.map((e) => e.toJson()).toList();
  writeNotNull('tracked_at', instance.trackedAt);
  return val;
}

Content _$ContentFromJson(Map json) => Content(
      foreignId: FeedId.fromId(json['foreign_id'] as String?),
      data: (json['data'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as Object),
      ),
    );

Map<String, dynamic> _$ContentToJson(Content instance) {
  final val = <String, dynamic>{
    'foreign_id': FeedId.toId(instance.foreignId),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('data', instance.data);
  return val;
}
