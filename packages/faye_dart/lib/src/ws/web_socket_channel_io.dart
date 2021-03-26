import 'dart:io';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// IO version of websocket implementation
/// Used in Flutter mobile version
Future<WebSocketChannel> connectWebSocket(
  String url, {
  Iterable<String>? protocols,
  Duration? connectionTimeout,
}) async {
  var websocket = WebSocket.connect(url, protocols: protocols);
  if (connectionTimeout != null) {
    websocket = websocket.timeout(connectionTimeout);
  }
  final webSocket = await websocket;
  return IOWebSocketChannel(webSocket);
}
