import 'package:stream_feed_dart/src/core/util/routes.dart';
import 'package:test/test.dart';

main() {
  group('routes', () {
    group('buildSubdomainPath', () {
      test('personalization', () {
        const resource = 'example';
        const baseURL = 'stream-io-api.com';
        const subdomain = 'personalization';
        const apiPath = 'personalization';
        const apiVersion = 'v1.0';
        final subdomainPath = Routes.buildSubdomainPath(
            baseURL, subdomain, apiPath, apiVersion, resource);
        expect(subdomainPath,
            'https://personalization.stream-io-api.com/personalization/v1.0/example');
      });

      test('analytics', () {
        const path = 'redirect';
        const baseURL = 'stream-io-api.com';
        const subdomain = 'analytics';
        const apiPath = 'analytics';
        const apiVersion = 'v1.0';
        final subdomainPath = Routes.buildSubdomainPath(
            baseURL, subdomain, apiPath, apiVersion, path);
        expect(subdomainPath,
            'https://analytics.stream-io-api.com/analytics/v1.0/redirect');
      });
    });
  });
}
