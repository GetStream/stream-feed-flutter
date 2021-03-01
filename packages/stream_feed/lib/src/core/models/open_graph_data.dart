import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'open_graph_data.g.dart';

///
@JsonSerializable(createToJson: false)
class OpenGraphData extends Equatable {
  ///
  final String title;

  ///
  final String type;

  ///
  final String url;

  ///
  final String site;

  ///
  final String siteName;

  ///
  final String description;

  ///
  final String determiner;

  ///
  final String locale;

  ///
  final List<Image> images;

  ///
  final List<Video> videos;

  ///
  final List<Audio> audios;

  ///
  const OpenGraphData({
    this.title,
    this.type,
    this.url,
    this.site,
    this.siteName,
    this.description,
    this.determiner,
    this.locale,
    this.images,
    this.videos,
    this.audios,
  });

  @override
  List<Object> get props => [
        title,
        type,
        url,
        site,
        siteName,
        description,
        determiner,
        locale,
        images,
        videos,
        audios,
      ];

  /// Create a new instance from a json
  factory OpenGraphData.fromJson(Map<String, dynamic> json) =>
      _$OpenGraphDataFromJson(json);
}

///
@JsonSerializable(createToJson: true)
class Image extends Equatable {
  ///
  final String image;

  ///
  final String url;

  ///
  final String secureUrl;

  ///
  final String width;

  ///
  final String height;

  ///
  final String type;

  ///
  final String alt;

  ///
  const Image({
    this.image,
    this.url,
    this.secureUrl,
    this.width,
    this.height,
    this.type,
    this.alt,
  });

  @override
  List<Object> get props => [
        image,
        url,
        secureUrl,
        width,
        height,
        type,
        alt,
      ];

  /// Create a new instance from a json
  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ImageToJson(this);
}

///
@JsonSerializable(createToJson: false)
class Video extends Equatable {
  ///
  final String image;

  ///
  final String url;

  ///
  final String secureUrl;

  ///
  final String width;

  ///
  final String height;

  ///
  final String type;

  ///
  final String alt;

  ///
  const Video({
    this.image,
    this.url,
    this.secureUrl,
    this.width,
    this.height,
    this.type,
    this.alt,
  });

  @override
  List<Object> get props => [
        image,
        url,
        secureUrl,
        width,
        height,
        type,
        alt,
      ];

  /// Create a new instance from a json
  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
}

///
@JsonSerializable(createToJson: false)
class Audio extends Equatable {
  ///
  final String audio;

  ///
  final String url;

  ///
  final String secureUrl;

  ///
  final String type;

  ///
  const Audio({
    this.audio,
    this.url,
    this.secureUrl,
    this.type,
  });

  @override
  List<Object> get props => [
        audio,
        url,
        secureUrl,
        type,
      ];

  /// Create a new instance from a json
  factory Audio.fromJson(Map<String, dynamic> json) => _$AudioFromJson(json);
}
