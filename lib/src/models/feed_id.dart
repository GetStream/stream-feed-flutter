import 'package:equatable/equatable.dart';

class FeedId extends Equatable {
  final String slug;
  final String userId;

  const FeedId(this.slug, this.userId);

  String get claim => '$slug$userId';

  @override
  List<Object> get props => [slug, userId];

  @override
  String toString() => '$slug:$userId';
}
