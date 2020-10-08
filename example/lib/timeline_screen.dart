import 'package:flutter/material.dart';
import 'package:stream_feed_dart/stream_feed.dart';

import 'activity_item.dart';
import 'main.dart';

class TimelineScreen extends StatefulWidget {
  final User streamUser;

  const TimelineScreen({Key key, @required this.streamUser}) : super(key: key);

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final _client = locator<StreamClient>();
  bool _isLoading = true;
  List<Activity> activities = <Activity>[];

  Future<void> _loadActivities({bool pullToRefresh = false}) async {
    if (!pullToRefresh) setState(() => _isLoading = true);
    final userFeed = _client.flatFeed('timeline', widget.streamUser.id);
    final data = await userFeed.getActivities();
    if (!pullToRefresh) _isLoading = false;
    setState(() => activities = data);
  }

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _loadActivities(pullToRefresh: true),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : activities.isEmpty
                ? Column(
                    children: [
                      Text('No activities yet!'),
                      RaisedButton(
                        onPressed: _loadActivities,
                        child: Text('Reload'),
                      )
                    ],
                  )
                : ListView.separated(
                    itemCount: activities.length,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, index) {
                      final activity = activities[index];
                      return ActivityCard(activity: activity);
                    },
                  ),
      ),
    );
  }
}
