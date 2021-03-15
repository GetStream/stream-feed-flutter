import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'open_graph_data.g.dart';

///
@JsonSerializable(createToJson: true)
class OpenGraphData extends Equatable {
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

  /// Create a new instance from a json
  factory OpenGraphData.fromJson(Map<String, dynamic> json) =>
      _$OpenGraphDataFromJson(json);

  ///
  final String? title;

  ///
  final String? type;

  ///
  final String? url;

  ///
  final String? site;

  ///
  final String? siteName;

  ///
  final String? description;

  ///
  final String? determiner;

  ///
  final String? locale;

  ///
  final List<Image>? images;

  ///
  final List<Video>? videos;

  ///
  final List<Audio>? audios;

  @override
  List<Object?> get props => [
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

  /// Serialize to json
  Map<String, dynamic> toJson() => _$OpenGraphDataToJson(this);
}

///
@JsonSerializable(createToJson: true)
class Image extends Equatable {
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

  /// Create a new instance from a json
  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  ///
  final String? image;

  ///
  final String? url;

  ///
  final String? secureUrl;

  ///
  final String? width;

  ///
  final String? height;

  ///
  final String? type;

  ///
  final String? alt;

  @override
  List<Object?> get props => [
        image,
        url,
        secureUrl,
        width,
        height,
        type,
        alt,
      ];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ImageToJson(this);
}

///
@JsonSerializable(createToJson: true)
class Video extends Equatable {
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

  /// Create a new instance from a json
  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  ///
  final String? image;

  ///
  final String? url;

  ///
  final String? secureUrl;

  ///
  final String? width;

  ///
  final String? height;

  ///
  final String? type;

  ///
  final String? alt;

  @override
  List<Object?> get props => [
        image,
        url,
        secureUrl,
        width,
        height,
        type,
        alt,
      ];

  /// Serialize to json
  Map<String, dynamic> toJson() => _$VideoToJson(this);
}

///
@JsonSerializable(createToJson: true)
class Audio extends Equatable {
  ///
  const Audio({
    this.audio,
    this.url,
    this.secureUrl,
    this.type,
  });

  /// Create a new instance from a json
  factory Audio.fromJson(Map<String, dynamic> json) => _$AudioFromJson(json);
  Map<String, dynamic> toJson() => _$AudioToJson(this);

  ///
  final String? audio;

  ///
  final String? url;

  ///
  final String? secureUrl;

  ///
  final String? type;

  @override
  List<Object?> get props => [
        audio,
        url,
        secureUrl,
        type,
      ];
}
