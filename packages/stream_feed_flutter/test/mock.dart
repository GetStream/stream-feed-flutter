import 'package:stream_feed_flutter/src/widgets/status_update_controller.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:mocktail/mocktail.dart';
import 'package:image_picker/image_picker.dart';

class MockFiles extends Mock implements FileStorageClient {}

class MockReactions extends Mock implements ReactionsClient {}

class MockStreamAnalytics extends Mock implements StreamAnalytics {}

class MockStreamFeedClient extends Mock implements StreamFeedClient {}

class MockFeedAPI extends Mock implements FlatFeed {}

class MockImagePicker extends Mock implements ImagePicker {}

class MockStatusUpdateFormController extends Mock
    implements StatusUpdateFormController {}
