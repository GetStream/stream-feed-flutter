import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ProgressDialogHelper {
  static ProgressDialog _dialog;

  static Future<bool> show(
    BuildContext context, {
    String message = 'Please Wait !',
    bool isDismissible = false,
  }) {
    _dialog ??= ProgressDialog(context, isDismissible: isDismissible)
      ..style(
        message: message,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
      );
    return _dialog.show();
  }

  static void update({String message, Widget progressWidget}) =>
      _dialog?.update(
        message: message,
        progressWidget: progressWidget,
      );

  static Future<bool> hide() => _dialog.hide()..then((_) => _dialog = null);
}
