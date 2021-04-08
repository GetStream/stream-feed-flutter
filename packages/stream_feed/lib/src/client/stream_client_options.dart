import 'package:stream_feed_dart/src/core/location.dart';

import 'package:stream_feed_dart/version.dart';

/// Stream Client Options used by Stream http client
class StreamClientOptions {
  const StreamClientOptions({
    this.version = 'v1.0',
    this.serviceName = 'api',
    this.baseDomainName = 'stream-io-api.com',
    this.location = Location.usEast,
    this.connectTimeout = const Duration(seconds: 6), //TODO: 10s in js
    this.receiveTimeout = const Duration(seconds: 6), //TODO: 10s in js
  });

  /// advanced usage, custom api version
  final String version;

  /// the name of the service
  final String serviceName;

  /// base Domain Name
  final String baseDomainName;

  /// 	The name of the API location
  /// For example: us-east, us-west etc
  final Location location;

  /// connect imeout, default to 6s
  final Duration connectTimeout;

  /// received timeout
  final Duration receiveTimeout;

  /// base url
  String get baseUrl => 'https://${location.name}-$serviceName.$baseDomainName';

  /// route Base Path
  String get routeBasePath => '/$serviceName/$version/';

  /// Getter for the current user agent
  String get userAgent => 'stream-feed-dart-client-$packageVersion';
}
