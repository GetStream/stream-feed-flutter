import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

abstract class Event {}

abstract class State {}

class IncreaseEvent extends Event {}

class CounterState extends State {
  final int count;
  CounterState({this.count = 0});
}

class CounterBloc {
  final _eventController = BehaviorSubject<Event>();
  final _stateController = BehaviorSubject.seeded(CounterState());

  CounterBloc();
  Stream<Event> get eventsStream => _eventController.stream;
  Event get event => _eventController.value;
  Stream<State> get stateStream => _stateController.stream;
  CounterState? get state => _stateController.valueOrNull;
  int get count => state!.count;

  void close() {
    _eventController.close();
    _stateController.close();
  }

  void increase(Event event) {
    if (event is IncreaseEvent) {
      _stateController.value = CounterState(count: count + 1);
    }
  }
}

main() {
  test('bloc', () {
    final bloc = CounterBloc();
    expect(bloc.count, 0);
    bloc.increase(IncreaseEvent());
    expect(bloc.count, 1);
  });
}
