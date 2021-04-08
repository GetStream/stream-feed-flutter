import 'package:equatable/equatable.dart';
import 'package:stream_feed_dart/src/core/util/extension.dart';

///
class ForeignIdTimePair extends Equatable {
  ///
  const ForeignIdTimePair(this.foreignID, this.time);

  ///
  final String foreignID;

  ///
  final DateTime time;

  ///
  static List<ForeignIdTimePair> fromList(List? pairs) {
    if (pairs == null || pairs.isEmpty) return [];
    return pairs.map((it) {
      final pair = it as List;
      checkArgument(pair.length == 2, 'Invalid foreignIdTime pair');
      final foreignId = pair[0] as String;
      final time = DateTime.parse(pair[1] as String);
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
