import 'package:stream_feed/src/core/util/routes.dart';
import 'package:test/test.dart';

void main() {
  group('Routes', () {
    test('activitesUrl', () {
      expect(Routes.activitesUrl, 'activities');
    });
    test('activity', () {
      expect(Routes.activityUpdateUrl, 'activity');
    });

    test('statsFollowUrl', () {
      expect(Routes.statsFollowUrl, 'stats/follow/');
    });

    group('buildRefreshCDNUrl', () {
      test('files', () {
        expect(Routes.buildRefreshCDNUrl('files'), 'files/refresh/');
      });

      test('images ', () {
        expect(Routes.buildRefreshCDNUrl('images'), 'images/refresh/');
      });
    });
    test('addToManyUrl', () {
      expect(Routes.addToManyUrl, 'feed/add_to_many');
    });
    test('enrichedActivitiesUrl', () {
      expect(Routes.enrichedActivitiesUrl, 'enrich/activities');
    });
    test('files', () {
      expect(Routes.filesUrl, 'files');
    });
    test('followManyUrl', () {
      expect(Routes.followManyUrl, 'follow_many');
    });
    test('imagesUrl', () {
      expect(Routes.imagesUrl, 'images');
    });
    test('openGraphUrl', () {
      expect(Routes.openGraphUrl, 'og');
    });
    test('unfollowManyUrl', () {
      expect(Routes.unfollowManyUrl, 'unfollow_many');
    });
  });
}
