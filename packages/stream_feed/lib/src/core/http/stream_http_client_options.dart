part of 'stream_http_client.dart';

/// Client options to modify [StreamHttpClient]
class StreamHttpClientOptions {
  /// Builds a  [StreamHttpClientOptions].
  const StreamHttpClientOptions({
    this.location,
    this.version = 'v1.0',
    this.protocol = 'https',
    this.group = 'unspecified',
    this.urlOverride = const <String, String>{},
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 10),
  });

  /// Data center to use with client
  final Location? location;

  /// Protocol to use with the api calls
  final String protocol;

  /// Track a source name for the api calls
  final String group;

  /// Connect timeout.
  ///
  /// Defaults to 10 seconds.
  final Duration connectTimeout;

  /// Received timeout.
  ///
  /// Defaults to 10 seconds.
  final Duration receiveTimeout;

  /// Map of url's to possibly override baseUrl
  final Map<String, String> urlOverride;

  /// Version to use with client
  final String version;

  /// Get the current user agent
  String get _userAgent => 'stream-feed-dart-client-${CurrentPlatform.name}-'
      '${packageVersion.split('+')[0]}'; //TODO(sacha):add a parameter to StreamHttpClientOptions to specify the package used (llc,core,ui)

  /// Generates a baseUrl using the provided [serviceName]
  String _getBaseUrl(String serviceName) {
    if (urlOverride.containsKey(serviceName)) {
      return urlOverride[serviceName]!;
    }
    const baseDomainName = 'stream-io-api.com';
    var hostname = '$serviceName.$baseDomainName';
    if (location != null) hostname = '${location!.name}-$hostname';

    final uri = Uri(
      scheme: protocol,
      host: hostname,
      pathSegments: [serviceName, version],
    );

    return uri.toString();
  }
}
