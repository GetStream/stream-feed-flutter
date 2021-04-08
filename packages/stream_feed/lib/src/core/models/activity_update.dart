import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity_update.g.dart';

///
@JsonSerializable()
class ActivityUpdate extends Equatable {
  ///
  const ActivityUpdate({
    required this.set,
    required this.unset,
    this.id,
    this.foreignId,
    this.time,
  });

  ///
  factory ActivityUpdate.withId(
    String id,
    Map<String, Object> set,
    List<String> unset,
  ) =>
      ActivityUpdate(
        id: id,
        set: set,
        unset: unset,
      );

  ///
  factory ActivityUpdate.withForeignId(
    String foreignId,
    DateTime time,
    Map<String, Object> set,
    List<String> unset,
  ) =>
      ActivityUpdate(
        foreignId: foreignId,
        time: time,
        set: set,
        unset: unset,
      );

  /// Create a new instance from a json
  factory ActivityUpdate.fromJson(Map<String, dynamic> json) =>
      _$ActivityUpdateFromJson(json);

  /// The target activity ID.
  @JsonKey(includeIfNull: false)
  final String? id;

  /// The target activity foreign ID (matched with time).
  @JsonKey(includeIfNull: false)
  final String? foreignId;

  ///	The target activity timestamp (matched with foreign_id).
  @JsonKey(includeIfNull: false)
  final DateTime? time;

  /// An object containing the set operations,
  /// where keys are the target fields and the values are the values to be set.
  /// Maximum 25 top level keys.
  final Map<String, Object> set;

  /// A list of strings containing the fields to be removed from the activity.
  ///
  ///  Maximum 25 keys.
  final List<String> unset;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ActivityUpdateToJson(this);

  @override
  List<Object?> get props => [
        id,
        foreignId,
        time,
        set,
        unset,
      ];
}
