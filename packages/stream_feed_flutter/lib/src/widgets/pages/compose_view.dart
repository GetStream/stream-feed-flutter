import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/reactive_elevated_button.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

class ComposeView extends StatefulWidget {
  const ComposeView(
      {Key? key,
      this.parentActivity,
      this.feedGroup = 'user',
      this.nameJsonKey = 'full_name',
      required this.textEditingController})
      : super(key: key);

  final TextEditingController textEditingController;

  /// The activity to reply to.
  final EnrichedActivity? parentActivity;

  /// The feed group that the [parentActivity] belongs to.
  final String feedGroup;

  /// The json key for the user's name.
  final String nameJsonKey;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<EnrichedActivity?>(
          'parentActivity', parentActivity))
      ..add(StringProperty('feedGroup', feedGroup))
      ..add(StringProperty('nameJsonKey', nameJsonKey));
  }

  @override
  State<ComposeView> createState() => _ComposeViewState();
}

class _ComposeViewState extends State<ComposeView> {
  bool get _isReply => widget.parentActivity != null;

  String get _hintText =>
      _isReply ? 'What\'s on your mind?' : 'Post your reply...';

  InputDecoration get _lightThemeInputDecoration => InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade300,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        hintText: _hintText,
        alignLabelWithHint: true,
      );

  InputDecoration get _darkThemeInputDecoration => InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade800,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade800,
          ),
        ),
        hintText: _hintText,
        alignLabelWithHint: true,
      );

  @override
  Widget build(BuildContext context) {
    final uploadController = FeedProvider.of(context).bloc.uploadController;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        iconTheme: Theme.of(context).iconTheme,
        titleTextStyle: Theme.of(context).textTheme.headline6,
        elevation: 0,
        title: Text(_isReply ? 'Reply' : 'Post'),
        actions: [
          ReactiveElevatedButton(
            textEditingController: widget.textEditingController,
            label: _isReply ? 'Reply' : 'Post',
            buttonStyle: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
            ),
            onSend: (inputText) async {
              if (inputText.isNotEmpty) {
                try {
                  final attachments =
                      uploadController.getMediaUris().toExtraData();
                  _isReply
                      ? await FeedProvider.of(context).bloc.onAddReaction(
                            kind: 'comment',
                            data: {
                              'text': inputText.trim(),
                              ...attachments,
                            },
                            activity: widget.parentActivity!,
                            feedGroup: widget.feedGroup,
                          )
                      : FeedProvider.of(context).bloc.onAddActivity(
                            feedGroup: widget.feedGroup,
                            verb: 'post',
                            object: widget.textEditingController.text,
                            userId:
                                FeedProvider.of(context).bloc.currentUser!.id,
                            data: attachments,
                          );
                  uploadController.clear();
                  Navigator.of(context).pop();
                } catch (e) {
                  debugPrint(e.toString());
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isReply)
              ActivityWidget(
                activity: widget.parentActivity!,
                nameJsonKey: widget.nameJsonKey,
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Avatar(
                  user: User(
                    data: FeedProvider.of(context).bloc.currentUser?.data,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: widget.textEditingController,
                      autofocus: true,
                      maxLines: 5,
                      decoration:
                          Theme.of(context).brightness == Brightness.light
                              ? _lightThemeInputDecoration
                              : _darkThemeInputDecoration,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: UploadListCore(
                    uploadController:
                        FeedProvider.of(context).bloc.uploadController,
                    uploadsBuilder: (context, uploads) {
                      return SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: uploads.length,
                          itemBuilder: (context, index) =>
                              FileUploadStateWidget(
                            fileState: uploads[index],
                            onRemoveUpload: uploadController.removeUpload,
                            onCancelUpload: uploadController.cancelUpload,
                            onRetryUpload: (attachment) async {
                              return uploadController.uploadImage(attachment);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: () async {
                    final _picker = ImagePicker();
                    final image =
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
