import 'package:faye_dart/src/channel.dart';
import 'package:faye_dart/src/message.dart';
import 'package:test/test.dart';

main() {
  group('Channel', () {
    test('event listener', () {
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
      var listener = (data) {
        logs.add(data);
      };
      channel.addListener('event', listener);
      expect(channel.mounted, true);
      var event = 'event';
      expect(channel.hasListeners(event), true);
      var message = Message("bayeuxChannel");
      channel.emit('event', message);
      expect(logs, [message]);
      expect(channel.ext, _ext);
      expect(channel.name, "/$_name");
      channel.removeListener('event', listener);
      expect(channel.hasListeners(event), false);
    });

    test('subscription', () {
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
      var listener = (data) {
        logs.add(data);
      };
      channel.bind('event', listener);
      expect(channel.mounted, true);
      var event = 'event';
      expect(channel.hasListeners(event), true);
      var message = Message("bayeuxChannel");
      channel.trigger('event', message);
      expect(logs, [message]);
      expect(channel.ext, _ext);
      expect(channel.name, "/$_name");
      channel.unbind('event', listener);
      expect(channel.hasListeners(event), false);
    });
  });
}
