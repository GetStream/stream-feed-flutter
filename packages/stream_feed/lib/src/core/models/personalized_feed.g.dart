// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personalized_feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalizedFeed<A, Ob, T, Or> _$PersonalizedFeedFromJson<A, Ob, T, Or>(
  Map json,
  A Function(Object? json) fromJsonA,
  Ob Function(Object? json) fromJsonOb,
  T Function(Object? json) fromJsonT,
  Or Function(Object? json) fromJsonOr,
) =>
    PersonalizedFeed<A, Ob, T, Or>(
      version: json['version'] as String,
      offset: json['offset'] as int,
      limit: json['limit'] as int,
      next: json['next'] as String?,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => GenericEnrichedActivity<A, Ob, T, Or>.fromJson(
              (e as Map?)?.map(
                (k, e) => MapEntry(k as String, e),
              ),
              (value) => fromJsonA(value),
              (value) => fromJsonOb(value),
              (value) => fromJsonT(value),
              (value) => fromJsonOr(value)))
          .toList(),
      duration: json['duration'] as String?,
    );

Map<String, dynamic> _$PersonalizedFeedToJson<A, Ob, T, Or>(
  PersonalizedFeed<A, Ob, T, Or> instance,
  Object? Function(A value) toJsonA,
  Object? Function(Ob value) toJsonOb,
  Object? Function(T value) toJsonT,
  Object? Function(Or value) toJsonOr,
) =>
    <String, dynamic>{
      'next': instance.next,
      'results': instance.results
          ?.map((e) => e.toJson(
                (value) => toJsonA(value),
                (value) => toJsonOb(value),
                (value) => toJsonT(value),
                (value) => toJsonOr(value),
              ))
          .toList(),
      'duration': instance.duration,
      'version': instance.version,
      'offset': instance.offset,
      'limit': instance.limit,
    };
