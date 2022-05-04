import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

Future<void> main() async {
  const apiKey = String.fromEnvironment('key');
  const userToken = String.fromEnvironment('user_token');
  final client = StreamFeedClient(apiKey);

  await client.setUser(
    const User(
      id: 'GroovinChip',
      data: {
        'handle': '@GroovinChip',
        'first_name': 'Reuben',
        'last_name': 'Turner',
        'full_name': 'Reuben Turner',
        'profile_image': 'https://avatars.githubusercontent.com/u/4250470?v=4',
      },
    ),
    const Token(userToken),
  );

  runApp(
    MyApp(client: client),
  );
}

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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final EnrichmentFlags _flags = EnrichmentFlags()
    ..withReactionCounts()
    ..withOwnReactions();

  bool _isPaginating = false;

  Future<void> _loadMore() async {
    // Ensure we're not already loading more activities.
    if (!_isPaginating) {
      _isPaginating = true;
      FeedProvider.of(context)
          .bloc
          .loadMoreEnrichedActivities(
            feedGroup: 'user',
          )
          .whenComplete(() {
        _isPaginating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = FeedProvider.of(context).bloc.client;
    return Scaffold(
      appBar: AppBar(title: const Text('Activities')),
      body: FlatFeedCore(
        feedGroup: 'user',
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
              return FeedProvider.of(context)
                  .bloc
                  .refreshPaginatedEnrichedActivities(
                    feedGroup: 'user',
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
                builder: (context) => const ActivityComposePage()),
          );
        },
        tooltip: 'Add Activity',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ListActivityItem extends StatelessWidget {
  const ListActivityItem({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final EnrichedActivity activity;

  @override
  Widget build(BuildContext context) {
    final actor = activity.actor!;
    final attachments = (activity.extraData)?.toAttachments();
    final reactionCounts = activity.reactionCounts;
    final ownReactions = activity.ownReactions;
    final isLikedByUser = (ownReactions?['like']?.length ?? 0) > 0;
    return Card(
      child: ListTile(
        leading: SizedBox(
            width: 40,
            child: Image.network(actor.data!['profile_image'] as String)),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text('${actor.data!['full_name']}'),
              const SizedBox(width: 8),
              Text(
                '${actor.data!['handle']}',
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
                      onPressed: () {
                        if (isLikedByUser) {
                          FeedProvider.of(context).bloc.onRemoveReaction(
                                kind: 'like',
                                activity: activity,
                                reaction: ownReactions!['like']![0],
                                feedGroup: 'user',
                              );
                        } else {
                          FeedProvider.of(context).bloc.onAddReaction(
                              kind: 'like',
                              activity: activity,
                              feedGroup: 'user');
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
                      onPressed: () => _navigateToCommentPage(context),
                      icon: const Icon(Icons.mode_comment_outlined),
                    ),
                    if (reactionCounts?['comment'] != null)
                      Text(
                        '${reactionCounts?['comment']} comments',
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
      ),
    );
  }

  void _navigateToCommentPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ReactionListPage(
          activity: activity,
        ),
      ),
    );
  }
}

class ReactionListPage extends StatefulWidget {
  const ReactionListPage({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final EnrichedActivity activity;

  @override
  State<ReactionListPage> createState() => _ReactionListPageState();
}

class _ReactionListPageState extends State<ReactionListPage> {
  bool _isPaginating = false;

  final EnrichmentFlags _flags = EnrichmentFlags()..withOwnChildren();

  Future<void> _loadMore() async {
    // Ensure we're not already loading more activities.
    if (!_isPaginating) {
      _isPaginating = true;
      FeedProvider.of(context)
          .bloc
          .loadMoreReactions(
            widget.activity.id!,
            flags: _flags,
          )
          .whenComplete(() {
        _isPaginating = false;
      });
    }
  }

  Future<void> _addOrRemoveReaction(Reaction reaction) async {
    final isLikedByUser = (reaction.ownChildren?['like']?.length ?? 0) > 0;
    if (isLikedByUser) {
      FeedProvider.of(context).bloc.onRemoveChildReaction(
            kind: 'like',
            childReaction: reaction.ownChildren!['like']![0],
            activity: widget.activity,
            parentReaction: reaction,
          );
    } else {
      FeedProvider.of(context).bloc.onAddChildReaction(
            kind: 'like',
            reaction: reaction,
            activity: widget.activity,
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
                      return FeedProvider.of(context)
                          .bloc
                          .refreshPaginatedReactions(
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
                        return Card(
                          key: ValueKey('reaction-${reaction.id}'),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${reaction.data?['text']}',
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  _addOrRemoveReaction(reaction);
                                },
                                icon: isLikedByUser
                                    ? const Icon(Icons.favorite, size: 14)
                                    : const Icon(Icons.favorite_border,
                                        size: 14),
                              ),
                            ],
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
      FeedProvider.of(context).bloc.onAddReaction(
        kind: 'comment',
        activity: widget.activity,
        feedGroup: 'user',
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

class ActivityComposePage extends StatefulWidget {
  const ActivityComposePage({Key? key}) : super(key: key);

  @override
  State<ActivityComposePage> createState() => _ActivityComposePageState();
}

class _ActivityComposePageState extends State<ActivityComposePage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uploadController = FeedProvider.of(context).bloc.uploadController;
    return Scaffold(
      appBar: AppBar(title: const Text('Compose'), actions: [
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
              onPressed: () async {
                final media = uploadController.getMediaUris()?.toExtraData();
                if (_textEditingController.text.isNotEmpty) {
                  await FeedProvider.of(context).bloc.onAddActivity(
                        feedGroup: 'user',
                        verb: 'post',
                        object: _textEditingController.text,
                        data: media,
                      );
                  uploadController.clear();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Cannot post with no message')));
                }
              }),
        )
      ]),
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
                        await FeedProvider.of(context)
                            .bloc
                            .uploadController
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
                uploadController:
                    FeedProvider.of(context).bloc.uploadController,
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
                            return uploadController.removeUpload(attachment);
                          },
                          onCancelUpload: (attachment) {
                            uploadController.cancelUpload(attachment);
                          },
                          onRetryUpload: (attachment) async {
                            return uploadController.uploadImage(attachment);
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
