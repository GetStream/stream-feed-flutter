import 'package:example/activity_item.dart';
import 'package:example/add_activity_dialog.dart';
import 'package:example/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';

//ignore: public_member_api_docs
class ProfileScreen extends StatefulWidget {
  //ignore: public_member_api_docs
  const ProfileScreen({
    required this.currentUser,
    Key? key,
  }) : super(key: key);

  //ignore: public_member_api_docs
  final StreamUser currentUser;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<StreamUser>('currentUser', currentUser));
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  late StreamFeedClient _client;
  bool _isLoading = true;

  List<Activity> activities = <Activity>[];

  Future<void> _loadActivities({bool pullToRefresh = false}) async {
    if (!pullToRefresh) setState(() => _isLoading = true);

    final userFeed = _client.flatFeed('user', widget.currentUser.id);
    final data = await userFeed.getActivities();
    if (!pullToRefresh) _isLoading = false;
    setState(() => activities = data);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = context.client;
    _loadActivities();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.currentUser;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final message = await showDialog<String>(
            context: context,
            builder: (_) => const AddActivityDialog(),
          );
          if (message != null) {
            context.showSnackBar('Posting Activity...');

            final activity = Activity(
              actor: user.ref,
              verb: 'tweet',
              object: '1',
              extraData: {'tweet': message},
            );

            final userFeed = _client.flatFeed('timeline', user.id);
            await userFeed.addActivity(activity);

            context.showSnackBar('Activity Posted...');
            _loadActivities();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () => _loadActivities(pullToRefresh: true),
          child: _isLoading
              ? const CircularProgressIndicator()
              : activities.isEmpty
                  ? const Text('No activities yet!')
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
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Activity>('activities', activities));
  }
}
//Shared an update Just now
