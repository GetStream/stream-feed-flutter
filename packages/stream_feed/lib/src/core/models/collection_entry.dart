import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collection_entry.g.dart';

///
@JsonSerializable()
class CollectionEntry extends Equatable {
  ///
  const CollectionEntry({
    this.id,
    this.collection,
    this.foreignId,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  /// Create a new instance from a json
  factory CollectionEntry.fromJson(Map<String, dynamic> json) =>
      _$CollectionEntryFromJson(json);

  /// Collection object ID
  final String? id;

  /// Collection name
  final String? collection;

  /// ForeignID of the collection object
  final String? foreignId;

  /// Collection object data
  final Map<String, Object>? data;

  /// When the collection object was created.
  final DateTime? createdAt;

  /// When the collection object was last updated.
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        id,
        collection,
        foreignId,
        data,
        createdAt,
        updatedAt,
      ];

  ///allows us to copy a CollectionEntry
  ///and pass in arguments that overwrite settable values.
  CollectionEntry copyWith({
    String? id,
    String? collection,
    String? foreignId,
    Map<String, Object>? data,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      CollectionEntry(
        id: id ?? this.id,
        collection: collection ?? this.collection,
        foreignId: foreignId ?? this.foreignId,
        data: data ?? this.data,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  /// Serialize to json
  Map<String, dynamic> toJson() => _$CollectionEntryToJson(this);
}
