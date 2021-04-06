import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:faye_dart/src/channel.dart';
import 'package:faye_dart/src/message.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

final StreamChannelTransformer<Message?, String> jsonDocument =
    const _JsonDocument();

class _JsonDocument implements StreamChannelTransformer<Message?, String> {
  const _JsonDocument();

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

main() {
  late StreamController<String> streamController;
  late StreamController<String> sinkController;
  late StreamChannel<String> channel;
  setUp(() {
    streamController = StreamController<String>();
    sinkController = StreamController<String>();
    channel =
        StreamChannel<String>(streamController.stream, sinkController.sink);
  });
  test('decodes JSON emitted by the channel', () {
    var transformed = channel.transform(jsonDocument);
    streamController.add('{"channel": "bayeuxChannel"}');
    expect(
        transformed.stream.first,
        completion(
            equals(Message("bayeuxChannel", channel: Channel(name: "hey")))));
  });
}
