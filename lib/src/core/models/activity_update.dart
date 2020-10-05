import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity_update.g.dart';

///
@JsonSerializable(createFactory: false)
class ActivityUpdate extends Equatable {
  ///
  @JsonKey(includeIfNull: false)
  final String id;

  ///
  @JsonKey(includeIfNull: false)
  final String foreignId;

  ///
  final DateTime time;

  ///
  final Map<String, Object> set;

  ///
  final List<String> unset;

  const ActivityUpdate._({
    this.id,
    this.foreignId,
    this.time,
    this.set,
    this.unset,
  });

  ///
  factory ActivityUpdate.withId(
    String id,
    DateTime time,
    Map<String, Object> set,
    List<String> unset,
  ) {
    return ActivityUpdate._(
      id: id,
      time: time,
      set: set,
      unset: unset,
    );
  }

  ///
  factory ActivityUpdate.withForeignId(
    String foreignId,
    DateTime time,
    Map<String, Object> set,
    List<String> unset,
  ) {
    return ActivityUpdate._(
      foreignId: foreignId,
      time: time,
      set: set,
      unset: unset,
    );
  }

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ActivityUpdateToJson(this);

  @override
  List<Object> get props => [
        id,
        foreignId,
        time,
        set,
        unset,
      ];
}
