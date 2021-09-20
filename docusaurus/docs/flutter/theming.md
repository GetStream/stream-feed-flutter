# Stream Feed and Theming

## Background
It is easy for developers to add custom styles and attributes to the widgets found in `stream_chat_flutter`. Like most Flutter frameworks, a dedicated widget is exposed for theming.

Using `StreamFeedTheme`, developers can customize most aspects of our UI widgets by setting attributes via the `StreamChatThemeData` class.

Similar to the `Theme` and `ThemeData` classes in the Flutter SDK, `stream_chat_flutter` uses a top-level [inherited widget](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) to provide theming information throughout your application. This can be optionally set at the top of your application's widget tree or at a localized point in your widget sub-tree.

If you'd like to customize the look and feel of Stream Feed across your entire application, we recommend setting your theme at the top level. Conversely, users can customize specific screens or widgets by wrapping components in a `StreamFeedTheme`.

## A Closer Look at `StreamChatThemeData`

Looking at the constructor for `StreamChatThemeData`, we can see the full list of properties and widgets available for customization.

```dart
factory StreamFeedThemeData({
  Brightness? brightness,
  ChildReactionThemeData? childReactionTheme,
  ReactionThemeData? reactionTheme,
  IconThemeData? primaryIconTheme,
  GifDialogThemeData? gifDialogTheme,
  OgCardThemeData? ogCardTheme,
  UserBarThemeData? userBarTheme,
  GalleryHeaderThemeData? galleryHeaderTheme,
})
```

Each of these custom `ThemeData` classes come with their own [inherited theme](https://api.flutter.dev/flutter/widgets/InheritedTheme-class.html) widgets to provide you with even more flexible theming capabilities

## Stream Feed Theme in Use

Let's take a look at customizing widgets using `StreamFeedTheme`.

### Top-Level Theming
The following example sits in the `MaterialApp` and uses the `MaterialApp.builder` property to insert the theme above the widget tree.
```dart
builder: (context, child) {
  return StreamFeedTheme(
    data: StreamFeedThemeData(
      brightness: Brightness.dark,
    ),
    child: child!,
  );
},
```

### Low-Level Theming
The following example builds a `StreamFeedTheme` at some point in the
widget subtree.
```dart
return StreamFeedTheme(
  data: StreamFeedThemeData(
    brightness: Brightness.light,
  ),
  child: Scaffold(
    body: MyFeed(),
  ),
);
```

You can also use the individual theme widgets like so:
```dart
return UserBarTheme(
  data: UserBarThemeData(
    avatarSize: 40,
  ),
  child: Scaffold(
    body: MyFeed(),
  ),
);
```
This code will tell all `UserBar()` widgets below this point in the tree that their `avatarSize` should be `40`.