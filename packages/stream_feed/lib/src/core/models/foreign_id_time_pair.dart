import 'package:equatable/equatable.dart';

///
class ForeignIdTimePair extends Equatable {
  ///
  const ForeignIdTimePair(this.foreignID, this.time);

  ///
  final String foreignID;

  ///
  final DateTime time;

  @override
  List<Object> get props => [foreignID];
}
