import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collection_entry.g.dart';

///
@JsonSerializable()
class CollectionEntry extends Equatable {
  ///
  final String id;

  ///
  final String collection;

  ///
  final String foreignId;

  ///
  final Map<String, Object> data;

  ///
  final DateTime createdAt;

  ///
  final DateTime updatedAt;

  ///
  const CollectionEntry({
    this.id,
    this.collection,
    this.foreignId,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object> get props => [
        id,
        collection,
        foreignId,
        data,
        createdAt,
        updatedAt,
      ];

  CollectionEntry copyWith({
    String id,
    String collection,
    String foreignId,
    Map<String, Object> data,
    DateTime createdAt,
    DateTime updatedAt,
  }) {
    return CollectionEntry(
      id: id ?? this.id,
      collection: collection ?? this.collection,
      foreignId: foreignId ?? this.foreignId,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Create a new instance from a json
  factory CollectionEntry.fromJson(Map<String, dynamic> json) =>
      _$CollectionEntryFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$CollectionEntryToJson(this);
}
