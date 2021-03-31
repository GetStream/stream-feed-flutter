part of 'client.dart';

typedef ChannelCallback = void Function(String data);
typedef WithChannelCallback = void Function(String, String);

class Subscription {
  final FayeClient _client;
  final String _channel;
  final ChannelCallback? _callback;
  WithChannelCallback? _withChannel;
  bool _cancelled = false;

  late final _completer = Completer<Subscription>();

  Subscription(
    this._client,
    this._channel, {
    ChannelCallback? callback,
  }) : _callback = callback;

  Future<Subscription> get _future => _completer.future;

  void _complete() => _completer.complete(this);

  void _completeError(String error) => _completer.completeError(error);

  //
// apply: function(context, args) {
//   var message = args[0];
//
//   if (this._callback)
//     this._callback.call(this._context, message.data);
//
//   if (this._withChannel)
//     this._withChannel[0].call(this._withChannel[1], message.channel, message.data);
// },

  void call(Message message) {
    _callback?.call('');
    _withChannel?.call('', '');
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
