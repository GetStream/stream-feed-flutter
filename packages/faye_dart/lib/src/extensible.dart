import 'dart:collection';

import 'message.dart';

typedef MessageHandler = Message Function(Message message);

class Extensible {
  late final _extensions = Queue<Map<String, MessageHandler>>();

  void addExtension(Map<String, MessageHandler> extension) =>
      addExtensions([extension]);

  void addExtensions(Iterable<Map<String, MessageHandler>> extensions) =>
      _extensions.addAll(extensions);

  void removeExtension(Map<String, MessageHandler> extension) {
    if (_extensions.isEmpty) return;
    _extensions.remove(extension);
  }

  void pipeThroughExtensions(
    String stage,
    Message message,
    void Function(Message message) callback,
  ) {
    if (_extensions.isEmpty) return callback(message);
    var extensions = Queue<Map<String, MessageHandler>>.from(_extensions);
    void pipe(Message message) {
      if (extensions.isEmpty) return callback(message);
      var extension = extensions.removeFirst();
      final fn = extension[stage];
      if (fn == null) return pipe(message);
      final modifiedMessage = fn(message);
      pipe(modifiedMessage);
    }

    pipe(message);
  }
}
