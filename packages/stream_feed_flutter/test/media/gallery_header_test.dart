import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  testWidgets('find GalleryHeader\'s AppBar and no back button',
      (tester) async {
    await tester.pumpWidget(
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

  testWidgets('final GalleryHeader\'s back button', (tester) async {
    await tester.pumpWidget(
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

  testWidgets('find GalleryHeader title text', (tester) async {
    await tester.pumpWidget(
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

  testWidgets('GalleryHeader debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const GalleryHeader().debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'showBackButton: true',
        'currentIndex: 0',
        'totalMedia: null',
        'backgroundColor: null',
      ],
    );
  });
}
