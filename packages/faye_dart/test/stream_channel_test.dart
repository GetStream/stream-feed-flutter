import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:faye_dart/src/channel.dart';
import 'package:faye_dart/src/message.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

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
    _streamController = StreamController<String>();
    _sinkController = StreamController<String>();
    _channel =
        StreamChannel<String>(_streamController.stream, _sinkController.sink);
  }

  Stream<Message?> get messages => _transformed.stream;

  void add(String rawMessage) {
    _streamController.add(rawMessage);
  }

  void dispose() {
    _streamController.close();
  }
}

main() {
  late MessageBloc bloc;
  setUp(() {
    bloc = MessageBloc();
  });
  test('decodes JSON emitted by the channel', () {
    bloc.add('{"channel": "bayeuxChannel"}');
    expectLater(
        bloc.messages,
        emitsInOrder(
            [Message("bayeuxChannel", channel: Channel(name: "hey"))]));
  });
}
