import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/src/textarea.dart';

void main() {
  testWidgets('TextArea', (WidgetTester tester) async {
    final textController = TextEditingController();
    final focusNode = FocusNode();
    final hintStyle = TextStyle(
      inherit: false,
      color: Colors.pink[500],
      fontSize: 10.0,
    );
    final inputTextStyle = TextStyle(
      inherit: false,
      color: Colors.green[500],
      fontSize: 12.0,
      textBaseline: TextBaseline.alphabetic,
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TextArea(
          textEditingController: textController,
          focusNode: focusNode,
          hintText: 'Placeholder',
          hintTextStyle: hintStyle,
          inputTextStyle: inputTextStyle,
        ),
      ),
    ));
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byKey(const Key('messageInputText')), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'blah blah');
    expect(textController.text, 'blah blah');
    final inputText = tester.widget<EditableText>(find.text('blah blah'));
    expect(inputText.style, inputTextStyle);
    expect(focusNode.hasPrimaryFocus, isTrue);
    final hintText = tester.widget<Text>(find.text('Placeholder'));
    expect(hintText.style, hintStyle);
  });
}
