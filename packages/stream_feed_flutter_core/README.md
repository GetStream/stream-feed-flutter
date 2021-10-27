A library for Dart developers.

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Usage

A simple usage example:

```dart
void main() {
  const apiKey = String.fromEnvironment('key');
  const userToken = String.fromEnvironment('user_token');
  final client = StreamFeedClient.connect(
    apiKey,
    token: const Token(userToken),
  );

     runApp(MaterialApp(
        builder: (context, child) =>
            FeedProvider(
          bloc: FeedBloc(
            client: client,
          ),
          child: child!,
        ),
        home: Scaffold(
          body: FlatFeedCore(
            feedGroup: 'user',
            feedBuilder: (BuildContext context, activities, int idx) {
              return InkWell(
                child:  Column(children:[Text("${activities[index].actor}",Text("${activities[index].object}"))]),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (BuildContext context) =>  Scaffold(
          body: ReactionListCore(
            lookupValue:activity.id!,
            reactionsBuilder: (context, reactions, idx) =>  Text("${reaction.data?["text"]}"),
          ),
        ),
          ));
               },
              );
            },
          ),
        ),
      ));
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
