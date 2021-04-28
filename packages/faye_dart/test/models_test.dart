import 'package:faye_dart/src/message.dart';
import 'package:test/test.dart';

main() {
  group('Advice', () {
    final json = {'interval': 2, 'reconnect': '', 'timeout': 2};
    final advice = Advice(interval: 2, reconnect: '', timeout: 2);
    test('fromJson', () {
      final adviceFromJson = Advice.fromJson(
          json); //Advice(interval: 2, reconnect: '', timeout: 2);
      expect(adviceFromJson, advice);
    });

    test('toJson', () {
      expect(advice.toJson(), json);
    });
  });

  group('Message', () {
    test('fromJson', () {
      var data = {
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
      final message = Message.fromJson(
        {'channel': 'bayeuxChannel', 'data': data},
      );
      expect(message, Message("bayeuxChannel", data: data));
    });
  });
}
