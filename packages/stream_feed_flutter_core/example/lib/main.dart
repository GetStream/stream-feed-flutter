import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// Complete Tutorial: https://getstream.io/activity-feeds/sdk/flutter/tutorial/
const tutorialUrl = 'https://getstream.io/activity-feeds/sdk/flutter/tutorial/';

Future<void> main() async {
  const apiKey = 'q29npdvqjr99'; // Replace with your API key.
  final client = StreamFeedClient(apiKey);

  runApp(
    MyApp(client: client),
  );
}

/// Main sample application entry point.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamFeedClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => FeedProvider(
        bloc: FeedBloc(
          client: client,
        ),
        child: child!,
      ),
      home: const SelectUserPage(),
    );
  }
}

/// A class for demonstration purposes, to allow hardcoded users and tokens.
class DemoUser {
  final User user;
  final Token token;

  const DemoUser({
    required this.user,
    required this.token,
  });
}

/// List of hardcoded [DemoUser]s.
///
/// Do not hardcode [Token]s in a production environment. See our
/// [documentation on user tokens](https://getstream.io/activity-feeds/docs/flutter-dart/auth_and_permissions/?language=dart#user-tokens).
///
/// You can generate a token using any of our [backend SDKs](https://getstream.io/chat/sdk/#backend-clients),
/// manually using our [online token generator](https://getstream.io/chat/docs/react/token_generator/),
/// or using the [stream-cli](https://github.com/GetStream/stream-cli).
const demoUsers = [
  DemoUser(
    user: User(
      id: 'sachaarbonel',
      data: {
        'handle': '@sachaarbonel',
        'first_name': 'Sacha',
        'last_name': 'Arbonel',
        'full_name': 'Sacha Arbonel',
        'profile_image': 'https://avatars.githubusercontent.com/u/18029834?v=4',
      },
    ),
    token: Token(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FjaGFhcmJvbmVsIn0.P61gSErNtvGk1BK3EYGzC3z1ZNJLXV7blcGiBuyi-DI'),
  ),
  DemoUser(
    user: User(
      id: 'GroovinChip',
      data: {
        'handle': '@GroovinChip',
        'first_name': 'Reuben',
        'last_name': 'Turner',
        'full_name': 'Reuben Turner',
        'profile_image': 'https://avatars.githubusercontent.com/u/4250470?v=4',
      },
    ),
    token: Token(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiR3Jvb3ZpbkNoaXAifQ.CUifllzvz7s41imbCnyoGyOsLpRyQk-MA5Zu0oUbIIk'),
  ),
  DemoUser(
    user: User(
      id: 'gordonphayes',
      data: {
        'handle': '@gordonphayes',
        'first_name': 'Gordon',
        'last_name': 'Hayes',
        'full_name': 'Gordon Hayes',
        'profile_image': 'https://avatars.githubusercontent.com/u/13705472?v=4',
      },
    ),
    token: Token(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiZ29yZG9ucGhheWVzIn0.4VaMAj8XkYMYt1JzeNxRZcuGwBSZ9gJ1Us5Jn7SImm0'),
  ),
];

/// An extension method on Stream's [User] class - to easily access user data
/// properties used in this sample application.
extension UserData on User {
  String get handle => data?['handle'] as String? ?? '';
  String get firstName => data?['first_name'] as String? ?? '';
  String get lastName => data?['last_name'] as String? ?? '';
  String get fullName => data?['full_name'] as String? ?? '';
  String get profileImage => data?['profile_image'] as String? ?? '';
}

/// Page to connect as one of the [DemoUser]s.
class SelectUserPage extends StatelessWidget {
  const SelectUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select user')),
      body: ListView(
        children: demoUsers
            .map(
              (demoUser) => UserTile(
                user: demoUser.user,
                onTap: () async {
                  try {
                    // Connect user
                    await context.feedClient
                        .setUser(demoUser.user, demoUser.token);
                    // Follow own user feed. This ensures the current user's
                    // posts are visible on their "timeline" feed.
                    await context.feedBloc.followFeed(
                      followerFeedGroup: 'timeline',
                      followeeFeedGroup: 'user',
                      followeeId: demoUser.user.id!,
                    );
                    // Navigate to the home page if user connected successfully
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const HomePage(),
                      ),
                    );
                  } on Exception catch (e, st) {
                    log(
                      'Could not connect user. See the tutorial for more details: $tutorialUrl',
                      error: e,
                      stackTrace: st,
                    );
                  }
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

/// UI widget to display a [User]'s profile picture and name.
///
/// Optional: [onTap] callback and [trailing] widget.
class UserTile extends StatelessWidget {
  const UserTile({
    Key? key,
    required this.user,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  final User user;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(user.profileImage)),
      title: Text(user.fullName),
      onTap: onTap,
      trailing: trailing,
    );
  }
}

/// Home page of the sample application.
///
/// Provides navigation to the rest of the app through a [PageView].
///
/// Pages:
/// - [TimelinePage] (default)
/// - [ProfilePage]
/// - [PeoplePage]
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          TimelinePage(),
          ProfilePage(),
          PeoplePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          _pageController.jumpToPage(value);
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.timeline), label: 'timeline'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'people'),
        ],
      ),
    );
  }
}

/// Page that displays the "timeline" Stream feed group.
///
/// This is a combination of your activities, and the users you follow.
///
/// Displays your reactions, and reaction counts.
class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final EnrichmentFlags _flags = EnrichmentFlags()
    ..withReactionCounts()
    ..withOwnReactions();

  bool _isPaginating = false;

  static const _feedGroup = 'timeline';

  Future<void> _loadMore() async {
    // Ensure we're not already loading more activities.
    if (!_isPaginating) {
      _isPaginating = true;
      context.feedBloc
          .loadMoreEnrichedActivities(feedGroup: _feedGroup, flags: _flags)
          .whenComplete(() {
        _isPaginating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = context.feedClient;
    return Scaffold(
      appBar: AppBar(title: const Text('Timeline')),
      body: FlatFeedCore(
        feedGroup: _feedGroup,
        userId: client.currentUser!.id,
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        emptyBuilder: (context) => const Center(child: Text('No activities')),
        errorBuilder: (context, error) => Center(
          child: Text(error.toString()),
        ),
        limit: 10,
        flags: _flags,
        feedBuilder: (
          BuildContext context,
          activities,
        ) {
          return RefreshIndicator(
            onRefresh: () {
              return context.feedBloc.refreshPaginatedEnrichedActivities(
                feedGroup: _feedGroup,
                flags: _flags,
              );
            },
            child: ListView.separated(
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                bool shouldLoadMore = activities.length - 3 == index;
                if (shouldLoadMore) {
                  _loadMore();
                }
                return ListActivityItem(
                  activity: activities[index],
                  feedGroup: _feedGroup,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (context) => const ComposeActivityPage()),
          );
        },
        tooltip: 'Add Activity',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Page that displays the "user" Stream feed group.
///
/// A list of the activities that you've posted.
///
/// Displays your reactions, and reaction counts.
class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final EnrichmentFlags _flags = EnrichmentFlags()
    ..withReactionCounts()
    ..withOwnReactions();

  bool _isPaginating = false;

  static const _feedGroup = 'user';

  Future<void> _loadMore() async {
    // Ensure we're not already loading more activities.
    if (!_isPaginating) {
      _isPaginating = true;
      context.feedBloc
          .loadMoreEnrichedActivities(feedGroup: _feedGroup, flags: _flags)
          .whenComplete(() {
        _isPaginating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = context.feedClient;
    return Scaffold(
      appBar: AppBar(title: const Text('Your posts')),
      body: FlatFeedCore(
        feedGroup: _feedGroup,
        userId: client.currentUser!.id,
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        emptyBuilder: (context) => const Center(child: Text('No activities')),
        errorBuilder: (context, error) => Center(
          child: Text(error.toString()),
        ),
        limit: 10,
        flags: _flags,
        feedBuilder: (
          BuildContext context,
          activities,
        ) {
          return RefreshIndicator(
            onRefresh: () {
              return context.feedBloc.refreshPaginatedEnrichedActivities(
                feedGroup: _feedGroup,
                flags: _flags,
              );
            },
            child: ListView.separated(
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                bool shouldLoadMore = activities.length - 3 == index;
                if (shouldLoadMore) {
                  _loadMore();
                }
                return ListActivityItem(
                  activity: activities[index],
                  feedGroup: _feedGroup,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (context) => const ComposeActivityPage()),
          );
        },
        tooltip: 'Add Activity',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// UI widget to display an activity/post.
///
/// Shows the number of likes and comments.
///
/// Enables the current [User] to like the activity, and view comments.
class ListActivityItem extends StatelessWidget {
  const ListActivityItem({
    Key? key,
    required this.activity,
    required this.feedGroup,
  }) : super(key: key);

  final EnrichedActivity activity;
  final String feedGroup;

  @override
  Widget build(BuildContext context) {
    final actor = activity.actor!;
    final attachments = (activity.extraData)?.toAttachments();
    final reactionCounts = activity.reactionCounts;
    final ownReactions = activity.ownReactions;
    final isLikedByUser = (ownReactions?['like']?.length ?? 0) > 0;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(actor.profileImage),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Text(actor.fullName),
            const SizedBox(width: 8),
            Text(
              actor.handle,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('${activity.object}'),
          ),
          if (attachments != null && attachments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(attachments[0].url),
            ),
          Row(
            children: [
              Row(
                children: [
                  IconButton(
                    iconSize: 16,
                    onPressed: () {
                      if (isLikedByUser) {
                        context.feedBloc.onRemoveReaction(
                          kind: 'like',
                          activity: activity,
                          reaction: ownReactions!['like']![0],
                          feedGroup: feedGroup,
                        );
                      } else {
                        context.feedBloc.onAddReaction(
                            kind: 'like',
                            activity: activity,
                            feedGroup: feedGroup);
                      }
                    },
                    icon: isLikedByUser
                        ? const Icon(Icons.favorite_rounded)
                        : const Icon(Icons.favorite_outline),
                  ),
                  if (reactionCounts?['like'] != null)
                    Text(
                      '${reactionCounts?['like']}',
                      style: Theme.of(context).textTheme.caption,
                    )
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  IconButton(
                    iconSize: 16,
                    onPressed: () => _navigateToCommentPage(context),
                    icon: const Icon(Icons.mode_comment_outlined),
                  ),
                  if (reactionCounts?['comment'] != null)
                    Text(
                      '${reactionCounts?['comment']}',
                      style: Theme.of(context).textTheme.caption,
                    )
                ],
              )
            ],
          )
        ],
      ),
      onTap: () {
        _navigateToCommentPage(context);
      },
    );
  }

  void _navigateToCommentPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => CommentsPage(
          activity: activity,
        ),
      ),
    );
  }
}

/// A page to compose a new [Activity]/post.
///
/// - feed: "user"
/// - verb: "post"
/// - object: "text data"
/// - data: media
///
/// [More information](https://getstream.io/activity-feeds/docs/flutter-dart/adding_activities/?language=dart) on activities.
class ComposeActivityPage extends StatefulWidget {
  const ComposeActivityPage({Key? key}) : super(key: key);

  @override
  State<ComposeActivityPage> createState() => _ComposeActivityPageState();
}

class _ComposeActivityPageState extends State<ComposeActivityPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  /// "Post" a new activity to the "user" feed group.
  Future<void> _post() async {
    final uploadController = context.feedUploadController;
    final media = uploadController.getMediaUris()?.toExtraData();
    if (_textEditingController.text.isNotEmpty) {
      await context.feedBloc.onAddActivity(
        feedGroup: 'user',
        verb: 'post',
        object: _textEditingController.text,
        data: media,
      );
      uploadController.clear();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot post with no message')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compose'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ActionChip(
              label: const Text(
                'Post',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              backgroundColor: Colors.white,
              onPressed: _post,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textEditingController,
                  decoration:
                      const InputDecoration(hintText: "What's on your mind"),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? image = await _picker.pickImage(
                        source: ImageSource.gallery,
                        maxHeight: 600,
                        maxWidth: 300,
                        imageQuality: 50,
                      );

                      if (image != null) {
                        await context.feedUploadController
                            .uploadImage(AttachmentFile(path: image.path));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cancelled')));
                      }
                    },
                    icon: const Icon(Icons.file_copy),
                  ),
                  Text(
                    'Add image',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              UploadListCore(
                uploadController: context.feedUploadController,
                loadingBuilder: (context) =>
                    const Center(child: CircularProgressIndicator()),
                uploadsErrorBuilder: (error) =>
                    Center(child: Text(error.toString())),
                uploadsBuilder: (context, uploads) {
                  return SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: uploads.length,
                      itemBuilder: (context, index) => FileUploadStateWidget(
                          fileState: uploads[index],
                          onRemoveUpload: (attachment) {
                            return context.feedUploadController
                                .removeUpload(attachment);
                          },
                          onCancelUpload: (attachment) {
                            return context.feedUploadController
                                .cancelUpload(attachment);
                          },
                          onRetryUpload: (attachment) async {
                            return context.feedUploadController
                                .uploadImage(attachment);
                          }),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Page that displays all [User]s, enabling the current user to
/// follow/unfollow specific users.
class PeoplePage extends StatelessWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('People')),
      body: ListView(
        children: demoUsers
            .where((element) {
              return element.user.id != context.feedBloc.currentUser!.id;
            })
            .map((demoUser) => FollowUserTile(user: demoUser.user))
            .toList(),
      ),
    );
  }
}

/// A UI widget that displays a [User] tile to follow/unfollow.
class FollowUserTile extends StatefulWidget {
  const FollowUserTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<FollowUserTile> createState() => _FollowUserTileState();
}

class _FollowUserTileState extends State<FollowUserTile> {
  bool _isFollowing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkIfFollowing();
  }

  Future<void> _checkIfFollowing() async {
    final result =
        await context.feedBloc.isFollowingFeed(followerId: widget.user.id!);
    _setStateFollowing(result);
  }

  Future<void> _follow() async {
    try {
      _setStateFollowing(true);
      await context.feedBloc.followFeed(followeeId: widget.user.id!);
    } on Exception catch (e, st) {
      _setStateFollowing(false);
      log(
        'Could not follow user, see the tutorial for help: $tutorialUrl',
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> _unfollow() async {
    try {
      _setStateFollowing(false);
      context.feedBloc.unfollowFeed(unfolloweeId: widget.user.id!);
    } on Exception catch (e, st) {
      _setStateFollowing(true);
      log(
        'Could not unfollow user, see the tutorial for help: $tutorialUrl',
        error: e,
        stackTrace: st,
      );
    }
  }

  void _setStateFollowing(bool following) {
    setState(() {
      _isFollowing = following;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserTile(
      user: widget.user,
      trailing: TextButton(
        onPressed: () {
          if (_isFollowing) {
            _unfollow();
          } else {
            _follow();
          }
        },
        child: _isFollowing ? const Text('unfollow') : const Text('follow'),
      ),
    );
  }
}

/// A page that displays all [Reaction]s/comments for a specific
/// [Activity]/Post.
///
/// Enabling the current [User] to add comments and like other reactions.
class CommentsPage extends StatefulWidget {
  const CommentsPage({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final EnrichedActivity activity;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  bool _isPaginating = false;

  final EnrichmentFlags _flags = EnrichmentFlags()..withOwnChildren();

  Future<void> _loadMore() async {
    // Ensure we're not already loading more reactions.
    if (!_isPaginating) {
      _isPaginating = true;
      context.feedBloc
          .loadMoreReactions(widget.activity.id!, flags: _flags)
          .whenComplete(() {
        _isPaginating = false;
      });
    }
  }

  Future<void> _addOrRemoveLike(Reaction reaction) async {
    final isLikedByUser = (reaction.ownChildren?['like']?.length ?? 0) > 0;
    if (isLikedByUser) {
      FeedProvider.of(context).bloc.onRemoveChildReaction(
            kind: 'like',
            childReaction: reaction.ownChildren!['like']![0],
            lookupValue: widget.activity.id!,
            parentReaction: reaction,
          );
    } else {
      FeedProvider.of(context).bloc.onAddChildReaction(
            kind: 'like',
            reaction: reaction,
            lookupValue: widget.activity.id!,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: Column(
        children: [
          Expanded(
            child: ReactionListCore(
              lookupValue: widget.activity.id!,
              kind: 'comment',
              loadingBuilder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
              emptyBuilder: (context) =>
                  const Center(child: Text('No comment reactions')),
              errorBuilder: (context, error) => Center(
                child: Text(error.toString()),
              ),
              flags: _flags,
              reactionsBuilder: (context, reactions) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: RefreshIndicator(
                    onRefresh: () {
                      return context.feedBloc.refreshPaginatedReactions(
                        widget.activity.id!,
                        flags: _flags,
                      );
                    },
                    child: ListView.separated(
                      itemCount: reactions.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        bool shouldLoadMore = reactions.length - 3 == index;
                        if (shouldLoadMore) {
                          _loadMore();
                        }

                        final reaction = reactions[index];
                        final isLikedByUser =
                            (reaction.ownChildren?['like']?.length ?? 0) > 0;
                        final user = reaction.user;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user!.profileImage),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${reaction.data?['text']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          trailing: IconButton(
                            iconSize: 14,
                            onPressed: () {
                              _addOrRemoveLike(reaction);
                            },
                            icon: isLikedByUser
                                ? const Icon(Icons.favorite)
                                : const Icon(Icons.favorite_border),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          AddCommentBox(activity: widget.activity)
        ],
      ),
    );
  }
}

/// UI widget that displays a [TextField] to add a [Reaction]/Comment to a
/// particular [activity].
class AddCommentBox extends StatefulWidget {
  const AddCommentBox({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final EnrichedActivity activity;

  @override
  State<AddCommentBox> createState() => _AddCommentBoxState();
}

class _AddCommentBoxState extends State<AddCommentBox> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    final value = textController.text;
    textController.clear();

    if (value.isNotEmpty) {
      context.feedBloc.onAddReaction(
        kind: 'comment',
        activity: widget.activity,
        feedGroup: 'timeline',
        data: {'text': value},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 32),
      child: TextField(
        controller: textController,
        onSubmitted: ((value) {
          _addComment();
        }),
        decoration: InputDecoration(
          hintText: 'Add a comment',
          suffix: IconButton(
            onPressed: _addComment,
            icon: const Icon(Icons.send),
          ),
        ),
      ),
    );
  }
}
