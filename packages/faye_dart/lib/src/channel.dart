import 'package:equatable/equatable.dart';
import 'package:faye_dart/faye_dart.dart';
import 'package:faye_dart/src/event_emitter.dart';

import 'message.dart';
import 'grammar.dart' as grammar;

const handshake_channel = '/meta/handshake';
const connect_channel = '/meta/connect';
const disconnect_channel = '/meta/disconnect';
const subscribe_channel = '/meta/subscribe';
const unsubscribe_channel = '/meta/unsubscribe';

const event_message = 'message';

class Channel with EquatableMixin, EventEmitter<Message> {
  final String name;
  Subscription? subscription;
  Map<String, Object>? ext;

  Channel({
    required String name,
  }) : name = '/${name.slashTrimmed}';

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
  bool operator ==(covariant Channel other) =>
      identical(this, other) || identical(other.name, name);

  @override
  int get hashCode => runtimeType.hashCode ^ name.hashCode;

  @override
  List<Object?> get props => [
        name,
        subscription,
        ext,
      ];
}

extension ChannelMapX on Map<String, Channel> {
  bool contains(String name) => keys.contains(name);

  void subscribe(Iterable<String> names, Subscription subscription) {
    for (final name in names) {
      final channel = this[name] ?? Channel(name: name);
      this[name] = channel..subscription = subscription;
      channel.bind(event_message, subscription);
    }
  }

  bool unsubscribe(String name, Subscription subscription) {
    final channel = this[name];
    if (channel == null) return false;
    channel.unbind(event_message, subscription);
    if (!channel.hasListeners(event_message)) {
      remove(name);
      return true;
    }
    return false;
  }

  void distributeMessage(Message message) {
    final channels = Channel.expand(message.channel);
    if (channels == null) return;
    for (final channel in channels) {
      this[channel]?.trigger(event_message, message);
    }
  }
}

extension StringX on String {
  /// Removes `/` char from the string.
  String get slashTrimmed {
    return this.replaceAll(r'/', '').trim();
  }
}
