import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';

import 'client_provider.dart';

extension ProviderX on BuildContext {
  StreamClient get client => ClientProvider.of(this).client;
}

extension Snackbar on BuildContext {
  void showSnackBar(final String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}
