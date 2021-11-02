import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/util/utc_converter.dart';

part 'group.g.dart';

/// An aggregated group type.
@JsonSerializable(createToJson: true, genericArgumentFactories: true)
@DateTimeUTCConverter()
class Group<T> extends Equatable {
  /// [Group] constructor
  const Group({
    this.id,
    this.group,
    this.activities,
    this.actorCount,
    this.createdAt,
    this.updatedAt,
  });

  /// Create a new instance from a json
  factory Group.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$GroupFromJson(json, fromJsonT);

  /// A group id.
  final String? id;

  /// A group name.
  final String? group;

  /// A list of activities.
  final List<T>? activities;

  /// A number of actors in the group.
  final int? actorCount;

  /// A created date.
  final DateTime? createdAt;

  /// An updated date.
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        id,
        group,
        activities,
        actorCount,
        createdAt,
        updatedAt,
      ];

  /// Serialize to json
  Map<String, dynamic> toJson(Object Function(T) toJsonT) =>
      _$GroupToJson(this, toJsonT);
}

/// A notification group.
@JsonSerializable(createToJson: true, genericArgumentFactories: true)
class NotificationGroup<T> extends Group<T> {
  /// [NotificationGroup] constructor
  const NotificationGroup(
      {String? id,
      String? group,
      List<T>? activities,
      int? actorCount,
      DateTime? createdAt,
      DateTime? updatedAt,
      this.isRead,
      this.isSeen,
      this.unread,
      this.unseen})
      : super(
          id: id,
          group: group,
          activities: activities,
          actorCount: actorCount,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Create a new instance from a json
  factory NotificationGroup.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$NotificationGroupFromJson(json, fromJsonT);

  /// True if the notification group is read.
  final bool? isRead;

  /// True if the notification group is seen.
  final bool? isSeen;

  final int? unread;
  final int? unseen;

  @override
  List<Object?> get props => [...super.props, isRead, isSeen, unread, unseen];

  /// Serialize to json
  @override
  Map<String, dynamic> toJson(Object Function(T) toJsonT) =>
      _$NotificationGroupToJson(this, toJsonT);
}
