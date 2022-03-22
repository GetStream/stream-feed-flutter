// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_feed_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationFeedMeta _$NotificationFeedMetaFromJson(Map json) =>
    NotificationFeedMeta(
      unreadCount: json['unread'] as int,
      unseenCount: json['unseen'] as int,
    );

Map<String, dynamic> _$NotificationFeedMetaToJson(
        NotificationFeedMeta instance) =>
    <String, dynamic>{
      'unread': instance.unreadCount,
      'unseen': instance.unseenCount,
    };
