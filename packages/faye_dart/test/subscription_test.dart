import 'package:faye_dart/src/message.dart';
import 'package:faye_dart/src/subscription.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'mock.dart';

void main() {
  group('subscription', () {
    test('successfully invokes the callback', () {
      final client = MockClient();
      const channel = '/foo/**';
      var callbackInvoked = false;
      final subscription = Subscription(
        client,
        channel,
        callback: (data) => callbackInvoked = true,
      );

      final message = Message(channel);
      subscription(message);

      expect(callbackInvoked, isTrue);
    });

    test('successfully invokes withChannel callback if provided', () {
      final client = MockClient();
      const channel = '/foo/**';
      var callbackInvoked = false;
      var withChannelCallbackInvoked = false;
      final subscription = Subscription(
        client,
        channel,
        callback: (data) => callbackInvoked = true,
      );

      // ignore: cascade_invocations
      subscription.withChannel(
        (channel, data) => withChannelCallbackInvoked = true,
      );

      final message = Message(channel);
      subscription(message);

      expect(callbackInvoked, isTrue);
      expect(withChannelCallbackInvoked, isTrue);
    });

    test('successfully cancels the subscription', () {
      final client = MockClient();
      const channel = '/foo/**';

      final subscription = Subscription(client, channel, callback: (data) {});

      when(() => client.unsubscribe(channel, subscription)).thenReturn(() {});

      subscription.cancel();

      verify(() => client.unsubscribe(channel, subscription)).called(1);
    });
  });
}
