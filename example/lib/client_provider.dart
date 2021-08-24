import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_feed/stream_feed.dart';

//ignore: public_member_api_docs
class ClientProvider extends InheritedWidget {
  //ignore: public_member_api_docs
  const ClientProvider({
    required this.client,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  //ignore: public_member_api_docs
  final StreamFeedClient client;

  //ignore: public_member_api_docs
  static ClientProvider of(BuildContext context) {
    final client = context.dependOnInheritedWidgetOfExactType<ClientProvider>();
    assert(client != null, 'Client not found in the widget tree');
    return client!;
  }

  @override
  //ignore: prefer_expression_function_bodies
  bool updateShouldNotify(ClientProvider old) {
    return old.child != child || old.client != client;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<StreamFeedClient>('client', client));
  }
}
