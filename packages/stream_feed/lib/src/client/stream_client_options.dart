import 'package:stream_feed_dart/src/core/location.dart';

import '../../version.dart';

class StreamClientOptions {
  final String version;
  final String serviceName;
  final String baseDomainName;
  final Location location;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  const StreamClientOptions({
    this.version = 'v1.0',
    this.serviceName = 'api',
    this.baseDomainName = 'stream-io-api.com',
    this.location = Location.usEast,
    this.connectTimeout = const Duration(seconds: 6),
    this.receiveTimeout = const Duration(seconds: 6),
  });

  String get baseUrl => 'https://${location.name}-$serviceName.$baseDomainName';

  String get routeBasePath => '/$serviceName/$version/';

  String get userAgent => 'stream-feed-dart-client-$PACKAGE_VERSION';
}
