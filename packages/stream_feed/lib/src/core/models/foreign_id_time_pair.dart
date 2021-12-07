import 'package:equatable/equatable.dart';
import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/src/core/util/utc_converter.dart';

/// A model that wraps [foreignID] and [time]
class ForeignIdTimePair extends Equatable {
  /// Builds a [ForeignIdTimePair].
  const ForeignIdTimePair(this.foreignID, this.time);

  static const _converter = DateTimeUTCConverter();

  /// The foreign id of an activity
  final String foreignID;

  /// The time of the activity
  final DateTime time;

  ///
  static List<ForeignIdTimePair> fromList(List? pairs) {
    if (pairs == null || pairs.isEmpty) return [];
    return pairs.map((it) {
      final pair = it as List;
      checkArgument(pair.length == 2, 'Invalid foreignIdTime pair');
      final foreignId = pair[0] as String;
      final time = _converter.fromJson(pair[1] as String);
      return ForeignIdTimePair(foreignId, time);
    }).toList(growable: false);
  }

  ///
  static List<List> toList(List<ForeignIdTimePair>? pairs) {
    if (pairs == null || pairs.isEmpty) return [];
    return pairs
        .map((it) => [it.foreignID, it.time.toIso8601String()])
        .toList(growable: false);
  }

  @override
  List<Object> get props => [foreignID];
}
