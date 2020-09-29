import 'package:stream_feed_dart/src/client/stream_client_options.dart';
import 'package:stream_feed_dart/src/core/api/batch_api.dart';
import 'package:stream_feed_dart/src/core/api/batch_api_impl.dart';
import 'package:stream_feed_dart/src/core/api/reaction_api.dart';
import 'package:stream_feed_dart/src/core/api/reaction_api_impl.dart';
import 'package:stream_feed_dart/src/core/api/stream_api.dart';
import 'package:stream_feed_dart/src/core/api/users_api.dart';
import 'package:stream_feed_dart/src/core/api/users_api_impl.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/stream_http_client.dart';

class StreamApiImpl implements StreamApi {
  final HttpClient _client;

  StreamApiImpl(
    String apiKey, {
    StreamClientOptions options,
    HttpClient client,
  }) : _client = client ?? StreamHttpClient(apiKey, options: options);

  @override
  BatchApi get batch => BatchApiImpl(_client);

  @override
  ReactionsApi get reaction => ReactionsApiImpl(_client);

  @override
  UsersApi get users => UsersApiImpl(_client);
}
