import 'package:equatable/equatable.dart';

///
class Follow extends Equatable {
  ///
  final String source;

  ///
  final String target;

  ///
  const Follow(this.source, this.target);

  @override
  List<Object> get props => [source, target];
}

///
class UnFollow extends Follow {
  ///
  final bool keepHistory;

  ///
  const UnFollow(String source, String target, this.keepHistory)
      : super(source, target);

  ///
  factory UnFollow.fromFollow(Follow follow, bool keepHistory) {
    return UnFollow(follow.source, follow.target, keepHistory);
  }

  @override
  List<Object> get props => [...super.props, keepHistory];
}
