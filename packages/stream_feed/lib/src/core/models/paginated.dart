import 'package:equatable/equatable.dart';

/// A general paginated response object.
class Paginated<T> extends Equatable {
  /// [Paginated] constructor
  const Paginated(this.next, this.results, this.duration);

  /// A url string that can be used to fetch the next page of reactions.
  final String? next;

  /// Response results of generic objects.
  final List<T>? results;

  /// A duration of the response.
  final String? duration;

  @override
  List<Object?> get props => [next, results, duration];
}
