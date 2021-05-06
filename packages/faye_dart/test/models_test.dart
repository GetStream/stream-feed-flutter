import 'package:faye_dart/src/message.dart';
import 'package:test/test.dart';

main() {
  group('Advice', () {
    final json = {'interval': 2, 'reconnect': '', 'timeout': 2};
    final advice = Advice(interval: 2, reconnect: '', timeout: 2);
    test('fromJson', () {
      final adviceFromJson = Advice.fromJson(json);
      expect(adviceFromJson, advice);
    });

    test('toJson', () {
      expect(advice.toJson(), json);
    });
  });

  group('Message', () {
    final data = {
      "id": "test",
      "group": "test",
      "activities": [
        {
          "id": "test",
          "actor": "test",
          "verb": "test",
          "object": "test",
          "foreign_id": "test",
          "target": "test",
          "time": "2001-09-11T00:01:02.000",
          "origin": "test",
          "to": ["slug:id"],
          "score": 1.0,
          "analytics": {"test": "test"},
          "extra_context": {"test": "test"},
          "test": "test"
        }
      ],
      "actor_count": 1,
      "created_at": "2001-09-11T00:01:02.000",
      "updated_at": "2001-09-11T00:01:02.000"
    };
    final json = {
      'channel': 'bayeuxChannel',
      'data': data,
      'supportedConnectionTypes': ['websocket']
    };

    final message = Message(
      "bayeuxChannel",
      data: data,
      supportedConnectionTypes: ['websocket'],
    );
    test('fromJson', () {
      expect(Message.fromJson(json), message);
    });

    test('toJson', () {
      expect(message.toJson(), json);
    });
  });
}
