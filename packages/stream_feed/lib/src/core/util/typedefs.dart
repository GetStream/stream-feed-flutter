import 'package:stream_feed/src/core/models/enriched_activity.dart';
import 'package:stream_feed/src/core/models/user.dart';

/// Convenient typedef for [GenericEnrichedActivity] with default parameters
/// ready to use and suitable for most use cases
typedef EnrichedActivity
    = GenericEnrichedActivity<User, String, String, String>;
