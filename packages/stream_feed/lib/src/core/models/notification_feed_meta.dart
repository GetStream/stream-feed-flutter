import 'package:json_annotation/json_annotation.dart';

part 'notification_feed_meta.g.dart';

@JsonSerializable(createToJson: false)
class NotificationFeedMeta {
  NotificationFeedMeta({
    required this.unreadCount,
    required this.unseenCount,
  });

  factory NotificationFeedMeta.fromJson(Map json) =>
      _$NotificationFeedMetaFromJson(json);

  @JsonKey(name: 'unread')
  final int unreadCount;

  @JsonKey(name: 'unseen')
  final int unseenCount;
}
