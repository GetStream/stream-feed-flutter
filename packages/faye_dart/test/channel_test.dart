import 'package:faye_dart/src/channel.dart';
import 'package:faye_dart/src/message.dart';
import 'package:test/test.dart';

main() {
  test('Channel', () {
    var _ext = {
      "api_key": 'Client.shared.apiKey',
      "signature": 'Client.shared.token',
      "user_id": 'notificationChannelName',
    };
    var _name = "name";
    final channel = Channel(
      name: _name,
    )..ext = _ext;

    final logs = [];
    channel.addListener('event', (data) {
      logs.add(data);
    });
    expect(channel.mounted, true);
    expect(channel.hasListeners('event'), true);
    var message = Message("bayeuxChannel");
    channel.emit('event', message);
    expect(logs, [message]);
    expect(channel.ext, _ext);
    expect(channel.name, "/$_name");
    // expect(channel.subscription, matcher)
  });
}
