import 'dart:async';
import 'package:uuid/uuid.dart';

class TimeoutHelper {
  final _uuid = const Uuid();
  late final _timers = <String, Timer>{};

  String setTimeout(Duration duration, void Function() callback) {
    final id = _uuid.v1();
    final timer = Timer(duration, callback);
    _timers[id] = timer;
    return id;
  }

  void cancelTimeout(String id) {
    final timer = _timers.remove(id);
    return timer?.cancel();
  }

  void cancelAllTimeout() {
    for (final t in _timers.values) {
      t.cancel();
    }
    _timers.clear();
  }

  bool get hasTimeouts => _timers.isNotEmpty;
}
