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
      home: HomePage(client: client),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamFeedClient client;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlatFeedCore(
        feedGroup: 'user',
        userId: widget.client.currentUser!.id,
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        emptyBuilder: (context) => const Center(child: Text('No activities')),
        errorBuilder: (context, error) => Center(
          child: Text(error.toString()),
        ),
        feedBuilder: (
          BuildContext context,
          activities,
        ) {
          return ListView.separated(
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return InkWell(
                  child: ListTile(
                    title: Text('${activities[index].actor!.data!['handle']}'),
                    subtitle: Text('${activities[index].object}'),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => ReactionListScreen(
                                lookupValue: activities[index].id!,
                              )),
                    );
                  },
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (context) => const ComposeScreen()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ReactionListScreen extends StatelessWidget {
  const ReactionListScreen({
    Key? key,
    required this.lookupValue,
  }) : super(key: key);

  final String lookupValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReactionListCore(
        lookupValue: lookupValue,
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        emptyBuilder: (context) => const Center(child: Text('No Reactions')),
        errorBuilder: (context, error) => Center(
          child: Text(error.toString()),
        ),
        reactionsBuilder: (context, reactions) {
          return ListView.separated(
            shrinkWrap: true,
            itemCount: reactions.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return Text(
                '${reactions[index].data?['text']}',
              );
            },
          );
        },
      ),
    );
  }
}

class ComposeScreen extends StatefulWidget {
  const ComposeScreen({Key? key}) : super(key: key);

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
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
              onPressed: () {
                final attachments = uploadController.getMediaUris();
                print(attachments);
                uploadController.clear();
              }),
        )
      ]),
      body: SingleChildScrollView(
          child: Column(children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(hintText: "this is a text field"),
          ),
        ),
        IconButton(
            onPressed: () async {
              final ImagePicker _picker = ImagePicker();
              final XFile? image =
                  await _picker.pickImage(source: ImageSource.gallery);

              if (image != null) {
                await FeedProvider.of(context)
                    .bloc
                    .uploadController
                    .uploadImage(AttachmentFile(path: image.path));
              } else {
                // User canceled the picker
              }
            },
            icon: const Icon(Icons.file_copy)),
        UploadListCore(
          uploadController: FeedProvider.of(context).bloc.uploadController,
          loadingBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
          uploadsErrorBuilder: (error) => Center(child: Text(error.toString())),
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
      ])),
    );
  }
}
