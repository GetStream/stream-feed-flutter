import 'package:equatable/equatable.dart';

//TODO change this to typedef in dart 2.13
///	The JWT auth token for a specific feed.
///
/// It is created by signing the base 64 encoded JWT header and payload with
/// the api_secret
///
/// For example: yuXEO2nNOrcwd36sgq8nMC1e2qU
class Token extends Equatable {
  /// Instantiates a new [Token]
  const Token(this.token);

  /// The underlying token
  final String token;

  @override
  List<Object> get props => [token];

  @override
  String toString() => token;
}
