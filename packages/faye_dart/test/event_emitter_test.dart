import 'package:faye_dart/src/event_emitter.dart';
import 'package:test/test.dart';

main() {
  test('EventEmitter', () {
    final eventEmitter = EventEmitter();
    final logs = [];
    eventEmitter.addListener('event', (data) {
      addToLogs(logs, data);
    });
    expect(eventEmitter.mounted, true);
    expect(eventEmitter.hasListeners('event'), true);
    eventEmitter.emit('event', 'data');
    expect(logs, ['data']);
  });
}

void addToLogs(List<dynamic> logs, data) {
  logs.add(data);
}
