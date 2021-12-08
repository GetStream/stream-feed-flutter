import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';
import 'package:stream_feed_flutter_core/src/upload/upload_controller.dart';
import 'package:stream_feed_flutter_core/src/upload/widgets.dart';

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
class UploadListCore extends StatefulWidget {
  const UploadListCore({
    Key? key,
    required this.uploadController,
    this.uploadsBuilder,
    this.onUploadSuccess,
    this.onUploadProgress,
    this.onUploadFailed,
    this.onErrorWidget = const ErrorStateWidget(),
    this.onProgressWidget = const SizedBox.shrink(),
    this.onEmptyWidget = const EmptyStateWidget(message: 'No uploads'),
    this.onMediaPreview,
    this.stateIconPosition = StateIconPosition.right,
  }) : super(key: key);

  final OnMediaPreview? onMediaPreview;

  /// Position of the closed icon
  final StateIconPosition stateIconPosition;

  /// An error widget to show when an error occurs
  final Widget onErrorWidget;

  /// A progress widget to show when a request is in progress
  final Widget onProgressWidget;

  /// A widget to show when the feed is empty
  final Widget onEmptyWidget;

  /// A callback to build a widget based on the upload state
  final UploadsBuilder? uploadsBuilder;

  /// A callback to build a widget to show when the upload is successful
  final OnUploadSuccess? onUploadSuccess;

  /// A callback to build a widget to show when the upload is in progress
  final OnUploadProgress? onUploadProgress;

  /// A callback to build a widget to show when the upload failed
  final OnUploadFailed? onUploadFailed;

  /// The upload controller
  /// uploadMedias()
  final UploadController uploadController;

  @override
  _UploadListCoreState createState() => _UploadListCoreState();
}

class _UploadListCoreState extends State<UploadListCore> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<AttachmentFile, UploadState>>(
        stream: widget.uploadController.uploadsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return widget.onErrorWidget;
          }
          if (!snapshot.hasData) {
            return widget.onProgressWidget;
          }
          final rawMap = snapshot.data!;
          final uploads = List<FileUploadState>.from(
              rawMap.entries.map((entry) => FileUploadState.fromEntry(entry)));
          return SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: uploads.length,
              itemBuilder: (context, idx) =>
                  widget.uploadsBuilder?.call(
                    context,
                    uploads,
                    idx,
                  ) ??
                  FileUploadStateWidget(
                    fileState: uploads[idx],
                    onUploadSuccess: widget.onUploadSuccess,
                    onUploadProgress: widget.onUploadProgress,
                    onUploadFailed: widget.onUploadFailed,
                    onMediaPreview: widget.onMediaPreview,
                    stateIconPosition: widget.stateIconPosition,
                    onCancelUpload: (AttachmentFile file) {
                      widget.uploadController.cancelUpload(file);
                    },
                    onRemoveUpload: (AttachmentFile file) {
                      widget.uploadController.removeUpload(file);
                    },
                    onRetryUpload: (AttachmentFile file) async {
                      await widget.uploadController.uploadImage(file);
                    },
                  ),
            ),
          );
        });
  }
}
