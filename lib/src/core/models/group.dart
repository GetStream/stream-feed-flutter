import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';

part 'group.g.dart';

///
@JsonSerializable(createToJson: false, genericArgumentFactories: true)
class Group<T extends Activity> extends Equatable {
  ///
  final String id;

  ///
  final String group;

  ///
  final List<T> activities;

  ///
  final int actorCount;

  ///
  final DateTime createdAt;

  ///
  final DateTime updatedAt;

  ///
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
    T Function(Object json) fromJsonT,
  ) =>
      _$GroupFromJson(json, fromJsonT);

  @override
  List<Object> get props => [
        id,
        group,
        activities,
        actorCount,
        createdAt,
        updatedAt,
      ];
}

///
@JsonSerializable(genericArgumentFactories: true)
class NotificationGroup<T extends Activity> extends Group<T> {
  ///
  final bool isRead;

  ///
  final bool isSeen;

  ///
  const NotificationGroup({
    String id,
    String group,
    List<T> activities,
    int actorCount,
    DateTime createdAt,
    DateTime updatedAt,
    this.isRead,
    this.isSeen,
  }) : super(
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
    T Function(Object json) fromJsonT,
  ) =>
      _$NotificationGroupFromJson(json, fromJsonT);

  @override
  List<Object> get props => [
        ...super.props,
        isRead,
        isSeen,
      ];
}
