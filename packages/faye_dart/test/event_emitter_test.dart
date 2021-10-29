// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:faye_dart/src/event_emitter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  test('`on` should emit until removed', () {
    final eventEmitter = EventEmitter<String>();
    const event = 'click';
    String? emittedData;
    eventEmitter.on(event, (data) => emittedData = data);

    // emitted once
    eventEmitter.emit(event, 'A');

    expect(emittedData, isNotNull);
    expect(emittedData, 'A');

    // emitted twice
    eventEmitter.emit(event, 'B');
    expect(emittedData, 'B');

    // emitted thrice
    eventEmitter.emit(event, 'C');
    expect(emittedData, 'C');
  });

  test('`once` should emit only once', () {
    final eventEmitter = EventEmitter<String>();
    const event = 'click';
    String? emittedData;
    eventEmitter.once(event, (data) => emittedData = data);

    // emitted once
    eventEmitter.emit(event, 'A');

    expect(emittedData, isNotNull);
    expect(emittedData, 'A');

    // emitted twice
    eventEmitter.emit(event, 'B');
    expect(emittedData, 'A');
    expect(emittedData, isNot('B'));
  });

  test('`removeListener` should remove the listener', () {
    final eventEmitter = EventEmitter<String>();
    const event = 'click';
    String? emittedData;
    void listener(String data) => emittedData = data;
    eventEmitter.on(event, listener);

    // emitted once
    eventEmitter.emit(event, 'A');

    expect(emittedData, isNotNull);
    expect(emittedData, 'A');

    // removed listener
    eventEmitter.removeListener(event, listener);

    // emitted twice
    eventEmitter.emit(event, 'B');
    expect(emittedData, 'A');
    expect(emittedData, isNot('B'));
  });

  test('`off` should remove all the listener of a particular event', () {
    final eventEmitter = EventEmitter<String>();
    const event = 'click';
    String? emittedDataOne;
    String? emittedDataTwo;
    void listenerOne(String data) => emittedDataOne = data;
    void listenerTwo(String data) => emittedDataTwo = data;
    eventEmitter.on(event, listenerOne);
    eventEmitter.on(event, listenerTwo);

    // emitted once
    eventEmitter.emit(event, 'A');

    expect(emittedDataOne, isNotNull);
    expect(emittedDataOne, 'A');
    expect(emittedDataTwo, isNotNull);
    expect(emittedDataTwo, 'A');

    // removed listener
    eventEmitter.off(event);

    // emitted twice
    eventEmitter.emit(event, 'B');
    expect(emittedDataOne, 'A');
    expect(emittedDataOne, isNot('B'));
    expect(emittedDataTwo, 'A');
    expect(emittedDataTwo, isNot('B'));
  });

  test('`removeAllListeners` should remove all the listener of all events', () {
    final eventEmitter = EventEmitter<String>();
    const clickEvent = 'click';
    const touchEvent = 'touch';
    String? clickData;
    String? touchData;
    void clickListener(String data) => clickData = data;
    void touchListener(String data) => touchData = data;
    eventEmitter.on(clickEvent, clickListener);
    eventEmitter.on(touchEvent, touchListener);

    // emitted once
    eventEmitter.emit(clickEvent, 'A');
    eventEmitter.emit(touchEvent, 'A');

    expect(clickData, isNotNull);
    expect(clickData, 'A');
    expect(touchData, isNotNull);
    expect(touchData, 'A');

    // removed listener
    eventEmitter.removeAllListeners();

    // emitted twice
    eventEmitter.emit(clickEvent, 'B');
    eventEmitter.emit(touchEvent, 'B');

    expect(clickData, 'A');
    expect(clickData, isNot('B'));
    expect(touchData, 'A');
    expect(touchData, isNot('B'));
  });

  test('`hasListeners` should work correctly', () {
    final eventEmitter = EventEmitter<String>();
    const clickEvent = 'click';
    eventEmitter.on(clickEvent, (_) {});

    expect(eventEmitter.hasListeners(clickEvent), isTrue);

    eventEmitter.off(clickEvent);

    expect(eventEmitter.hasListeners(clickEvent), isFalse);
  });

  test('should throw stateError if used after dispose is called', () {
    final eventEmitter = EventEmitter<String>();
    const clickEvent = 'click';
    String? clickData;
    eventEmitter.on(clickEvent, (data) => clickData = data);

    // emitting once
    eventEmitter.emit(clickEvent, 'A');
    expect(clickData, isNotNull);
    expect(clickData, 'A');

    // disposing emitter
    eventEmitter.dispose();

    expect(eventEmitter.mounted, isFalse);
    expect(
      () => eventEmitter.emit(clickEvent, 'B'),
      throwsA(isA<StateError>()),
    );
  });

  test('onError (initial)', () {
    final onError = ErrorListener();
    final eventEmitter = EventEmitter<String>()..onError = onError;

    verifyZeroInteractions(onError);

    const clickEvent = 'click';
    final error = Error();
    eventEmitter.on(clickEvent, (_) => throw error);

    expect(() => eventEmitter.emit(clickEvent, 'A'), throwsA(isA<Error>()));

    verify(() => onError(error, any(that: isNotNull))).called(1);
    verifyNoMoreInteractions(onError);
  });

  test('no onError fallbacks to zone', () {
    final eventEmitter = EventEmitter<String>();
    const clickEvent = 'click';
    eventEmitter.on(clickEvent, (_) => throw StateError('error'));

    final errors = <Object>[];
    runZonedGuarded(
      () => eventEmitter.emit(clickEvent, 'A'),
      (err, stack) => errors.add(err),
    );
    expect(errors, [
      isStateError.having((s) => s.message, 'message', 'error'),
      isA<Error>(),
    ]);
  });
}

class ErrorListener extends Mock {
  void call(Object error, StackTrace? stackTrace);
}
