import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/feed_bloc.dart';

/// {@template feedProvider}
/// Inherited widget providing the [FeedBloc] to the widget tree
/// Usually what you need is the convenient [FeedProvider] that already
/// has the default parameters defined for you
/// suitable to most usecases. But if you need a
/// more advanced use case use [GenericFeedProvider] instead. Make sure you
/// instantiate it only once.
/// {@endtemplate}
///
class FeedProvider extends GenericFeedProvider<User, String, String, String> {
  const FeedProvider({
    Key? key,
    required FeedBloc bloc,
    required Widget child,
  }) : super(key: key, bloc: bloc, child: child);

  @override
  FeedBloc get bloc => super.bloc as FeedBloc;

  static FeedProvider of(BuildContext context) {
    return GenericFeedProvider<User, String, String, String>.of(context)
        as FeedProvider;
  }
}

/// The generic version of [FeedProvider]
///
/// {@macro feedProvider}
/// {@macro genericParameters}
class GenericFeedProvider<A, Ob, T, Or> extends InheritedWidget {
  /// {@macro feedProvider}
  const GenericFeedProvider({
    Key? key,
    required this.bloc,
    required Widget child,
  }) : super(key: key, child: child);

  /// Obtains the nearest widget of type [GenericFeedProvider<A, Ob, T, Or>]
  factory GenericFeedProvider.of(BuildContext context) {
    var result = context.dependOnInheritedWidgetOfExactType<
        GenericFeedProvider<A, Ob, T, Or>>();
    result ??= context.dependOnInheritedWidgetOfExactType<FeedProvider>()
        as GenericFeedProvider<A, Ob, T, Or>?;
    assert(result != null,
        '''No `FeedProvider` or `GenericFeedProvider<$A, $Ob, $T, $Or>` found in context''');
    return result!;
  }

  final GenericFeedBloc<A, Ob, T, Or> bloc;

  @override
  bool updateShouldNotify(GenericFeedProvider old) => bloc != old.bloc; //

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<GenericFeedBloc<A, Ob, T, Or>>('bloc', bloc));
  }
}
