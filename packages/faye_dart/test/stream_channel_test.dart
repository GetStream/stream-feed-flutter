import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:faye_dart/src/channel.dart';
import 'package:faye_dart/src/message.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';
import 'package:rxdart/rxdart.dart';

class _MessageTransformer
    implements StreamChannelTransformer<Message?, String> {
  const _MessageTransformer();

  @override
  StreamChannel<Message?> bind(StreamChannel<String> channel) {
    var stream =
        channel.stream.map((data) => Message.fromJson(json.decode(data)));
    var sink = StreamSinkTransformer<Message, String>.fromHandlers(
        handleData: (data, sink) {
      sink.add(jsonEncode(data));
    }).bind(channel.sink);
    return StreamChannel.withCloseGuarantee(stream, sink);
  }
}

class MessageBloc {
  late StreamController<String> _streamController;
  late StreamController<String> _sinkController;
  late StreamChannel<String> _channel;
  late StreamChannel<Message?> _transformed =
      _channel.transform(_MessageTransformer());

  MessageBloc() {
    _streamController = StreamController<String>.broadcast(sync: true);
    _sinkController = StreamController<String>();
    _channel =
        StreamChannel<String>(_streamController.stream, _sinkController.sink);
  }

  Stream<Message?> get messages => _transformed.stream.asBroadcastStream();

  void add(String rawMessage) {
    _streamController.add(rawMessage);
  }

  void dispose() {
    _streamController.close();
  }
}

class ChannelsBloc {
  late Map<String, MessageBloc> _channels;
  ChannelsBloc() {
    _channels = {};
  }
  Stream<Message?> subscribe(String eventType) {
    if (!_channels.containsKey(eventType)) {
      _channels[eventType] = MessageBloc();
    }
    return _channels[eventType]!.messages;
  }

  void unbind(String eventType) {
    _channels[eventType]!.dispose();
    _channels.remove(eventType);
  }

  void trigger(String eventType, String rawMessage) {
    _channels[eventType]!.add(rawMessage);
  }

  bool hasListeners(String event_message) =>
      _channels.containsKey(event_message);
}

main() {
  late ChannelsBloc bloc;
  setUp(() {
    bloc = ChannelsBloc();
  });
  test('decodes JSON emitted by the channel', () {
    const event_message = 'message';
    expect(bloc.hasListeners(event_message), false);
    var subscription = bloc.subscribe(event_message);
    expect(bloc.hasListeners(event_message), true);
    var subscription2 = bloc.subscribe(event_message);

    subscription.listen((event) {
      print("subscription1 $event");
    });

    subscription2.listen((event) {
      print("subscription2 $event");
    });

    bloc.trigger(event_message, '{"channel": "bayeuxChannel"}');
  });
}
