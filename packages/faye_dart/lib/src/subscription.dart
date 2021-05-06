import 'client.dart';
import 'message.dart';

typedef Callback = void Function(Map<String, dynamic>? data);
typedef WithChannelCallback = void Function(String, Map<String, dynamic>?);

class Subscription {
  final FayeClient _client;
  final String _channel;
  final Callback? _callback;
  WithChannelCallback? _withChannel;
  bool _cancelled = false;

  Subscription(
    this._client,
    this._channel, {
    Callback? callback,
  }) : _callback = callback;

  void call(Message message) {
    _callback?.call(message.data);
    _withChannel?.call(message.channel, message.data);
  }

  Subscription withChannel(WithChannelCallback withChannel) {
    _withChannel = withChannel;
    return this;
  }

  void cancel() {
    if (_cancelled) return;
    _client.unsubscribe(_channel, this);
    _cancelled = true;
  }
}
