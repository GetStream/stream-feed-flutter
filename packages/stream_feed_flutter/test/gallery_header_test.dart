import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  testWidgets('find GalleryHeader\'s AppBar and no back button',
      (widgetTester) async {
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

  testWidgets('final GalleryHeader\'s back button', (widgetTester) async {
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

  testWidgets('find GalleryHeader title text', (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamFeedTheme(
          data: StreamFeedThemeData.light(),
          child: child!,
        ),
        home: const Scaffold(
          appBar: GalleryHeader(
            totalMedia: 1,
          ),
        ),
      ),
    );

    expect(find.byType(Text), findsOneWidget);
    expect(find.text('1 of 1'), findsOneWidget);
  });
}
