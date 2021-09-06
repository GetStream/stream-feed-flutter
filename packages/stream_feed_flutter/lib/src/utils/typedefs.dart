import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///{@template mention_callback}
/// A callback to handle mention taps
/// {@endtemplate}
typedef OnMentionTap = void Function(String? mention);

///{@template hashtag_callback}
/// A callback to handle hashtag taps
/// {@endtemplate}
typedef OnHashtagTap = void Function(String? hashtag);

///{@template reaction_callback}
/// A callback to handle reaction taps
/// {@endtemplate}
typedef OnReactionTap = void Function(Reaction? reaction);

///{@template user_callback}
/// A callback to handle user taps
/// {@endtemplate}
typedef OnUserTap = void Function(User? user);
typedef OnNotificationTap = void Function(
    NotificationGroup<EnrichedActivity>? notification);

///{@template activity_callback}
/// A callback to handle activity taps
/// {@endtemplate}
typedef OnActivityTap = void Function(
    BuildContext context, DefaultEnrichedActivity activity);

/// TODO: document me
typedef ActivityFooterBuilder = Widget Function(
    BuildContext context, EnrichedActivity activity);

/// TODO: document me
typedef ActivityContentBuilder = Widget Function(
    BuildContext context, EnrichedActivity activity);

/// TODO: document me
typedef ActivityHeaderBuilder = Widget Function(
    BuildContext context, EnrichedActivity activity);

typedef NotificationBuilder = Widget Function(
    BuildContext context, NotificationGroup<EnrichedActivity> notification);

/// TODO: document me
typedef ReactionBuilder = Widget Function(
    BuildContext context, Reaction reaction);

/// TODO: document me
typedef DefaultEnrichedActivity
    = EnrichedActivity<User, String, String, String>;
