import 'package:stream_feed_dart/src/core/models/feed_id.dart';

class Routes {
  static const _basePath = '/api/v1.0';
  static const _addToManyPath = 'feed/add_to_many';
  static const _followManyPath = 'follow_many';
  static const _unfollowManyPath = 'unfollow_many';
  static const _activitiesPath = 'activities';
  static const _enrichActivitiesPath = 'enrich/$_activitiesPath';
  static const _activityUpdatePath = 'activity';
  static const _reactionsPath = 'reaction';
  static const _usersPath = 'user';
  static const _collectionsPath = 'collections';
  static const _openGraphPath = 'og';
  static const _feedPath = 'feed';
  static const _enrichedFeedPath = 'enrich/$_feedPath';
  static const _filesPath = 'files';
  static const _imagesPath = 'images';

  static String buildFeedUrl(FeedId feed, [String path = '']) =>
      '$_basePath/$_feedPath/${feed.slug}/${feed.userId}/$path';

  static String buildEnrichedFeedUrl(FeedId feed, [String path = '']) =>
      '$_basePath/$_enrichedFeedPath/${feed.slug}/${feed.userId}/$path';

  static String get enrichedActivitiesUrl =>
      '$_basePath/$_enrichActivitiesPath';

  static String buildCollectionsUrl([String path = '']) =>
      '$_basePath/$_collectionsPath/$path';

  static String buildReactionsUrl([String path = '']) =>
      '$_basePath/$_reactionsPath/$path';

  static String buildUsersUrl([String path = '']) =>
      '$_basePath/$_usersPath/$path';

  static String get filesUrl => '$_basePath/$_filesPath';

  static String get imagesUrl => '$_basePath/$_imagesPath';

  static String get openGraphUrl => '$_basePath/$_openGraphPath';

  static String get activityUpdateUrl => '$_basePath/$_activityUpdatePath';

  static String get addToManyUrl => '$_basePath/$_addToManyPath';

  static String get followManyUrl => '$_basePath/$_followManyPath';

  static String get unfollowManyUrl => '$_basePath/$_unfollowManyPath';

  static String get activitesUrl => '$_basePath/$_activitiesPath';
}
