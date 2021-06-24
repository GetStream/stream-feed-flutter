import 'package:flutter/material.dart';

class TextArea extends StatefulWidget {
  const TextArea(
      {Key? key,
      this.textEditingController,
      this.maxHeight = 150,
      this.focusNode,
      this.autofocus = false,
      this.keyboardType = TextInputType.multiline,
      this.inputTextStyle,
      this.hintTextStyle,
      required this.onSubmitted,
      this.hintText})
      : super(key: key);

  /// The text controller of the TextField
  final TextEditingController? textEditingController;

  /// Maximum Height for the TextField to grow before it starts scrolling
  final double maxHeight;

  /// The focus node associated to the TextField
  final FocusNode? focusNode;

  /// Autofocus property passed to the TextField
  final bool autofocus;

  /// The keyboard type assigned to the TextField
  final TextInputType keyboardType;

  final String? hintText;

  /// The text input style
  final TextStyle? inputTextStyle;

  /// The hint text style
  final TextStyle? hintTextStyle;

  ///  Callback called when the user indicates that they are done editing the text in the field.
  final void Function(String) onSubmitted;

  @override
  _TextAreaState createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  /// The editing controller passed to the input TextField
  late final TextEditingController textEditingController;

  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    textEditingController =
        widget.textEditingController ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: widget.maxHeight,
      child: TextField(
        key: Key('messageInputText'),
        onSubmitted: (value) => widget.onSubmitted(value),
        maxLines: null,
        keyboardType: widget.keyboardType,
        controller: textEditingController,
        focusNode: _focusNode,
        style: widget.inputTextStyle,
        autofocus: widget.autofocus,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8.0),
            hintStyle: widget.hintTextStyle,
            border: InputBorder.none,
            hintText: widget.hintText),
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}
