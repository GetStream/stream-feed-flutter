import 'package:equatable/equatable.dart';
import 'package:faye_dart/src/event_emitter.dart';
import 'package:faye_dart/src/grammar.dart' as grammar;
import 'package:faye_dart/src/message.dart';
import 'package:faye_dart/src/subscription.dart';

const eventMessage = 'message';

class Channel with EquatableMixin, EventEmitter<Message> {
  Channel(this.name);

  final String name;

  static const String handshake = '/meta/handshake';
  static const String connect = '/meta/connect';
  static const String disconnect = '/meta/disconnect';
  static const String subscribe = '/meta/subscribe';
  static const String unsubscribe = '/meta/unsubscribe';

  void bind(String event, Listener<Message> listener) => on(event, listener);

  void unbind(String event, Listener<Message> listener) =>
      removeListener(event, listener);

  void trigger(String event, Message message) => emit(event, message);

  static List<String>? expand(String name) {
    final channels = ['/**', name];
    final segments = parse(name);

    if (segments == null) return null;

    var copy = segments;
    copy.last = '*';
    channels.add(unparse(copy));

    for (var i = 1; i < segments.length; i++) {
      copy = segments.sublist(0, i);
      copy.add('**');
      channels.add(unparse(copy));
    }

    return channels;
  }

  static bool isValid(String name) {
    return RegExp(grammar.channelName).hasMatch(name) ||
        RegExp(grammar.channelPattern).hasMatch(name);
  }

  static List<String>? parse(String name) {
    if (!isValid(name)) return null;
    return name.split('/').sublist(1);
  }

  static String unparse(Iterable<String> segments) => '/${segments.join('/')}';

  static bool? isMeta(String name) {
    final segments = parse(name);
    if (segments == null) return null;
    return segments.elementAt(0) == 'meta';
  }

  static bool? isService(String name) {
    final segments = parse(name);
    if (segments == null) return null;
    return segments.elementAt(0) == 'service';
  }

  static bool? isSubscribable(String name) {
    if (!isValid(name)) return null;
    return !(isMeta(name) == true) && !(isService(name) == true);
  }

  @override
  List<Object?> get props => [name];
}

extension ChannelMapX on Map<String, Channel> {
  bool contains(String name) => keys.contains(name);

  void subscribe(String name, Subscription subscription) {
    final channel = putIfAbsent(name, () => Channel(name));
    channel.bind(eventMessage, subscription);
  }

  bool unsubscribe(String name, Subscription subscription) {
    final channel = this[name];
    if (channel == null) return false;
    channel.unbind(eventMessage, subscription);
    if (!channel.hasListeners(eventMessage)) {
      remove(name);
      return true;
    }
    return false;
  }

  void distributeMessage(Message message) {
    final channels = Channel.expand(message.channel);
    if (channels == null) return;
    for (final channel in channels) {
      this[channel]?.trigger(eventMessage, message);
    }
  }
}
