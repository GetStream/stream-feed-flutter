import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';
import 'package:stream_feed_flutter_core/src/upload/upload_controller.dart';

import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// Usage:
///
///```dart
/// import 'package:image_picker/image_picker.dart';
/// class ComposeScreen extends StatefulWidget {
///   const ComposeScreen({Key? key}) : super(key: key);
///
///   @override
///   State<ComposeScreen> createState() => _ComposeScreenState();
/// }
///
/// class _ComposeScreenState extends State<ComposeScreen> {
///   late AttachmentFile? _file = null;
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: const Text('Compose'), actions: [
///         Padding(
///           padding: const EdgeInsets.all(8.0),
///           child: ActionChip(
///               label: const Text(
///                 'Post',
///                 style: TextStyle(
///                   color: Colors.blue,
///                 ),
///               ),
///               backgroundColor: Colors.white,
///               onPressed: () {
///                 final attachments =
///                     FeedProvider.of(context).bloc.uploadController.getUrls();
///                 print(attachments);
///               }),
///         )
///       ]),
///       body: SingleChildScrollView(
///           child: Column(children: [
///         Padding(
///           padding: const EdgeInsets.all(8.0),
///           child: TextField(
///             decoration: InputDecoration(hintText: "this is a text field"),
///           ),
///         ),
///         IconButton(
///             onPressed: () async {
///               final ImagePicker _picker = ImagePicker();
///               // Pick an image
///               final XFile? image =
///                   await _picker.pickImage(source: ImageSource.gallery);
///
///               if (image != null) {
///                 await FeedProvider.of(context)
///                     .bloc
///                     .uploadFile(AttachmentFile(path: image.path));
///
///               } else {
///                 // User canceled the picker
///               }
///             },
///             icon: Icon(Icons.file_copy)),
///         UploadListCore(
///           uploadController: FeedProvider.of(context).bloc.uploadController,
///         ),
///       ])),
///     );
///   }
/// }
/// ```
class UploadListCore extends StatelessWidget {
  const UploadListCore({
    Key? key,
    required this.uploadController,
    required this.uploadsBuilder,
    this.uploadsErrorBuilder,
    this.onProgressWidget = const SizedBox.shrink(),
  }) : super(key: key);

  /// An error builder to show when an error occurs.
  final UploadsErrorBuilder? uploadsErrorBuilder;

  /// A progress widget to show when a request is in progress.
  final Widget onProgressWidget;

  /// Builder that will be called with a list of current uploads and their
  /// state.
  final UploadsBuilder uploadsBuilder;

  /// The upload controller used to manage uploads.
  final UploadController uploadController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<AttachmentFile, UploadState>>(
      stream: uploadController.uploadsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return uploadsErrorBuilder?.call(snapshot.error!) ??
              const ErrorStateWidget();
        }
        if (!snapshot.hasData) {
          return onProgressWidget;
        }
        final rawMap = snapshot.data!;
        final uploads = List<FileUploadState>.from(
          rawMap.entries.map(
            (entry) => FileUploadState.fromEntry(entry),
          ),
        );

        return uploadsBuilder.call(context, uploads);
      },
    );
  }
}
