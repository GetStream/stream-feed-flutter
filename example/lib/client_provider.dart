import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_feed/stream_feed.dart';

class ClientProvider extends InheritedWidget {
  const ClientProvider({
    Key? key,
    required this.client,
    required Widget child,
  }) : super(key: key, child: child);

  /// Access the [StreamFeedClient] from the provider to perform API actions.
  final StreamFeedClient client;

  static ClientProvider of(BuildContext context) {
    final client = context.dependOnInheritedWidgetOfExactType<ClientProvider>();
    assert(client != null, 'Client not found in the widget tree');
    return client!;
  }

  @override
  bool updateShouldNotify(ClientProvider old) {
    return old.child != child || old.client != client;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<StreamFeedClient>('client', client));
  }
}
