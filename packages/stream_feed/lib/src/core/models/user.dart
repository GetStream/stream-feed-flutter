import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/util/serializer.dart';
import 'package:stream_feed/src/core/util/utc_converter.dart';

part 'user.g.dart';

/// {@template user}
/// Stream allows you to store user information and embed them inside
/// activities or use them for personalization.
///
/// When stored in activities, users are automatically enriched by Stream.
/// {@endtemplate}
@JsonSerializable()
@DateTimeUTCConverter()
class User extends Equatable {
  /// Builds a [User].
  const User({
    this.id,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.followersCount,
    this.followingCount,
  });

  /// Create a new instance from a JSON object
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  ///	The unique identifier for the new user (eg. username, user id, etc.).
  ///
  /// The value is restricted to alphanumeric characters, dashes and
  /// underscore symbols.
  final String? id;

  /// User additional data.
  final Map<String, Object?>? data;

  /// When the user was created.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime? createdAt;

  /// When the user was last updated.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime? updatedAt;

  /// Number of users that follow this user.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final int? followersCount;

  /// Number of users this user is following.
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
