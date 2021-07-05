import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:rxdart/rxdart.dart';

class RealtimeMessageBloc<T> extends StatefulWidget {
  /// Instantiate a new [RealtimeMessages$Bloc]. The parameter [child] must be supplied and
  /// not null.
  const RealtimeMessageBloc({
    required this.child,
    required this.feed,
    Key? key,
  }) : super(key: key);

  /// The widget child
  final Widget child;

  final Feed feed;

  @override
  RealtimeMessageBlocState<T> createState() => RealtimeMessageBlocState<T>();

  /// Use this method to get the current [RealtimeMessageBlocState] instance
  static RealtimeMessageBlocState<T> of<T>(BuildContext context) {
    RealtimeMessageBlocState<T>? state;

    state = context.findAncestorStateOfType<RealtimeMessageBlocState<T>>();

    if (state == null) {
      throw Exception('You must have a RealtimeMessageBloc widget as ancestor');
    }

    return state;
  }
}

/// The current state of the [RealtimeMessageBloc]
class RealtimeMessageBlocState<T> extends State<RealtimeMessageBloc>
    with AutomaticKeepAliveClientMixin {
  /// The current real time messages list
  List<EnrichedActivity> get rtMessages => _realtimeAddsController.value;

  /// The current real time messages list as a stream
  Stream<List<EnrichedActivity>> get rtMessagesSream =>
      _realtimeAddsController.stream;

  int get unseen => _unseenController.value;
  int get unread => _unreadController.value;
  // List<String> get realtimeDeletes => _realtimeDeletesController.value;

  final _unseenController = BehaviorSubject.seeded(0);
  final _unreadController = BehaviorSubject.seeded(0);
  final _realtimeDeletesController = BehaviorSubject.seeded(<String>[]);
  final _realtimeAddsController = BehaviorSubject.seeded(<EnrichedActivity>[]);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  Future<void> subscribe() async {
    await widget.feed.subscribe((data) {
      final numActivityDiff = data!.newActivities.length - data.deleted.length;
      _realtimeAddsController.add(data.newActivities);
      _realtimeDeletesController.add(data.deleted);
      if (widget.feed is NotificationFeed) {
        _unreadController.add(data.unread! + numActivityDiff);
      }
      if (widget.feed is NotificationFeed) {
        _unseenController.add(data.unseen! + numActivityDiff);
      }
    });
  }

  @override
  void dispose() {
    _realtimeAddsController.close();
    _unseenController.close();
    _unseenController.close();
    _realtimeDeletesController.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
