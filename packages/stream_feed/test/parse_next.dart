import 'package:stream_feed/src/core/models/filter.dart';
import 'package:stream_feed/src/core/models/next_params.dart';
import 'package:stream_feed/src/core/util/parse_next.dart';
import 'package:test/test.dart';

void main() {
  test('parse_next', () {
    const next =
        '/api/v1.0/feed/user/1/?api_key=8rxdnw8pjmvb&id_lt=b253bfa1-83b3-11ec-8dc7-0a5c4613b2ff&limit=25';

    expect(
        parseNext(next),
        NextParams(
            limit: 25,
            idLT: Filter().idLessThan('b253bfa1-83b3-11ec-8dc7-0a5c4613b2ff')));
  });
}
