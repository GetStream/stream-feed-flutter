import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/util/utc_converter.dart';
import 'package:stream_feed/stream_feed.dart';

part 'collection_entry.g.dart';

/// Collections enable you to store information to Stream.
///
/// This allows you to use it inside your feeds and to provide additional data
/// for the personalized endpoints.
///
/// Examples include products and articles, but any unstructured object
/// (e.g. JSON) is a good match for collections.
///
/// Collection entries can be embedded inside activities and used to store
/// nested data inside activities. When doing so, Stream will automatically
/// enrich your activities with the current version of the data
/// (see later section).
///
/// Collection endpoints can be used both client-side and server-side except
/// the batch methods that are only available server-side.
@JsonSerializable()
@DateTimeUTCConverter()
class CollectionEntry extends Equatable {
  /// Builds a [CollectionEntry].
  const CollectionEntry({
    this.id,
    this.collection,
    this.foreignId,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  /// Create a new instance from a JSON object
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

  /// Handy getter to refer to the collection object for enrichment purposes
  String get ref => createCollectionReference(collection, id);

  @override
  List<Object?> get props => [
        id,
        collection,
        foreignId,
        data,
        createdAt,
        updatedAt,
      ];

  /// Copies this [CollectionEntry] to a new instance.
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

  /// Serialize to JSON
  Map<String, dynamic> toJson() => _$CollectionEntryToJson(this);
}
