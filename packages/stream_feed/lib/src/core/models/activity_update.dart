import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/util/utc_converter.dart';

part 'activity_update.g.dart';

/// For updating only parts of one or more activities by changing,
/// adding, or removing fields.
@JsonSerializable()
@DateTimeUTCConverter()
class ActivityUpdate extends Equatable {
  /// Builds an [ActivityUpdate].
  const ActivityUpdate({
    required this.set,
    required this.unset,
    this.id,
    this.foreignId,
    this.time,
  });

  /// ActivityUpdate with Id
  factory ActivityUpdate.withId({
    required String id,
    Map<String, Object>? set,
    List<String>? unset,
  }) =>
      ActivityUpdate(
        id: id,
        set: set,
        unset: unset,
      );

  /// ActivityUpdate with ForeignId and time
  factory ActivityUpdate.withForeignId({
    required String foreignId,
    required DateTime time,
    Map<String, Object>? set,
    List<String>? unset,
  }) =>
      ActivityUpdate(
        foreignId: foreignId,
        time: time,
        set: set,
        unset: unset,
      );

  /// Create a new instance from a JSON object
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
  ///
  /// Maximum 25 top level keys.
  @JsonKey(includeIfNull: false)
  final Map<String, Object>? set;

  /// A list of strings containing the fields to be removed from the activity.
  ///
  /// Maximum 25 keys.
  @JsonKey(includeIfNull: false)
  final List<String>? unset;

  /// Serialize to JSON
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
