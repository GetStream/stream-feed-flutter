import 'package:stream_feed_dart/src/core/models/activity_marker.dart';
import 'package:stream_feed_dart/src/core/models/enrichment_flags.dart';
import 'package:stream_feed_dart/src/core/models/filter.dart';

class Default {
  const Default._();

  static const int limit = 25;
  static const int offset = 0;
  static Filter filter = Filter();
  static ActivityMarker marker = ActivityMarker();
  static EnrichmentFlags enrichmentFlags = EnrichmentFlags();
  static const int activityCopyLimit = 100;
  static const int maxActivityCopyLimit = 1000;
}
