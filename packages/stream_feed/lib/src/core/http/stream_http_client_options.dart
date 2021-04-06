part of 'stream_http_client.dart';

/// Client options to modify [StreamHttpClient]
class StreamHttpClientOptions {
  /// Instantiates a new [StreamHttpClientOptions]
  const StreamHttpClientOptions({
    this.location,
    this.version = 'v1.0',
    this.protocol = 'https',
    this.group = 'unspecified',
    this.urlOverride = const <String, String>{},
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 10),
  });

  /// data center to use with client
  final Location? location;

  /// protocol to use with the api calls
  final String protocol;

  /// track a source name for the api calls
  final String group;

  /// connect timeout, default to 10s
  final Duration connectTimeout;

  /// received timeout, default to 10s
  final Duration receiveTimeout;

  /// map of url's to possibly override baseUrl
  final Map<String, String> urlOverride;

  /// version to use with client
  final String version;

  /// Get the current user agent
  String get _userAgent => 'stream-feed-dart-client-${CurrentPlatform.name}-'
      '${packageVersion.split('+')[0]}';

  /// generates a baseUrl using the provided [serviceName]
  String _getBaseUrl(String serviceName) {
    if (urlOverride.containsKey(serviceName)) {
      return urlOverride[serviceName]!;
    }

    const baseDomainName = 'stream-io-api.com';
    var hostname = '$serviceName.$baseDomainName';
    if (location != null) hostname = '${location!.name}-$hostname';
    return '$protocol://$hostname/$serviceName/$version';
  }
}
