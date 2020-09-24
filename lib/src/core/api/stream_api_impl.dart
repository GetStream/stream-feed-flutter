import 'package:stream_feed_dart/src/core/api/batch_api.dart';
import 'package:stream_feed_dart/src/core/api/batch_api_impl.dart';
import 'package:stream_feed_dart/src/core/api/stream_api.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';

class StreamApiImpl implements StreamApi {
  final HttpClient client;

  const StreamApiImpl(this.client);

  @override
  BatchApi get batch => BatchApiImpl(client);
}
