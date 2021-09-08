import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  testWidgets('GalleryHeader with no back button', (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamFeedTheme(
          data: StreamFeedThemeData.light(),
          child: child!,
        ),
        home: const Scaffold(
          appBar: GalleryHeader(
            showBackButton: false,
          ),
        ),
      ),
    );

    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('GalleryHeader with back button', (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamFeedTheme(
          data: StreamFeedThemeData.light(),
          child: child!,
        ),
        home: const Scaffold(
          appBar: GalleryHeader(),
        ),
      ),
    );

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
  });
}