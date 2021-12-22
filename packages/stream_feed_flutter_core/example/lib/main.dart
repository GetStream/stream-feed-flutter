import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

Future<void> main() async {
  const apiKey = String.fromEnvironment('key');
  const userToken = String.fromEnvironment('user_token');
  final client = StreamFeedClient(
    apiKey,
    token: const Token(userToken),
  );

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
        feedBuilder: (BuildContext context, activities, int index) {
          return InkWell(
            child: ListTile(
              title: Text('${activities[index].actor!.data!['handle']}'),
              subtitle: Text('${activities[index].object}'),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => Scaffold(
                    body: ReactionListCore(
                      lookupValue: activities[index].id!,
                      reactionsBuilder: (context, reactions, idx) => Text(
                        '${reactions[index].data?['text']}',
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => ComposeScreen()),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
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
  late AttachmentFile? _file = null;
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
        Padding(
          padding: const EdgeInsets.all(8.0),
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
            icon: Icon(Icons.file_copy)),
        UploadListCore(
          uploadController: FeedProvider.of(context).bloc.uploadController,
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
