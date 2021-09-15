import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'open_graph_data.g.dart';

/// {@template open_graph}
/// Open graph data from a website.
///
/// An Open Graph data object is a set of key-value pairs that describe a
/// web page. It can be used to describe the content of a page, the author of
/// the page, or the page itself.
/// {@endtemplate}
@JsonSerializable(createToJson: true)
class OpenGraphData extends Equatable {
  /// Builds an [OpenGraphData].
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

  ///	Value of the title OG field.
  ///
  /// The title is usually short and descriptive.
  final String? title;

  /// Value of the OG field `type`
  ///
  /// The type can be one of the following:
  /// - Article
  /// - ArticlePage
  /// - Audio
  /// - Event
  /// - Music
  /// - etc
  final String? type;

  /// URL to scrape.
  ///
  /// The URL is used to scrape the page.
  final String? url;

  /// Value of the site OG field
  ///
  /// The site is the name of the website.
  /// It is used to identify the website.
  /// It is usually the domain name of the website.
  final String? site;

  /// Value of the site_name OG field.
  ///
  /// It is usually the domain name of the website.
  final String? siteName;

  ///	Value of the description OG field.
  ///
  /// It is used to describe the content of a page, the author of the page,
  /// or the page itself.
  final String? description;

  ///	Value of the determiner OG field.
  final String? determiner;

  /// Value of the locale OG field.
  ///
  /// It is used to describe the language of the content.
  final String? locale;

  ///	List of og images
  final List<OgImage>? images;

  ///	List of og videos
  final List<OgVideo>? videos;

  ///	List of og audios
  final List<OgAudio>? audios;

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

/// OG Image object
@JsonSerializable(createToJson: true)
class OgImage extends Equatable {
  /// Builds an [OgImage].
  const OgImage({
    this.image,
    this.url,
    this.secureUrl,
    this.width,
    this.height,
    this.type,
    this.alt,
  });

  /// Create a new instance from a json
  factory OgImage.fromJson(Map<String, dynamic> json) =>
      _$OgImageFromJson(json);

  /// Value of the image OG field.
  final String? image;

  ///	Value of the url OG field.
  final String? url;

  /// Value of the secure_url OG field.
  final String? secureUrl;

  /// Value of the width OG field.
  final String? width;

  ///	Value of the height OG field.
  final String? height;

  /// Value of the type OG field.
  ///
  /// It is used to describe the type of an image.
  /// It can be one of the following:
  /// - icon
  /// - logo
  /// - photo
  /// - etc
  final String? type;

  /// Value of the alt OG field.
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
  Map<String, dynamic> toJson() => _$OgImageToJson(this);
}

/// OG Video object
@JsonSerializable(createToJson: true)
class OgVideo extends Equatable {
  /// Builds an [OgVideo].
  const OgVideo({
    this.image,
    this.url,
    this.secureUrl,
    this.width,
    this.height,
    this.type,
    this.alt,
  });

  /// Create a new instance from a json
  factory OgVideo.fromJson(Map<String, dynamic> json) =>
      _$OgVideoFromJson(json);

  /// Value of the image OG field.
  final String? image;

  /// Value of the url OG field.
  final String? url;

  ///	Value of the secure_url OG field.
  final String? secureUrl;

  /// Value of the width OG field.
  final String? width;

  /// Value of the height OG field.
  final String? height;

  /// Value of the type OG field.
  ///
  /// It is used to describe the type of a video.
  /// It can be one of the following:
  /// - mp4
  /// - ogv
  /// - etc
  final String? type;

  /// Value of the alt OG field.
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
  Map<String, dynamic> toJson() => _$OgVideoToJson(this);
}

/// OG Audio object
@JsonSerializable(createToJson: true)
class OgAudio extends Equatable {
  /// Builds an [OgAudio].
  const OgAudio({
    this.audio,
    this.url,
    this.secureUrl,
    this.type,
  });

  /// Create a new instance from a json
  factory OgAudio.fromJson(Map<String, dynamic> json) =>
      _$OgAudioFromJson(json);

  /// Serialize to json the [Audio] object
  Map<String, dynamic> toJson() => _$OgAudioToJson(this);

  /// Value of the audio OG field.
  final String? audio;

  /// Value of the url OG field.
  final String? url;

  /// Value of the secureUrl OG field.
  final String? secureUrl;

  /// Value of the type OG field.
  ///
  /// It is used to describe the type of an audio.
  /// It can be one of the following:
  /// - mp3
  /// - ogg
  /// - etc
  final String? type;

  @override
  List<Object?> get props => [
        audio,
        url,
        secureUrl,
        type,
      ];
}
