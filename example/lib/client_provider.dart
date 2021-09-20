import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_feed/stream_feed.dart';

/// Provides a [StreamFeedClient] to sub-widget trees.
class ClientProvider extends InheritedWidget {
  /// Builds a [ClientProvider].
  const ClientProvider({
    Key? key,
    required this.client,
    required Widget child,
  }) : super(key: key, child: child);

  /// Manages API calls and authentication.
  ///
  /// See the docs for [StreamFeedClient] for more information.
  final StreamFeedClient client;

  /// The closest instance of this class that encloses the given context.
  ///
  /// Typical usage is as follows:
  /// ```dart
  /// final clientProvider = ClientProvider.of(context);
  /// ```
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
