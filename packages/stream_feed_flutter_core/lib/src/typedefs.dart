import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

typedef OnSuccessActivities = Widget Function(
    BuildContext context, List<EnrichedActivity> activities, int idx);
typedef OnSuccessReactions = Widget Function(
    BuildContext context, List<Reaction> reactions,int idx);
