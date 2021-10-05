import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'mocks.dart';

// ignore_for_file: diagnostic_describe_all_properties

class OnRemoveReactionWidget extends StatefulWidget {
  const OnRemoveReactionWidget(
      {Key? key,
      required this.activity,
      required this.feedGroup,
      required this.reaction,
      required this.kind})
      : super(key: key);

  final DefaultEnrichedActivity activity;
  final String feedGroup;
  final String kind;
  final Reaction reaction;

  @override
  _OnAddReactionWidgetState createState() => _OnAddReactionWidgetState();
}

class _OnAddReactionWidgetState extends State<OnRemoveReactionWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await DefaultFeedBlocProvider.of(context).bloc.onRemoveReaction(
              reaction: widget.reaction,
              activity: widget.activity,
              feedGroup: widget.feedGroup,
              kind: widget.kind,
            );
      },
    );
  }
}

Future<void> main() async {
  late MockStreamFeedClient mockClient;
  late MockReactions mockReactions;
  late MockStreamAnalytics mockStreamAnalytics;
  late LookupAttribute lookupAttr;
  late String lookupValue;
  late Filter filter;
  late int limit;
  late String kind;
  late List<Reaction> reactions;
  late String activityId;
  late String userId;
  late List<FeedId> targetFeeds;
  late Map<String, String> data;
  late DefaultFeedBloc bloc;
  late MockReactionControllers mockReactionControllers;
  late String feedGroup;

  tearDown(() => bloc.dispose());

  setUp(() {
    mockReactions = MockReactions();
    mockReactionControllers = MockReactionControllers();
    mockStreamAnalytics = MockStreamAnalytics();
    mockClient = MockStreamFeedClient();
    lookupAttr = LookupAttribute.activityId;
    lookupValue = 'ed2837a6-0a3b-4679-adc1-778a1704852d';
    filter = Filter().idGreaterThan('e561de8f-00f1-11e4-b400-0cc47a024be0');

    limit = 5;
    kind = 'like';
    activityId = 'activityId';
    userId = 'john-doe';
    targetFeeds = <FeedId>[];
    data = {'text': 'awesome post!'};
    feedGroup = 'user';
    reactions = [
      Reaction(
        id: 'id',
        kind: 'like',
        activityId: activityId,
        childrenCounts: {
          'like': 0,
        },
        latestChildren: {'like': []},
        ownChildren: {'like': []},
      )
    ];
    when(() => mockClient.reactions).thenReturn(mockReactions);

    bloc = FeedBloc(client: mockClient);
  });
  testWidgets('onRemoveReaction', (tester) async {
    const reactionId = 'reactionId';
    final reaction = Reaction(id: reactionId);
    bloc.reactionsControllers = mockReactionControllers;
    when(() => mockReactionControllers[activityId])
        .thenAnswer((_) => BehaviorSubject.seeded(reactions));
    when(() => mockReactions.delete(reactionId))
        .thenAnswer((invocation) => Future.value());

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
          body: DefaultFeedBlocProvider(
        bloc: bloc,
        child: OnRemoveReactionWidget(
          activity: EnrichedActivity(id: activityId, reactionCounts: {
            'like': 1
          }, ownReactions: {
            'like': [reaction]
          }, latestReactions: {
            'like': [reaction]
          }),
          feedGroup: feedGroup,
          kind: kind,
          reaction: reaction,
        ),
      )),
    ));
    final reactionIcon = find.byType(InkWell);
    expect(reactionIcon, findsOneWidget);
    await tester.tap(reactionIcon);
    verify(() => mockReactions.delete(reactionId)).called(1);

    //TODO: test reaction Stream
  });
}
