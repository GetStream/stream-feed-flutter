import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/models/mark_read_seen.dart';

class MarkReadConverter implements JsonConverter<MarkRead, dynamic> {
  const MarkReadConverter();

  @override
  MarkRead fromJson(dynamic json) => MarkRead.fromJson(json);

  @override
  Map<String, dynamic> toJson(MarkRead markRead) => markRead.toJson(); //formatDateWithOffset(json);
}

class MarkSeenConverter implements JsonConverter<MarkSeen, dynamic> {
  const MarkSeenConverter();

  @override
  MarkSeen fromJson(dynamic json) => MarkSeen.fromJson(json);

  @override
  Map<String, dynamic> toJson(MarkSeen markSeen) => markSeen.toJson(); //formatDateWithOffset(json);
}

