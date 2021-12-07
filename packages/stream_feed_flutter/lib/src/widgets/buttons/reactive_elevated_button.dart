import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';

//ignore_for_file: cascade_invocations

/// TODO: document me
class ReactiveElevatedButton extends StatefulWidget {
  /// Builds a [ReactiveElevatedButton].
  const ReactiveElevatedButton({
    Key? key,
    required this.textEditingController,
    required this.label,
    required this.onSend,
    this.buttonStyle,
  }) : super(key: key);

  /// TODO: document me
  final TextEditingController textEditingController;

  /// TODO: document me
  final OnSend onSend;

  /// TODO: document me
  final String label;

  final ButtonStyle? buttonStyle;

  @override
  _ReactiveElevatedButtonState createState() => _ReactiveElevatedButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>(
        'textEditingController', textEditingController));
    properties.add(ObjectFlagProperty<OnSend>.has('onSend', onSend));
    properties.add(StringProperty('label', label));
  }
}

class _ReactiveElevatedButtonState extends State<ReactiveElevatedButton> {
  late final StreamController<String> _textUpdates = StreamController<String>();

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(() {
      _textUpdates.add(widget.textEditingController.value.text);
    });
  }

  @override
  void dispose() {
    _textUpdates.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _textUpdates.stream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            // Dis/enabled button if textInputValue.length> 0
            onPressed: snapshot.hasData && snapshot.data!.isNotEmpty
                ? () async {
                    await widget.onSend(snapshot
                        .data!); //TODO clear controller once future done
                    widget.textEditingController.clear();
                  }
                : null,
            style: widget.buttonStyle,
            child: Text(widget.label),
          ),
        );
      },
    );
  }
}
