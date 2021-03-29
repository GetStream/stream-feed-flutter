import 'package:faye_dart/src/channel.dart';
import 'package:faye_dart/src/message.dart';
import 'package:test/test.dart';

main() {
  test('Advice', () {
    final advice = Advice.fromJson({
      'interval': 2,
      'reconnect': '',
      'timeout': 2
    }); //Advice(interval: 2, reconnect: '', timeout: 2);
    expect(advice, Advice(interval: 2, reconnect: '', timeout: 2));
  });

  group('Message', () {
    test('fromJson', () {
      final message = Message.fromJson(
        {'channel': 'bayeuxChannel'},
      );
      expect(message, Message("bayeuxChannel", channel: Channel(name: "hey")));
    });

    test('bayeuxChannel equals handshake_channel', () {
      final version = '1.0';
      final minimumVersion = '1.0';
      final supportedConnectionTypes = ['websocket'];
      var channel = Channel(name: "hey");
      final ext = channel.ext;

      final message = Message("/meta/handshake", channel: channel);
      expect(message.version, version);
      expect(message.minimumVersion, minimumVersion);
      expect(message.supportedConnectionTypes, supportedConnectionTypes);
      expect(message.ext, ext);
    });
  });
}
