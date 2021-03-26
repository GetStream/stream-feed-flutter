import 'package:faye_dart/faye_dart.dart';
import 'package:faye_dart/src/channel.dart';
import 'package:faye_dart/src/event_emitter.dart';
import 'package:faye_dart/src/message.dart';

void main() async {
  const url = "wss://faye.getstream.io/faye";
  //
  final client = FayeClient(url);
  //
  // client.stateStream.listen(print);
  //
  // await client.connect();
  //
  // await Future.delayed(const Duration(seconds: 3));
  //
  // await client.disconnect();
  //
  // await Future.delayed(const Duration(seconds: 10));

  // final subscription = Subscription(client, 'test');
  // final channel = Channel(name: 'test')..subscription = subscription;
  //
  // channel.bind('message', (message){
  //   print(message);
  // });
  //
  // channel.emit('message', Message('test'));

  // emitter.emit('jda', 'sahil6');

  //`site-${this.client.appId}-feed-${this.feedTogether}`
  //'timeline', 'jack'

  // final name = 'site-93081-feed-timelinejack';
  //
  // final channel = Channel(
  //   name: name,
  //   subscription: (data) {
  //     print('Data a gya : $data');
  //   },
  // )..ext = {
  //     "api_key": 'Client.shared.apiKey',
  //     "signature": 'Client.shared.token',
  //     "user_id": 'notificationChannelName',
  //   };
  //
  // client.subscribe(channel);

  // await Future.delayed(const Duration(seconds: 5));
}
