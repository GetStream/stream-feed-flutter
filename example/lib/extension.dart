import 'package:example/client_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';

//ignore: public_member_api_docs
extension ProviderX on BuildContext {
  //ignore: public_member_api_docs
  StreamFeedClient get client => ClientProvider.of(this).client;
}

//ignore: public_member_api_docs
extension Snackbar on BuildContext {
  //ignore: public_member_api_docs
  void showSnackBar(final String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}
