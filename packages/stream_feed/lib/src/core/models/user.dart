import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed_dart/src/core/util/serializer.dart';

part 'user.g.dart';

///
@JsonSerializable()
class User extends Equatable {
  ///
  const User({
    this.id,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.followersCount,
    this.followingCount,
  });

  /// Create a new instance from a json
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  ///
  final String? id;

  ///
  final Map<String, Object>? data;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime? createdAt;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime? updatedAt;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final int? followersCount;

  ///
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final int? followingCount;

  @override
  List<Object?> get props => [
        id,
        data,
        createdAt,
        updatedAt,
        followersCount,
        followingCount,
      ];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
