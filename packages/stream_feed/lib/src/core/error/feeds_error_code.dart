import 'package:collection/collection.dart';

/// Enumerates the list of errors that are returned by the API.
///
/// Each error is documented with the associated http error code, description,
/// and Stream Code.
enum FeedsError {
  /// Bad request (http 400).
  ///
  /// Pagination error.
  ///
  /// Has a Stream error code of 4.
  pagination,

  /// Bad request (http 400).
  ///
  /// There is an error with the user input data.
  ///
  /// Has a Stream error code of 4.
  input,

  /// Bad request (http 400).
  ///
  /// Missing or mis-configured feed.
  ///
  /// Has a Stream error code of 6.
  feedConfig,

  /// Bad request (http 400).
  ///
  /// Missing user in request payload.
  ///
  /// Has a Stream error code of 10.
  missingUser,

  /// Bad request (http 400).
  ///
  /// Triggered when there is an issue with ranking the feed.
  ///
  /// Has a Stream error code of 11.
  ranking,

  /// Bad request (http 400).
  ///
  /// The ranking isn't configured for the given feed.
  ///
  /// Has a Stream error code of 12.
  missingRanking,

  /// Bad request (http 400).
  ///
  /// The activity doesn't exist.
  ///
  /// Has a Stream error code of 13.
  missingActivity,

  /// Bad request (http 400).
  ///
  /// The aggregation format isn't correct.
  ///
  /// Has a Stream error code of 14.
  aggregation,

  /// Unauthorized (http 401).
  ///
  /// Triggered when the API key is invalid.
  ///
  /// Has a Stream error code of 2.
  accessKey,

  /// Unauthorized (http 401).
  ///
  /// The payload signature is invalid.
  ///
  /// Has a Stream error code of 3.
  signature,

  /// Unauthorized (http 401).
  ///
  /// The payload signature is invalid.
  ///
  /// Has a Stream error code of 3.
  authenticationFailed,

  /// Unauthorized (http 401).
  ///
  /// The app is suspended.
  ///
  /// Has a Stream error code of 7.
  appSuspended,

  /// Forbidden (http 403).
  ///
  /// Requested action is not allowed.
  ///
  /// Has a Stream error code of 17.
  notAllowed,

  /// Not found (http 404).
  ///
  /// Resource not found.
  ///
  /// Has a Stream error code of 16.
  doesNotExist,

  /// Method not allowed (http 405).
  ///
  /// The requested method is not allowed.
  ///
  /// Has a Stream error code of 17.
  methodNotAllowed,

  /// Conflict (http 409).
  ///
  /// There is a conflict (e,g. when trying to create an existing resource).
  ///
  /// Has a Stream error code of 22.
  conflict,

  /// Requested entity too large (http 413).
  ///
  /// Input body size limit exceeded.
  ///
  /// Has a Stream error code of 18.
  inputErrorBodySizeExceeded,

  /// Too many requests (http 429).
  ///
  /// Rate limit reached.
  ///
  /// Has a Stream error code of 9.
  rateLimit,

  /// Internal Server Error (http 429).
  ///
  /// Triggered when something goes wrong in our system.
  ///
  /// Has a Stream error code of -1.
  internalSystem,
}

const _errorCodeWithDescription = {
  FeedsError.pagination: MapEntry(4, 'Pagination error.'),
  FeedsError.input: MapEntry(4, 'There is an error with the user input data.'),
  FeedsError.feedConfig: MapEntry(6, 'Missing or mis-configured feed.'),
  FeedsError.missingUser:
      MapEntry(11, 'Triggered when there is an issue with ranking the feed.'),
  FeedsError.missingRanking:
      MapEntry(12, 'The ranking isn\'t configured for the given feed.'),
  FeedsError.missingActivity:
      MapEntry(13, 'The aggregation format isn\'t correct.'),
  FeedsError.accessKey: MapEntry(2, 'Triggered when the API key is invalid.'),
  FeedsError.signature: MapEntry(3, 'The payload signature is invalid.'),
  FeedsError.authenticationFailed:
      MapEntry(3, 'The payload signature is invalid.'),
  FeedsError.appSuspended: MapEntry(7, 'The app is suspended.'),
  FeedsError.notAllowed: MapEntry(17, 'Requested action is not allowed.'),
  FeedsError.doesNotExist: MapEntry(16, 'Resource not found.'),
  FeedsError.methodNotAllowed:
      MapEntry(17, 'The requested method is not allowed.'),
  FeedsError.conflict: MapEntry(22,
      'There is a conflict (e,g. when trying to create an existing resource)'),
  FeedsError.inputErrorBodySizeExceeded:
      MapEntry(18, 'Input body size limit exceeded.'),
  FeedsError.rateLimit: MapEntry(9, 'Rate limit reached.'),
  FeedsError.internalSystem:
      MapEntry(-1, 'Triggered when something goes wrong in our system.'),
};

const _authenticationErrors = [
  FeedsError.accessKey,
  FeedsError.signature,
  FeedsError.authenticationFailed,
];

///
FeedsError? feedsErrorCodeFromCode(int code) => _errorCodeWithDescription.keys
    .firstWhereOrNull((key) => _errorCodeWithDescription[key]!.key == code);

/// Extensions on [FeedsError].
extension FeedsErrorCodeX on FeedsError {
  /// Returns the error code with the description
  String get message => _errorCodeWithDescription[this]!.value;

  /// Returns the code only.
  int get code => _errorCodeWithDescription[this]!.key;

  /// True if this error is an authentication error.
  bool get isAuthenticationError => _authenticationErrors.contains(this);
}
