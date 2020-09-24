import 'package:stream_feed_dart/src/client/stream_client_impl.dart';
import 'package:stream_feed_dart/src/core/api/stream_api_impl.dart';
import 'package:stream_feed_dart/src/core/http/stream_http_client_adapter.dart';
import 'package:stream_feed_dart/src/models/activity.dart';

main() {
  final httpClient = StreamHttpClient('9wbdt7vucby6');
  final api = StreamApiImpl(httpClient);
  final client = StreamClientImpl(
      'bksn37r6k7j5p75mmy6znts47j9f9pc49bmw3jjyd7rshg2enbcnq666d2ryfzs8', api);

  final batch = client.batch;
  final activity = Activity();
  batch.addToMany(activity);
}
