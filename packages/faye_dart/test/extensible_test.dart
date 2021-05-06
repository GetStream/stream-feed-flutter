import 'package:faye_dart/src/extensible.dart';
import 'package:faye_dart/src/message.dart';
import 'package:test/test.dart';

void main() {
  test('addExtension', () {
    final extensible = Extensible();
    const messageId = 'messageId1';
    final message = Message('dummyChannel')..id = messageId;

    const newMessageId = 'messageId2';
    extensible.addExtension(<String, MessageHandler>{
      'outgoing': (message) => message..id = newMessageId,
    });

    late Message newMessage;
    extensible.pipeThroughExtensions('outgoing', message, (message) {
      newMessage = message;
    });

    expect(newMessage.id, isNot(messageId));
  });

  test('removeExtension', () {
    final extensible = Extensible();
    const messageId = 'messageId1';
    final message = Message('dummyChannel')..id = messageId;

    const newMessageId = 'messageId2';
    final extension = <String, MessageHandler>{
      'outgoing': (message) => message..id = newMessageId,
    };

    // adding extension
    extensible.addExtension(extension);
    // removing extension
    extensible.removeExtension(extension);

    late Message newMessage;
    extensible.pipeThroughExtensions('outgoing', message, (message) {
      newMessage = message;
    });

    expect(newMessage.id, messageId);
  });
}
