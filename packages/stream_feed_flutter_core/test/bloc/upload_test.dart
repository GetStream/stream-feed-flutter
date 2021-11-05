import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed/stream_feed.dart';
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

class UploadCancelled extends UploadState {}

class UploadSuccess extends UploadState {
  final String? url;
  UploadSuccess(this.url);
}

class UploadController {
  late Map<AttachmentFile, CancelToken> uploads = {};

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

  void cancel(AttachmentFile attachmentFile) {
    final token = uploads[attachmentFile];
    token!.cancel('cancelled');
    _stateController.add(UploadCancelled());
  }

  Future<void> uploadFile(AttachmentFile attachmentFile) async {
    final url = await client.files.upload(attachmentFile,
        onSendProgress: (sentBytes, totalBytes) {
      _stateController
          .add(UploadProgress(bytesSent: sentBytes, bytesTotal: totalBytes));
    });
    _stateController.add(UploadSuccess(url));
    // .onError((error, stackTrace) => _stateController.add(UploadError()));
    // _stateController.add(UploadProgress());
  }
}

main() {
  group('bloc', () {
    test('success', () async {
      final mockClient = MockClient();
      final mockFiles = MockFiles();
      final file = assetFile('test_image.jpeg');
      final mockOnSendProgress = MockOnSendProgress();

      final attachment = AttachmentFile(
        path: file.path,
        bytes: file.readAsBytesSync(),
      );
      const cdnUrl = 'url';
      when(() => mockClient.files).thenReturn(mockFiles);
      when(() =>
              mockFiles.upload(attachment, onSendProgress: mockOnSendProgress))
          .thenAnswer((_) async => cdnUrl);
      final bloc = UploadController(mockClient);

      expect(
          bloc.stateStream,
          emitsInOrder(<UploadState>[
            UploadEmptyState(),
            UploadProgress(bytesTotal: 100),
            UploadSuccess(cdnUrl)
          ]));

      await bloc.uploadFile(attachment);
      mockOnSendProgress.onSendProgress!(0, 100);
      // if things go as expected

      //cancelled
      //  await expectLater(bloc.stateStream,emitsInOrder([UploadEmptyState(), UploadProgress(), UploadCancelled()]));
      //failed
      //  await expectLater(bloc.stateStream,emitsInOrder([UploadEmptyState(), UploadProgress(), UploadFailed()]));
    });
  });
}
