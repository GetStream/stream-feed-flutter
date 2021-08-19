import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

typedef EnrichedFeedBuilder<A,Ob> = Widget Function(
    BuildContext context, List<EnrichedActivity<A,Ob>> activities, int idx);
typedef ReactionsBuilder = Widget Function(
    BuildContext context, List<Reaction> reactions, int idx);
