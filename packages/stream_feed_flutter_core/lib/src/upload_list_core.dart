import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';
import 'package:stream_feed_flutter_core/src/upload/upload_controller.dart';

import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// {@template uploadListCore}
/// A widget to easily display and manage uploads and their current state.
///
/// Usage:
/// ```dart
/// class ComposeScreen extends StatefulWidget {
///   const ComposeScreen({Key? key}) : super(key: key);
///
///   @override
///   State<ComposeScreen> createState() => _ComposeScreenState();
/// }
///
/// class _ComposeScreenState extends State<ComposeScreen> {
///   @override
///   Widget build(BuildContext context) {
///     final uploadController = FeedProvider.of(context).bloc.uploadController;
///     return Scaffold(
///       appBar: AppBar(title: const Text('Compose'), actions: [
///         Padding(
///           padding: const EdgeInsets.all(8.0),
///           child: ActionChip(
///             label: const Text(
///               'Post',
///               style: TextStyle(
///                 color: Colors.blue,
///               ),
///             ),
///             backgroundColor: Colors.white,
///             onPressed: () {
///               final attachments = uploadController.getMediaUris();
///               for (var element in attachments) {
///                 print(element.uri);
///               }
///               uploadController.clear();
///             },
///           ),
///         )
///       ]),
///       body: SingleChildScrollView(
///         child: Column(
///           children: [
///             const Padding(
///               padding: EdgeInsets.all(8.0),
///               child: TextField(
///                 decoration: InputDecoration(hintText: 'enter a description'),
///               ),
///             ),
///             IconButton(
///               onPressed: () async {
///                 final ImagePicker _picker = ImagePicker();
///                 final XFile? image =
///                     await _picker.pickImage(source: ImageSource.gallery);
///
///                 if (image != null) {
///                   await uploadController
///                       .uploadImage(AttachmentFile(path: image.path));
///                 } else {
///                   // User canceled the picker
///                 }
///               },
///               icon: const Icon(Icons.file_copy),
///             ),
///             UploadListCore(
///               uploadController: uploadController,
///               uploadsBuilder: (context, uploads) {
///                 return SizedBox(
///                   height: 100,
///                   child: ListView.builder(
///                     scrollDirection: Axis.horizontal,
///                     itemCount: uploads.length,
///                     itemBuilder: (context, index) => FileUploadStateWidget(
///                         fileState: uploads[index],
///                         onRemoveUpload: (attachment) {
///                           return uploadController.removeUpload(attachment);
///                         },
///                         onCancelUpload: (attachment) {
///                           uploadController.cancelUpload(attachment);
///                         },
///                         onRetryUpload: (attachment) async {
///                           return uploadController.uploadImage(attachment);
///                         }),
///                   ),
///                 );
///               },
///             ),
///           ],
///         ),
///       ),
///     );
///   }
/// }
/// ```
/// {@endtemplate}
class UploadListCore extends StatelessWidget {
  /// {@macro uploadListCore}
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<UploadController>(
          'uploadController', uploadController))
      ..add(ObjectFlagProperty<UploadsErrorBuilder?>.has(
          'uploadsErrorBuilder', uploadsErrorBuilder))
      ..add(ObjectFlagProperty<UploadsBuilder>.has(
          'uploadsBuilder', uploadsBuilder));
  }
}
