// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_activities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedActivities<A, Ob, T, Or> _$PaginatedActivitiesFromJson<A, Ob, T, Or>(
  Map json,
  A Function(Object? json) fromJsonA,
  Ob Function(Object? json) fromJsonOb,
  T Function(Object? json) fromJsonT,
  Or Function(Object? json) fromJsonOr,
) =>
    PaginatedActivities<A, Ob, T, Or>(
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

Map<String, dynamic> _$PaginatedActivitiesToJson<A, Ob, T, Or>(
  PaginatedActivities<A, Ob, T, Or> instance,
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
    };
