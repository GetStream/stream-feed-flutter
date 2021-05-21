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
    var _value = '';

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TextArea(
          textEditingController: textController,
          focusNode: focusNode,
          hintText: 'Placeholder',
          hintTextStyle: hintStyle,
          inputTextStyle: inputTextStyle,
          onChanged: (String value) {
            _value = value;
          },
        ),
      ),
    ));

    final textFieldWidget = find.byType(TextField);
    await tester.enterText(textFieldWidget, 'Soup');
    await tester.pump();
    expect(_value, 'Soup');
    final inputText = tester.widget<EditableText>(find.text('Soup'));
    expect(inputText.style, inputTextStyle);
    expect(focusNode.hasPrimaryFocus, isTrue);
    final hintText = tester.widget<Text>(find.text('Placeholder'));
    expect(hintText.style, hintStyle);
  });
}
