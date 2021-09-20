import 'package:faye_dart/src/channel.dart';
import 'package:faye_dart/src/message.dart';
import 'package:faye_dart/src/subscription.dart';
import 'package:test/test.dart';

import 'mock.dart';

void main() {
  group('channel', () {
    test('channels should be equal if name is same', () {
      final channelOne = Channel('id');
      final channelTwo = Channel('id');
      expect(channelOne, channelTwo);
    });

    test('expand returns all patterns that match a channel",', () {
      expect(
        ['/**', '/foo', '/*'],
        Channel.expand('/foo'),
      );
      expect(
        ['/**', '/foo/bar', '/foo/*', '/foo/**'],
        Channel.expand('/foo/bar'),
      );
      expect(
        ['/**', '/foo/bar/qux', '/foo/bar/*', '/foo/**', '/foo/bar/**'],
        Channel.expand('/foo/bar/qux'),
      );
    });

    test('channel should be subscribable', () {
      const channelName = '/fo_o/\$@()bar';
      expect(Channel.isSubscribable(channelName), isTrue);
    });

    test('meta channels should not be subscribable', () {
      const channelName = '/meta/fo_o/\$@()bar';
      expect(Channel.isSubscribable(channelName), isFalse);
    });

    test('service channels should not be subscribable', () {
      const channelName = '/service/fo_o/\$@()bar';
      expect(Channel.isSubscribable(channelName), isFalse);
    });
  });

  group('channel map', () {
    test('subscribes and un-subscribes', () {
      final client = MockClient();
      final channels = <String, Channel>{};
      const channel = '/foo/**';
      final subscription = Subscription(client, channel);
      channels.subscribe(channel, subscription);

      expect(channels.contains(channel), isTrue);
      expect(channels.unsubscribe(channel, subscription), isTrue);
    });

    test(
      'distribute message should invoke channel subscription callback',
      () {
        final client = MockClient();
        final channels = <String, Channel>{};
        const channel = '/foo/**';

        var callbackInvoked = false;
        final subscription = Subscription(client, channel, callback: (_) {
          callbackInvoked = true;
        });
        channels.subscribe(channel, subscription);

        final message = Message(channel);
        channels.distributeMessage(message);

        expect(callbackInvoked, isTrue);
      },
    );
  });
}
