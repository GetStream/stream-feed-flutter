import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import '../mocks.dart';
import '../utils.dart';

abstract class _Event with EquatableMixin {
  @override
  List<Object> get props => [];
}

abstract class _State with EquatableMixin {
  @override
  List<Object> get props => [];
}

class UploadEvent extends _Event {}

class UploadState extends _State {}

class UploadFile extends UploadEvent {
  UploadFile({required this.file, required this.url});

  final AttachmentFile file;
  final String url;
  @override
  List<Object> get props => [file, url];
}

class CancelUpload extends UploadEvent {}

// class RemoveFile extends Event {
//   RemoveFile({required this.file});

//   final AttachmentFile file;

//   // @override
//   // List<Object> get props => [file];
// }

class UploadEmptyState extends UploadState {}

class UploadProgress extends UploadState {
  UploadProgress({this.bytesSent = 0, this.bytesTotal = 0});

  final int bytesSent;
  final int bytesTotal;

  @override
  List<Object> get props => [bytesSent, bytesTotal];
}

class UploadSuccess extends UploadState {
  final String? url;
  UploadSuccess(this.url);
}

class UploadController {
  UploadController(this.client);
  final StreamFeedClient client;
  final _eventController = BehaviorSubject<UploadEvent>();
  final _stateController =
      BehaviorSubject<UploadState>.seeded(UploadEmptyState());

  Stream<UploadEvent> get eventsStream => _eventController.stream;
  Stream<UploadState> get stateStream => _stateController.stream;
  Stream<UploadProgress>? get progressStream =>
      _stateController.whereType<UploadProgress>();

  void close() {
    _eventController.close();
    _stateController.close();
  }

  Future<void> uploadFile(AttachmentFile attachmentFile) async {
    client.files
        .upload(attachmentFile)
        .then((url) => _stateController.add(UploadSuccess(url)));
    // _stateController.add(UploadProgress());
  }
}

main() {
  test('bloc', () async {
    final mockClient = MockClient();
    final mockFiles = MockFiles();
    final file = assetFile('test_image.jpeg');
    final attachment = AttachmentFile(
      path: file.path,
      bytes: file.readAsBytesSync(),
    );
    const cdnUrl = 'url';
    when(() => mockClient.files).thenReturn(mockFiles);
    when(() => mockFiles.upload(attachment)).thenAnswer((_) async => cdnUrl);
    final bloc = UploadController(mockClient);
    expect(
        bloc.stateStream,
        emitsInOrder(<UploadState>[
          UploadEmptyState(),
          // UploadProgress(),
          UploadSuccess(cdnUrl)
        ]));

    await bloc.uploadFile(attachment);
    // if things go as expected

    //cancelled
    //  await expectLater(bloc.stateStream,emitsInOrder([UploadStarted(), UploadProgress(), UploadCancelled()]));
    //failed
    //  await expectLater(bloc.stateStream,emitsInOrder([UploadStarted(), UploadProgress(), UploadFailed()]));
  });
}
