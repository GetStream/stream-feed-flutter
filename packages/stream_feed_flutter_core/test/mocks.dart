import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/reactions_controller.dart';

class MockLogger extends Mock implements Logger {}

class MockStreamFeedClient extends Mock implements StreamFeedClient {}

class MockReactions extends Mock implements ReactionsClient {}

class MockFiles extends Mock implements FileStorageClient {}

// class MockAttachmentDownloader extends Mock {

//   Completer<String> completer = Completer();

//   Future<String> call(
//     Attachment attachment, {
//     ProgressCallback? progressCallback,
//   }) {
//     this.progressCallback = progressCallback;
//     return completer.future;
//   }
// }

// class MockOnSendProgress extends Mock {
//   OnSendProgress? onSendProgress;
//   call({OnSendProgress? onSendProgress}) =>
//       this.onSendProgress = onSendProgress;
// }

class MockCancelToken extends Mock implements CancelToken {}

class MockOnSendProgress extends Mock {
  OnSendProgress? onSendProgress;

  void call(int sentBytes, int totalBytes) =>
      onSendProgress!.call(sentBytes, totalBytes);
}

class MockStreamAnalytics extends Mock implements StreamAnalytics {}

class MockFeedAPI extends Mock implements FlatFeed {}

class MockReactionsControllers extends Mock implements ReactionsController {}

class MockClient extends Mock implements StreamFeedClient {
  final Logger logger = MockLogger();
}

class MockStreamUser extends Mock implements StreamUser {}
