import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_feed/stream_feed.dart';

class ClientProvider extends InheritedWidget {
  const ClientProvider({
    Key? key,
    required this.client,
    required Widget child,
  }) : super(key: key, child: child);

  final StreamClient client;

  static ClientProvider of(BuildContext context) {
    final client = context.dependOnInheritedWidgetOfExactType<ClientProvider>();
    assert(client != null, 'Client not found in the widget tree');
    return client!;
  }

  @override
  bool updateShouldNotify(ClientProvider old) {
    return old.child != child || old.client != client;
  }
}
