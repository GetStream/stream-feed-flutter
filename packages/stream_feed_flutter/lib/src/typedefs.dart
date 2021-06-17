import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

typedef OnMentionTap = void Function(String? mention);
typedef OnHashtagTap = void Function(String? hashtag);

typedef OnReactionTap = void Function(Reaction? reaction);
typedef OnUserTap = void Function(User? user);

typedef ActivityFooterBuilder = Widget Function(
    BuildContext context, EnrichedActivity activity);
