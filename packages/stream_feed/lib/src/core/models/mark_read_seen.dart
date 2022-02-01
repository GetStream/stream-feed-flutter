import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum ReadState { all, current, ids }

class MarkRead extends Equatable {
  final List<String>? ids;
  final ReadState readState;
  const MarkRead({this.ids, this.readState = ReadState.ids});

  factory MarkRead.fromJson(dynamic markRead) {
    MarkRead? result;
    if (markRead is List) {
      result = MarkRead(
        ids: List<String>.from(markRead.map((x) => x)),
      );
    }
    if (markRead is String) {
      result = MarkRead(
        readState: markRead == 'all' ? ReadState.all : ReadState.current,
      );
    }
    return result!;
  }

  Map<String, dynamic> toJson() => {
        "mark_read": readState == ReadState.ids ? ids : readState.name,
      };

  @override
  List<Object?> get props => [ids, readState];
}

class MarkSeen extends Equatable {
  final List<String>? ids;
  final ReadState readState;
  const MarkSeen({this.ids, this.readState = ReadState.ids});

  factory MarkSeen.fromJson(dynamic markSeen) {
    MarkSeen? result;
    if (markSeen is List) {
      result = MarkSeen(
        ids: List<String>.from(markSeen.map((x) => x)),
      );
    }
    if (markSeen is String) {
      result = MarkSeen(
        readState: markSeen == 'all' ? ReadState.all : ReadState.current,
      );
    }
    return result!;
  }

  Map<String, dynamic> toJson() => {
        "mark_seen": readState == ReadState.ids ? ids : readState.name,
      };

  @override
  List<Object?> get props => [ids, readState];
}
