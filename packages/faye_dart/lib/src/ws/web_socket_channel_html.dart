import 'dart:html';

import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Html version of websocket implementation
/// Used in Flutter web version
Future<WebSocketChannel> connectWebSocket(
  String url, {
  Iterable<String>? protocols,
  Duration? connectionTimeout,
}) async {
  var websocket = WebSocket(url, protocols);
  Future<Event> onOpenEvent = websocket.onOpen.first;
  if (connectionTimeout != null) {
    onOpenEvent = onOpenEvent.timeout(connectionTimeout);
  }
  await onOpenEvent;
  return HtmlWebSocketChannel(websocket);
}
