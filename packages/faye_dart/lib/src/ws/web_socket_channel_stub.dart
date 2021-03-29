import 'package:web_socket_channel/web_socket_channel.dart';

/// Stub version of websocket implementation
/// Used just for conditional library import
Future<WebSocketChannel?> connectWebSocket(
  String url, {
  Iterable<String>? protocols,
  Duration? connectionTimeout,
}) =>
    throw UnimplementedError();
