import 'package:stream_feed_dart/src/core/location.dart';

import 'package:stream_feed_dart/version.dart';

class StreamClientOptions {
  const StreamClientOptions({
    this.version = 'v1.0',
    this.serviceName = 'api',
    this.baseDomainName = 'stream-io-api.com',
    this.location = Location.usEast,
    this.connectTimeout = const Duration(seconds: 6), //TODO: 10s in js
    this.receiveTimeout = const Duration(seconds: 6), //TODO: 10s in js
  });

  /// advanced usage, custom api versio
  final String version;
  final String serviceName;
  final String baseDomainName;

  /// which data center to use
  final Location location;

  /// connect imeout, default to 6s
  final Duration connectTimeout;

  /// received timeout
  final Duration receiveTimeout;

  String get baseUrl => 'https://${location.name}-$serviceName.$baseDomainName';

  String get routeBasePath => '/$serviceName/$version/';

  /// Getter for the current user agent
  String get userAgent => 'stream-feed-dart-client-$PACKAGE_VERSION';
}
