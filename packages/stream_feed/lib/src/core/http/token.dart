import 'package:equatable/equatable.dart';

//TODO change this to typedef in dart 2.13
class Token extends Equatable {
  const Token(this.token);

  final String token;

  @override
  List<Object> get props => [token];

  @override
  String toString() => token;
}
