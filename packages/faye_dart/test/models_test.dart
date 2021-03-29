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
}
