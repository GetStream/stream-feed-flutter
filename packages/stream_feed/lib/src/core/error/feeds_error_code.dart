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
