import 'package:flutter/material.dart';

/// TODO: document me
List<Widget> handleDisplay(
    Map<String, Object?>? data, String jsonKey, TextStyle style) {
  return data?[jsonKey] != null
      ? [
          Text(data?[jsonKey] as String, style: style),
          const SizedBox(width: 4),
        ]
      : [const Offstage()];
}
