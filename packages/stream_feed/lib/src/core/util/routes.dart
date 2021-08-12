import 'package:stream_feed/src/core/models/feed_id.dart';

class Routes {
  static const _addToManyPath = 'feed/add_to_many';
  static const _followManyPath = 'follow_many';
  static const _unfollowManyPath = 'unfollow_many';
  static const _activitiesPath = 'activities';
  static const _personalizationPath = 'personalization';
  static const _enrichPersonalizationPath = 'enrich/personalization';
  static const _personalizationFeedPath =
      '$_enrichPersonalizationPath/$_feedPath';
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
  static const _refreshPath = 'refresh';

  static const _statsFollowPath = 'stats/follow/';

  /// Handy method to build a url for a feed resource for a given path and feed
  static String buildFeedUrl(FeedId feed, [String path = '']) =>
      '$_feedPath/${feed.slug}/${feed.userId}/$path';

  /// Handy method to build a url for a personalization resource for a given
  /// path and resource
  static String buildPersonalizationURL(String resource, [String path = '']) =>
      '$_personalizationPath/$_feedPath/$resource/$path';

  /// Handy method to build a url for an enriched feed resource for a given path
  /// and feed
  static String buildEnrichedFeedUrl(FeedId feed, [String path = '']) =>
      '$_enrichedFeedPath/${feed.slug}/${feed.userId}/$path';

  static String get enrichedActivitiesUrl => _enrichActivitiesPath;

  /// Handy method to build a url for a Collection resource for a given path
  static String buildCollectionsUrl([String? path = '']) =>
      '$_collectionsPath/$path';

  /// Handy method to build a url for a Reaction resource for a given path
  static String buildReactionsUrl([String path = '']) =>
      '$_reactionsPath/$path';

  /// Handy method to build a url for a Refresh CDN resource for a given path
  static String buildRefreshCDNUrl([String? path = '']) =>
      '$path/$_refreshPath/';

  /// Handy method to build a URL for the users resource for a given path
  static String buildUsersUrl([String path = '']) => '$_usersPath/$path';

  /// Url for the files resource
  static String get filesUrl => _filesPath;

  /// Url for the images resource
  static String get imagesUrl => _imagesPath;

  /// Url for the open graph resource
  static String get openGraphUrl => _openGraphPath;

  /// Url for the activity update url
  static String get activityUpdateUrl => _activityUpdatePath;

  /// Url for the personalization feed resource
  static String get personalizedFeedUrl => _personalizationFeedPath;

  /// Url for the add to many resource
  static String get addToManyUrl => _addToManyPath;

  /// Url for the follow many resource
  static String get followManyUrl => _followManyPath;

  /// Url for the unfollow many resource
  static String get unfollowManyUrl => _unfollowManyPath;

  /// Url for the activities resource
  static String get activitesUrl => _activitiesPath;

  /// Url for stats follow resource
  static String get statsFollowUrl => _statsFollowPath;
}
