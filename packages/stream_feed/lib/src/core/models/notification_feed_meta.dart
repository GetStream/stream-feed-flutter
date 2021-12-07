import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_feed_meta.g.dart';

@JsonSerializable(createToJson: true)
class NotificationFeedMeta extends Equatable {
  const NotificationFeedMeta({
    required this.unreadCount,
    required this.unseenCount,
  });

  factory NotificationFeedMeta.fromJson(Map json) =>
      _$NotificationFeedMetaFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationFeedMetaToJson(this);

  @JsonKey(name: 'unread')
  final int unreadCount;

  @JsonKey(name: 'unseen')
  final int unseenCount;

  @override
  List<Object?> get props => [unreadCount, unseenCount];
}
