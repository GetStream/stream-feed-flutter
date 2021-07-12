import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

typedef OnMentionTap = void Function(String? mention);
typedef OnHashtagTap = void Function(String? hashtag);

typedef OnReactionTap = void Function(Reaction? reaction);
typedef OnUserTap = void Function(User? user);
typedef OnActivityTap = void Function(
    BuildContext context, EnrichedActivity activity);

typedef ActivityFooterBuilder = Widget Function(
    BuildContext context, EnrichedActivity activity);

typedef ActivityContentBuilder = Widget Function(
    BuildContext context, EnrichedActivity activity);
typedef ActivityHeaderBuilder = Widget Function(
    BuildContext context, EnrichedActivity activity);

typedef ReactionBuilder = Widget Function(
    BuildContext context, Reaction reaction);
