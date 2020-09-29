import 'package:equatable/equatable.dart';

///
class ForeignIdTimePair extends Equatable {
  ///
  final String foreignID;

  ///
  final DateTime time;

  ///
  const ForeignIdTimePair(this.foreignID, this.time);

  @override
  List<Object> get props => [foreignID];
}
