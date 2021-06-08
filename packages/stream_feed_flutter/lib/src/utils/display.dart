import 'package:flutter/material.dart';

List<Widget> handleDisplay(
    Map<String, Object>? data, String jsonKey, TextStyle style) {
  return data?[jsonKey] != null
      ? [
          Text(data?[jsonKey] as String, style: style),
          SizedBox(
            width: 4.0,
          ),
        ]
      : [Offstage()];
}
