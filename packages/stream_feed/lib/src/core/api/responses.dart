import 'package:json_annotation/json_annotation.dart';

part 'responses.g.dart';

class _BaseResponse {
  const _BaseResponse(this.duration);
  final String? duration;
}

/// Model response for [StreamFeedNetworkError] data
@JsonSerializable()
class ErrorResponse extends _BaseResponse {
  /// Create a new instance from a json
  const ErrorResponse(
      {String? duration,
      this.message,
      this.code,
      this.statusCode,
      this.moreInfo})
      : super(duration);

  /// Create a new instance from a json
  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  /// The http error code
  final int? code;

  /// The message associated to the error code
  final String? message;

  /// The backend error code
  final int? statusCode;

  /// A detailed message about the error
  final String? moreInfo;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  String toString() => 'ErrorResponse(code: $code, '
      'message: $message, '
      'statusCode: $statusCode, '
      'moreInfo: $moreInfo)';
}
