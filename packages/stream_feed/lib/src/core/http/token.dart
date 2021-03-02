import 'package:equatable/equatable.dart';

class Token extends Equatable {
  const Token(this.token);

  final String token;

  @override
  List<Object> get props => [token];

  @override
  String toString() => token;
}
