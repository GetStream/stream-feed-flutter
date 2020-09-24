import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'activity.g.dart';

class _BaseActivity extends Equatable {
  final String actor;
  final String object;
  final String verb;
  final String target;
  final List<String> to;

  const _BaseActivity({
    @required this.actor,
    @required this.object,
    @required this.verb,
    @required this.target,
    @required this.to,
  });

  @override
  List<Object> get props => [actor, object, verb, target, to];
}

@JsonSerializable(nullable: true)
class NewActivity extends _BaseActivity {
  final String foreignId;
  final String time;

  const NewActivity({
    @required String actor,
    @required String object,
    @required String verb,
    @required String target,
    @required List<String> to,
    this.foreignId,
    this.time,
  }) : super(actor: actor, object: object, verb: verb, target: target, to: to);

  @override
  List<Object> get props => [...super.props, foreignId, time];

  factory NewActivity.fromJson(Map<String, dynamic> json) =>
      _$NewActivityFromJson(json);

  Map<String, dynamic> toJson() => _$NewActivityToJson(this);
}

@JsonSerializable()
class UpdateActivity extends _BaseActivity {
  final String foreignId;
  final String time;

  const UpdateActivity({
    @required String actor,
    @required String object,
    @required String verb,
    @required String target,
    @required List<String> to,
    @required this.foreignId,
    @required this.time,
  }) : super(actor: actor, object: object, verb: verb, target: target, to: to);

  @override
  List<Object> get props => [...super.props, foreignId, time];

  factory UpdateActivity.fromJson(Map<String, dynamic> json) =>
      _$UpdateActivityFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateActivityToJson(this);
}

@JsonSerializable(nullable: true)
class Activity extends _BaseActivity {
  final String foreignId;
  final String id;
  final String time;
  final Map<String, Object> analytics;
  final Map<String, Object> extraContext;
  final String origin;
  final int score;

  const Activity({
    @required String actor,
    @required String object,
    @required String verb,
    @required String target,
    @required List<String> to,
    @required this.foreignId,
    @required this.id,
    @required this.time,
    this.analytics,
    this.extraContext,
    this.origin,
    this.score,
  }) : super(actor: actor, object: object, verb: verb, target: target, to: to);

  @override
  List<Object> get props => [
        ...super.props,
        foreignId,
        id,
        time,
        analytics,
        extraContext,
        origin,
        score,
      ];

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}
