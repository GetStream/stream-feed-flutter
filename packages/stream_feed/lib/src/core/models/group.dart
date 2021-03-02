import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

///
@JsonSerializable(createToJson: true, genericArgumentFactories: true)
class Group<T> extends Equatable {
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
    T Function(Object) fromJsonT,
  ) =>
      _$GroupFromJson(json, fromJsonT);

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

  @override
  List<Object> get props => [
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

///
@JsonSerializable(createToJson: true, genericArgumentFactories: true)
class NotificationGroup<T> extends Group<T> {
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

  ///
  final bool isRead;

  ///
  final bool isSeen;

  @override
  List<Object> get props => [
        ...super.props,
        isRead,
        isSeen,
      ];

  /// Serialize to json
  Map<String, dynamic> toJson(Object Function(T) toJsonT) =>
      _$NotificationGroupToJson(this, toJsonT);
}
