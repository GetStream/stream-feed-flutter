import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed/stream_feed.dart';

main() async {
  const apiKey = 'ay57s8swfnan';
  const secret =
      'ajencvb6gfrbzvt2975kk3563j3vg86fhrswjsbk32zzgjcgtfn3293er4tk9bf4';

  final client = StreamClient.connect(apiKey,
      secret: secret,
      options: StreamHttpClientOptions(location: Location.usEast))
    ..user('1');

  // await client.currentUser!.create({
  //   'name': 'John Doe',
  //   'occupation': 'Software Engineer',
  //   'gender': 'male'
  // });
  final urlPreview = await client.og(
    'http://www.imdb.com/title/tt0117500/',
  );
//  expect(client., matcher)
}
