import 'package:stream_feed/src/core/models/activity_marker.dart';
import 'package:stream_feed/src/core/models/enrichment_flags.dart';
import 'package:stream_feed/src/core/models/filter.dart';

/// Default values
class Default {
  const Default._();

  /// The default amount of activities requested from the APIs
  static const int limit = 25;

  /// The default offset
  static const int offset = 0;

  /// The default filter
  static Filter filter = Filter();

  /// The default marker
  static ActivityMarker marker = ActivityMarker();

  /// The default enrichment flag
  static EnrichmentFlags enrichmentFlags = EnrichmentFlags();

  /// The default amount of activities that should be copied from the target
  /// feed
  static const int activityCopyLimit = 100;

  /// The max amount of activities that should be copied from the target feed
  static const int maxActivityCopyLimit = 1000;
  //TODO: time now ?
}
