import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/src/textarea.dart';

void main() {
  testWidgets('TextArea', (WidgetTester tester) async {
    final textController = TextEditingController();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TextArea(
          textEditingController: textController,
        ),
      ),
    ));
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byKey(const Key('messageInputText')), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'blah blah');
    expect(textController.text, 'blah blah');
  });
}
